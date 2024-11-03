######################################################################
### Project 1:Network Analysis and Visualization with R and igraph ###
################ Marianna Konstantopoulou P2822122 ###################
######################################################################

### 1: ‘A Song of Ice and Fire’ network ###

#Loading igraph
library(igraph)

#Reading the CSV file
relations <- read.csv("asoiaf-all-edges.csv", header = TRUE, sep=",", stringsAsFactors = FALSE)

#Removing the columns that we don't need for our graph
relations$Type <- NULL

relations$id <- NULL

#Creating the graph
g <- graph_from_data_frame(relations, directed=FALSE)
print(g, e=TRUE, v=TRUE)

### 2 : Network Properties ###

# number of vertices
vcount(g)
# number of edges
ecount(g)
# diameter
diameter(g)
# number of triangles
sum(count_triangles(g, vids = V(g))) /3
# Top 10 characters (degree)
top_10_characters <- head(sort(degree(g), decreasing=TRUE), 10)
top_10_characters
# Top 10 characters (weighted degree)
top_10_weighted_degrees <- head(sort(strength(g), decreasing=TRUE), 10)
top_10_weighted_degrees


### 3 : Subgraph ###

#Plotting all the netwrok
layout <- layout_with_fr(g)
plot(g, layout=layout, vertex.color="#99CCFF", vertex.label = NA, edge.arrow.width=3, vertex.size=3)

#Subgraph
important <- which(degree(g) > 9)
subg <- induced_subgraph(g, important)
layout_sub <- layout_with_fr(subg)
plot(subg,layout=layout_sub,vertex.color="#99CCFF", vertex.label = NA, edge.arrow.width=3, vertex.size=5)

#Edge density
edge_density(g, loops = FALSE)
edge_density(induced_subgraph(g, important), loops = FALSE)
  

### 4 : Centrality ###

#Closeness centrality
top_15_closeness <- head(sort(closeness(g), decreasing=TRUE), 15)
top_15_closeness

#Betweenness centrality 
top_15_betweeness <- head(sort(betweenness(g, directed = FALSE), decreasing=TRUE), 15)
top_15_betweeness

#Finding Jon Snow's closeness and betweenness
closeness(g, v="Jon-Snow")
betweenness(g, v="Jon-Snow", directed=FALSE)

#Where is Jon Snow ranked according to Closeness?
which(names(sort(closeness(g), decreasing=TRUE)) == "Jon-Snow")

#Where is Jon Snow ranked according to Betweeness?
which(names(sort(betweenness(g, directed = FALSE), decreasing=TRUE)) == "Jon-Snow")

### 5 : Ranking and Visualization ###

library(magrittr)
pr <- g %>%
  page.rank(directed = FALSE) %>%
  use_series("vector") %>%
  sort(decreasing = TRUE) %>%
  as.matrix %>%
  set_colnames("page.rank")
page_rank <- as.data.frame(pr)
head(page_rank,10)
vertexsize <- as.numeric(page_rank[,1]*500)
par(mfrow=c(1,1))
plot(g, layout=layout_with_fr(g), vertex.color="#99CCFF", margins=c(0,0.5), vertex.label = NA, edge.arrow.width=3,vertex.size=vertexsize)

