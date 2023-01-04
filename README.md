# League of Legends: Player patterns in champion and role mains

League offers a lot of choice in terms of playstyle and decisions. People seem to naturally "fall into" liking certain roles and champions. I was curious if we can see some of these preferences in playstyle in a data-driven way. Do players prefer playing certain kinds of champions? Are there patterns in what kinds of champions or roles players main? For example, I have always played squishy, pokey, mage champions, and dislike playing all-in assassins. This could also be the start of a champion recommender, or be used to generate additional insights into certain player preferences.

<strong> What I did </strong>
1. Pulled match-level and amstery data from Riot's APIS for thousands of summoners and their most recent matches (scripts to fetch API data found in the API_fetch folder)
2. Analyzed data in R using some descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized insights with R (ggplot, igraph, packages) using champion icons and some manual placement in illustrator/photoshop.

Sample visualizations the insights I found from these analyses:

If you main X champion... you are likely to main Y and least likely to main Z
![sample visualization](graphics/mains.png)

How often champions are mained together as a network with clustering
![sample visualization](graphics/network.png)

Curated data from Riot API can be found in the folders: mastery_data and match_data

Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files


