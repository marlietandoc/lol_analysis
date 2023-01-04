# League of Legends: Player patterns in champion and role mains

Do players prefer playing certain kinds of champions? Are there patterns in what kinds of champions or roles players main? For example, I have always played squishy, pokey, mage champions, and dislike playing all-in assassins. 

<strong> What I did </strong>
1. Pulled match-level and amstery data from Riot's APIS for thousands of summoners and their most recent matches (scripts to fetch API data found in the API_fetch folder)
2. Analyzed data in R using some descriptive statistics, multivariate correlation metrics, clustering, and network analysis
3. Visualized

Sample visualizations the insights I found from these analyses:

![sample visualization](graphics/network.png)

![sample visualization](graphics/if you play.png)


Curated data from Riot API can be found in the folders: mastery_data and match_data

Analysis scripts can be found in the .Rmd files and output (including additional visualizations) in the respective .html files


