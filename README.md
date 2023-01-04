# League of Legends Patterns across players in champion mains

League offers a lot of choice in terms of playstyle and decisions. People seem to naturally "fall into" liking certain roles and champions. I was curious if we can see some of these preferences in playstyle in a data-driven way. Do players prefer playing certain kinds of champions? Are there patterns in what kinds of champions or roles players main? For example, I have always played squishy, pokey, mage champions, and dislike playing all-in assassins. This could also be the start of a champion recommender, or be used to generate additional insights into certain player preferences.

<strong> What I did </strong>
1. Pulled match-level and amstery data from Riot's APIS for thousands of summoners and their most recent matches (scripts to fetch API data found in the API_fetch folder)
2. Analyzed data in R using some descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized insights with R (ggplot, igraph, packages) using champion icons and some manual placement in illustrator/photoshop.

Sample visualizations the insights I found from these analyses:

If you main X champion... you are likely to main Y and least likely to main Z. Example visualization with 8 different champions. Teemo I find particularly fun.
![sample visualization](graphics/mains.png)

Network graph generated based on mastery data from 14343 random summoners (from Iron to Diamond). Connections indicate a strong relationship between how often those champions are mained. Clustering using FR means that the distance between bubbles also reflects. You can see natural communities starting to form reflecting support champions. You can also see some neat connections, such as the "pull" champions from Pyke to Thresh to Blitz. With Pyke having more direct connections with the assassin-y cluster.
![sample visualization](graphics/network.png)

Curated data from Riot API can be found in the folders: mastery_data and match_data

Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files


