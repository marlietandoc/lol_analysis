# League of Legends: Patterns across players in champion mains

League offers a lot of choice in terms of playstyle. Players seem to naturally "fall into" liking certain roles and champions. I was curious if we can extract some of these preferences in a data-driven way (by looking at mastery and match data). Do players prefer playing certain kinds of champions? Are there patterns in what kinds of champs players tend to  main? For example, I have always played squishy, pokey, mage champions, and dislike playing all-in assassins or tanks. This could also be the start of a champion recommender, or be used to generate additional insights into certain player preferences.

<strong> What I did </strong>
1. Pulled match-level and amstery data from Riot's APIS for thousands of summoners and their most recent matches (scripts to fetch API data found in the API_fetch folder)
2. Analyzed data in R using some descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized insights with R (ggplot, igraph, packages) using champion icons and some manual placement in illustrator/photoshop.

Sample visualizations the insights I found from these analyses:

If you main X ... you are mostlikely to main Y and least likely to main Z. Example visualization with 8 different champions.
![sample visualization](graphics/mains.png)

Network graph generated based on mastery data from 14343 random summoners. Connections indicate a strong relationship between how often those champions are mained together by players. You can see natural communities starting to form reflecting champions with different playstyles and lanes. You can also see some neat connections between these communities, such as the "pull" champions Thresh/Blitz/Pyke. With Pyke having more direct connections with the assassin-y cluster.
![sample visualization](graphics/network.png)

Curated data from Riot API can be found in the folders: mastery_data and match_data

Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files


