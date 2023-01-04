# League of Legends: Patterns across players in champion mains

League offers a lot of choice in terms of playstyle, which is one reason why the game is so fun. Players seem to naturally "fall into" liking certain roles and champions. I was curious if we can extract some of these preferences in a data-driven way (by looking at mastery and match data). Do players prefer playing certain kinds of champions? Are there patterns in what kinds of champs players tend to  main? For example, I have always played squishy, pokey, mage champions, and dislike playing all-in assassins or tanks. This could also be the start of a champion recommender, or be used to generate additional insights into certain player preferences.

<strong> What I did </strong>
1. Pulled match-level and amstery data from Riot's APIS for thousands of summoners and their most recent matches (scripts to fetch API data found in the API_fetch folder)
2. Analyzed data in R using some descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized insights with R (ggplot, igraph, packages) using champion icons and some manual placement in illustrator/photoshop.

## If you main champion X? Who else are you likely to main?
![sample visualization](graphics/mains.png) 

## Network generated based on mastery data from 14343 summoners. Connections indicate a strong relationship in how often those champions are mained together across players.
![sample visualization](graphics/network.png)
You can see natural communities starting to form reflecting champions with different playstyles and lanes. You can also see some neat connections between these communities, such as the "pull" champions Thresh/Blitz/Pyke. With Pyke having more direct connections with the assassin-y cluster.

## The number of different champions summoners play. Most summoners play around 5-10 unique champions.
![sample visualization](graphics/unique.png)

<strong> Where to find stuff </strong>
- Curated data from Riot API can be found in the folders: mastery_data and match_data
- Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files
- Scripts used to request data from Riot API can be found in API_request folder

