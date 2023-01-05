#This code reuses code chunks from WallabyKingdom's super helpful tutorial
#https://rstudio-pubs-static.s3.amazonaws.com/773313_1239374979da45659947571649f15ead.html
#which shows how to access and manipulate match-level data in R straight from Riot API. 

#Marlie Tandoc Dec 2022
#I have updated this code to reflect recent changes to the API (using puuids instead of account_ids, requiring match_ids before getting match data etc.)
#And to specifically fetch the data that I want. It also now gets from NA servers. not EU


#### SET UP ####

library(httr)
library(jsonlite)
library(data.table)
library(stringr)
library(tidyverse)
library(knitr)

options(dplyr.print_max = 1e9)
data_path <- "Data/"

riot_api_fetching <- function(x) {
  key <- "" #Enter private API key here as string 
  url <- paste0(x, key)
  json <- GET(url = url)
  raw <- rawToChar(json$content)
  fromJSON(raw)
}
delimiter <- "?api_key="
delimiter2 <- "&api_key="


ms_to_date <- function(ms, t0="1970-01-01") {
  ## @ms: a numeric vector of milliseconds (big integers of 13 digits)
  ## @t0: a string of the format "yyyy-mm-dd", specifying the date that
  ##      corresponds to 0 millisecond
  ## @timezone: a string specifying a timezone that can be recognized by R
  ## return: a POSIXt vector representing calendar dates and times
  sec <- ms / 1000
  as.POSIXct(sec, origin = t0, tz = "CET")
}



#### GET ACCOUNT IDS #### 
#Accounts for divisions
tier <- c("IRON", "BRONZE", "SILVER", "GOLD", "PLATINUM", "DIAMOND")
division <- c("IV", "III", "II", "I")

# #Data Dragon
champion_dd <- fromJSON("http://ddragon.leagueoflegends.com/cdn/11.10.1/data/en_US/championFull.json")


load_data <- function(name_df) {
  readRDS(list.files(data_path, pattern = name_df, full.names = TRUE))
}


#Number of accounts you want per division
accounts_per_divison <- 200

combinations_df <- expand.grid(division, tier)
combinations_list <- list()
for (i in seq_len(nrow(combinations_df))) {
  combinations_list[[i]] <- combinations_df[i, ]
}

accounts <- lapply(combinations_list, function(x) {
  Sys.sleep(1.3)
  division <- x[1, 1]
  tier <- x[1, 2]
  print(x)
  return(riot_api_fetching(
    paste0("https://na1.api.riotgames.com/lol/league/v4/entries/RANKED_SOLO_5x5/", tier, "/",  division, "?page=3", delimiter2)))
})



for (i in seq_along(accounts)) {
  accounts[[i]] <- accounts[[i]][seq_len(accounts_per_divison), ]
}
full_accounts <- do.call(bind_rows, accounts)


###Join account_id in full_accounts
names <- str_remove_all(full_accounts$summonerName, " ")

#summoner ids
ids <- full_accounts$summonerId



#If want to get match-level data need to additionally fetch puuids via a different route
#This uses summoner name to get their puuid (which is required to find match data)
add <- lapply(names, function(x) {
  summoner <- riot_api_fetching(paste0("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/", x, delimiter))
  #acc_id <- summoner$accountId
  puuid <- summoner$puuid
  #print(x)
  if (which(x == names) %% 200 == 0) {
    print(paste(which(x == names), "/", length(names), "@", format(Sys.time(), "%H:%M:%S")))
  }
  Sys.sleep(1.3)
  #return(acc_id)
  return(puuid)
})

non_empty <- vector()
for (i in seq_along(add)) {
  non_empty[i] <- !(is.null(add[[i]]))
}

#Can see if we failed to retrieve puuids for certain summoners 
missings <- ggplot(as.data.frame(cbind(non_empty, nrow = seq_along(non_empty))), aes(nrow, as.logical(non_empty))) +
  geom_jitter()
missings
ggsave("summoner-names.png", missings, dpi = 1200, units = "cm", width = 30, height = 20)

to_add <- do.call(rbind, add)
full_accounts2 <- full_accounts %>% select(-miniSeries) %>% filter(non_empty) %>% cbind(to_add) %>% rename(acc_id = to_add)

#Puuids (these are account IDs now)
puuids <- as.character(full_accounts2$acc_id)
length(puuids) #Number of unique summoners we have

#Next step we should save all tehse puuids
#Also check where rank information is being stored?
queue <- "420" #Ranked solo queue
start <- "0" #Start fetching at most recent match
count <- "50" #Number of past matches you want for each summoners


#### GET MATCH IDS ####

#According to v5 changes this now gets MATCH IDS (not match data)
matches <- lapply(puuids, function(x) {

  Sys.sleep(1.3)
  match_id <- riot_api_fetching(paste0("https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/", x, "/ids?queue=",
                                queue, "&count=", count, "&start=",
                                start, delimiter2))
  
  if (which(x == puuids) %% 200 == 0) {
    print(paste(which(x == puuids), "/", length(puuids), "@", format(Sys.time(), "%H:%M:%S")))
  }
  
  return(match_id)
  
})

#Later we can directly map on puuids (same index) onto match list index.. to know which person is what thing
closeAllConnections()

#Now that we have match ID's we want to determine the unique matches (in case there are duplicate matches we don't need to fetch that data twice)
match_id_vec <- unlist(matches)
unique_matches <- unique(match_id_vec)

#Number of matches which had summoners overlap (because they were duplicated)
match_overlap_num <- length(match_id_vec) - length(unique_matches)

#Save match data
#write.csv(unique_matches, 'match_list_dec_22.csv')


#### GET MATCH DATA ####

#This actually gets all the match data (which is different in v5)
#This is the data we will be analyzing so we want to store it all in one big dataframe where each row is a summoner

#lets do 200 matches a time for now
unique_matches <- unique_matches[1:200]

match_data <- lapply(unique_matches, function(x) {
  
  if (which(x == unique_matches) %% 200 == 0) {
    print(paste(which(x == unique_matches), "/", length(unique_matches), "@", format(Sys.time(), "%H:%M:%S")))
  }
  
  Sys.sleep(1.3)
 
  #Fetch full match info
  match_info <- riot_api_fetching(paste0("https://americas.api.riotgames.com/lol/match/v5/matches/", x, delimiter))
  
  #Gather game information at the participant (summoner level), will be a dataframe with 10 rows (for the 10 summoners)
  participant_info <- match_info$info$participants %>%
    mutate(match_id = x) #Append match id to all rows
  return(participant_info)
  
})


data <- bind_rows(match_data, .id = "column_label")

#Lets see how much data we got for each summoner
sum_level <- data %>%
  group_by(puuid) %>%
  summarize(count = length(puuid),
            champs_played =  championName)

#Lets quickly see what champs put the most wards
champ_level <- data %>%
  group_by(championName) %>%
  summarize(number_of_games = length(championName),
            num_wards_placed = sum(wardsPlaced)) %>%
  mutate(wards_per_game = num_wards_placed/number_of_games)


#Doesnt look liek it?
game_level <- data %>%
  group_by(match_id,teamId) %>%
  summarize(total_wards = sum(wardsPlaced),
            win = win[1]) %>%
  mutate(win_bin = ifelse(win, 1,0))

winners <- game_level %>%
  group_by(win_bin) %>%
  summarize(average_wards_placed = mean(total_wards),
            median_wards = median(total_wards))


#Or how about average number of wards placed per game

x <- glm(win_bin ~total_wards, game_level, family = 'binomial')
summary(x)



#### GET MASTERY DATA ####

masteries <- lapply(ids, function(x) {
  
  Sys.sleep(1.3)
  mastery <- riot_api_fetching(paste0("https://na1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/", x, delimiter))
  
  
  if (which(x == ids) %% 200 == 0) {
    print(paste(which(x == ids), "/", length(ids), "@", format(Sys.time(), "%H:%M:%S")))
  }
  
  return(mastery)
  
})
mastery_data <-  bind_rows(masteries, .id = "column_label")








