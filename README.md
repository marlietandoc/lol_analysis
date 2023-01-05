# League of Legends: Patterns across players in champion preferences

League offers a lot of choice in terms of playstyle, which is one reason why the game is so much fun. I have also always found it interesting how players seem to naturally "fall into" liking certain roles and champions. I was curious if I could extract some of these preferences in a data-driven way (by looking at what champions summoners play and master). Do players prefer certain kinds of champions? Are there patterns in what kinds of champs players tend to main? For example, if you play Lux what other champs are you likely to play (or unlikely to play). This could also be the start of a champion recommender, or be combined with other data to be used to generate additional insights into player preference and behavior.

<strong> What I did </strong>
1. Pulled match and mastery data from Riot API for thousands of summoners
2. Analyzed data in R using descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized insights with R (ggplot2, igraph, magick) using champion icons and a bit of manual placement in illustrator/photoshop.

## Visualization generated from mastery data of 14343 summoners
For each champion, I examined how correlated or uncorrelated champions were across summoners in their top 3 mastered champs.
![sample visualization](graphics/mains.png) 

## Network generated from mastery data of 14343 summoners
Connections indicate a strong relationship in how often those champions are mained together across players.
![sample visualization](graphics/network.png)
You can see communities that emerge which seem to reflecting players who prefer champions with different playstyles and lanes (assassins, adcs from more pokey to more all-in). You can also see some neat connections between these communities, such as the "pull" champions Thresh/Blitz/Pyke. With Pyke having more direct connections with the assassin-y cluster.

## The number of different champions summoners play in their most recent ranked games.
Most summoners play around 5-10 unique champions. 
![sample visualization](graphics/unique.png)

<strong> Where to find stuff </strong>
- Curated data from Riot API can be found in the folders: mastery_data and match_data
- Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files
- Scripts used to request data from Riot API can be found in API_request folder

