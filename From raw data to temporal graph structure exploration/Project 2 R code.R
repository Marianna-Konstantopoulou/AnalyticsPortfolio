######################################################################
### Project 2:From raw data to temporal graph structure exploration ##
################ Marianna Konstantopoulou P2822122 ###################
######################################################################

############################
#2 Average degree over time
############################

#Loading packages
library(igraph)
library(ggplot2)

#Reading the CSV files
authors_2016 <- read.csv("authors_2016.csv")
colnames(authors_2016) <- c('from', 'to', 'weight')
authors_2017 <- read.csv("authors_2017.csv")
colnames(authors_2017) <- c('from', 'to', 'weight')
authors_2018 <- read.csv("authors_2018.csv")
colnames(authors_2018) <- c('from', 'to', 'weight')
authors_2019 <- read.csv("authors_2019.csv")
colnames(authors_2019) <- c('from', 'to', 'weight')
authors_2020 <- read.csv("authors_2020.csv")
colnames(authors_2020) <- c('from', 'to', 'weight')

#Creating the graphs
g1 <- graph_from_data_frame(authors_2016, directed=FALSE)
is.weighted(g1)
print(g1, e=TRUE, v=TRUE)

g2 <- graph_from_data_frame(authors_2017, directed=FALSE)
is.weighted(g2)
print(g2, e=TRUE, v=TRUE)

g3 <- graph_from_data_frame(authors_2018, directed=FALSE)
is.weighted(g3)
print(g3, e=TRUE, v=TRUE)

g4 <- graph_from_data_frame(authors_2019, directed=FALSE)
is.weighted(g4)
print(g4, e=TRUE, v=TRUE)

g5 <- graph_from_data_frame(authors_2020, directed=FALSE)
is.weighted(g5)
print(g5, e=TRUE, v=TRUE)

# number of vertices
vcount(g1)
vcount(g2)
vcount(g3)
vcount(g4)
vcount(g5)
df1 <- data.frame(Vertices= c(vcount(g1), vcount(g2), vcount(g3), vcount(g4), vcount(g5)),Years= c("2016", "2017", "2018", "2019", "2020"))
df1
plot1 <- ggplot(df1, aes(Years, Vertices, group = 1)) +
  geom_point(colour="#56B4E9") +
  geom_line(colour="#56B4E9") +
  labs(x = "Years", y = "Number of Vertices", 
       title = "Number of Vertices per Year")
plot1

# number of edges
ecount(g1)
ecount(g2)
ecount(g3)
ecount(g4)
ecount(g5)
df2 <- data.frame(Edges= c(ecount(g1), ecount(g2), ecount(g3), ecount(g4), ecount(g5)),Years= c("2016", "2017", "2018", "2019", "2020"))
df2
plot2 <- ggplot(df2, aes(Years, Edges, group = 1)) +
  geom_point(colour="#F8766D") +
  geom_line(colour="#F8766D") +
  labs(x = "Years", y = "Number of Edges", 
       title = "Number of Edges per Year")
plot2

# diameter
diameter(g1)
diameter(g2)
diameter(g3)
diameter(g4)
diameter(g5)
df3 <- data.frame(Diameter= c(diameter(g1), diameter(g2), diameter(g3), diameter(g4), diameter(g5)),Years= c("2016", "2017", "2018", "2019", "2020"))
df3
plot3 <- ggplot(df3, aes(Years, Diameter, group = 1)) +
  geom_point(colour="#00BF7D") +
  geom_line(colour="#00BF7D") +
  labs(x = "Years", y = "Diameter", 
       title = "Diameter per Year")
plot3

# average degree
# Total Edges/Total Nodes=Average Degree
avg_degree_g1 = ecount(g1)/vcount(g1)
avg_degree_g2 = ecount(g2)/vcount(g2)
avg_degree_g3 = ecount(g3)/vcount(g3)
avg_degree_g4 = ecount(g4)/vcount(g4)
avg_degree_g5 = ecount(g5)/vcount(g5)
df4 <- data.frame(Avg_degree= c(avg_degree_g1, avg_degree_g2, avg_degree_g3, avg_degree_g4, avg_degree_g5),Years= c("2016", "2017", "2018", "2019", "2020"))
df4
plot4 <- ggplot(df4, aes(Years, Avg_degree, group = 1)) +
  geom_point(colour="#619CFF") +
  geom_line(colour="#619CFF") +
  labs(x = "Years", y = "Number of Average Degree", 
       title = "Number of Average Degree per Year")
plot4

############################
#3 Important nodes
############################

# Top 10 authors (degree)
top_10_authors_2016 <- head(sort(degree(g1), decreasing=TRUE), 10)
top_10_authors_2016 <- as.data.frame(top_10_authors_2016)
top_10_authors_2016 <- setNames(top_10_authors_2016 , c('Degree'))
write.table(top_10_authors_2016, file = "top_10_authors_2016.txt", sep = ",", quote = FALSE, row.names = T)

top_10_authors_2017 <- head(sort(degree(g2), decreasing=TRUE), 10)
top_10_authors_2017 <- as.data.frame(top_10_authors_2017)
top_10_authors_2017 <- setNames(top_10_authors_2017 , c('Degree'))
write.table(top_10_authors_2017, file = "top_10_authors_2017.txt", sep = ",", quote = FALSE, row.names = T)

top_10_authors_2018 <- head(sort(degree(g3), decreasing=TRUE), 10)
top_10_authors_2018 <- as.data.frame(top_10_authors_2018)
top_10_authors_2018 <- setNames(top_10_authors_2018 , c('Degree'))
write.table(top_10_authors_2018, file = "top_10_authors_2018.txt", sep = ",", quote = FALSE, row.names = T)

top_10_authors_2019 <- head(sort(degree(g4), decreasing=TRUE), 10)
top_10_authors_2019 <- as.data.frame(top_10_authors_2019)
top_10_authors_2019 <- setNames(top_10_authors_2019 , c('Degree'))
write.table(top_10_authors_2019, file = "top_10_authors_2019.txt", sep = ",", quote = FALSE, row.names = T)

top_10_authors_2020 <- head(sort(degree(g5), decreasing=TRUE), 10)
top_10_authors_2020 <- as.data.frame(top_10_authors_2020)
top_10_authors_2020 <- setNames(top_10_authors_2020 , c('Degree'))
write.table(top_10_authors_2020, file = "top_10_authors_2020.txt", sep = ",", quote = FALSE, row.names = T)


# Top 10 authors (PageRank)
top_10_authors_pr_2016 <- head(sort(round(page.rank(g1)$vector,4), decreasing=TRUE), 10)
top_10_authors_pr_2016 <- as.data.frame(top_10_authors_pr_2016)
top_10_authors_pr_2016 <- setNames(top_10_authors_pr_2016 , c('PageRank'))
write.table(top_10_authors_pr_2016, file = "top_10_authors_pr_2016.txt", sep = ",", quote = FALSE, row.names = T)


top_10_authors_pr_2017 <- head(sort(round(page.rank(g2)$vector,4), decreasing=TRUE), 10)
top_10_authors_pr_2017 <- as.data.frame(top_10_authors_pr_2017)
top_10_authors_pr_2017 <- setNames(top_10_authors_pr_2017 , c('PageRank'))
write.table(top_10_authors_pr_2017, file = "top_10_authors_pr_2017.txt", sep = ",", quote = FALSE, row.names = T)


top_10_authors_pr_2018 <- head(sort(round(page.rank(g3)$vector,4), decreasing=TRUE), 10)
top_10_authors_pr_2018 <- as.data.frame(top_10_authors_pr_2018)
top_10_authors_pr_2018 <- setNames(top_10_authors_pr_2018 , c('PageRank'))
write.table(top_10_authors_pr_2018, file = "top_10_authors_pr_2018.txt", sep = ",", quote = FALSE, row.names = T)


top_10_authors_pr_2019 <- head(sort(round(page.rank(g4)$vector,4), decreasing=TRUE), 10)
top_10_authors_pr_2019 <- as.data.frame(top_10_authors_pr_2019)
top_10_authors_pr_2019 <- setNames(top_10_authors_pr_2019 , c('PageRank'))
write.table(top_10_authors_pr_2019, file = "top_10_authors_pr_2019.txt", sep = ",", quote = FALSE, row.names = T)


top_10_authors_pr_2020 <- head(sort(round(page.rank(g5)$vector,4), decreasing=TRUE), 10)
top_10_authors_pr_2020 <- as.data.frame(top_10_authors_pr_2020)
top_10_authors_pr_2020 <- setNames(top_10_authors_pr_2020 , c('PageRank'))
write.table(top_10_authors_pr_2020, file = "top_10_authors_pr_2020.txt", sep = ",", quote = FALSE, row.names = T)

############################
#4 Communities
############################

#Fast-greedy clustering method
communities_fast_greedyg1 <- cluster_fast_greedy(g1)
communities_fast_greedyg2 <- cluster_fast_greedy(g2)
communities_fast_greedyg3 <- cluster_fast_greedy(g3)
communities_fast_greedyg4 <- cluster_fast_greedy(g4)
communities_fast_greedyg5 <- cluster_fast_greedy(g5)

#Infomap clustering method
communities_infomapg1 <- cluster_infomap(g1)
communities_infomapg2 <- cluster_infomap(g2)
communities_infomapg3 <- cluster_infomap(g3)
communities_infomapg4 <- cluster_infomap(g4)
communities_infomapg5 <- cluster_infomap(g5)

#The Louvain clustering method
communities_louvaing1 <- cluster_louvain(g1)
communities_louvaing2 <- cluster_louvain(g2)
communities_louvaing3 <- cluster_louvain(g3)
communities_louvaing4 <- cluster_louvain(g4)
communities_louvaing5 <- cluster_louvain(g5)

compare(communities_fast_greedyg1, communities_infomapg1)
compare(communities_fast_greedyg1, communities_louvaing1)
compare(communities_infomapg1, communities_louvaing1)

#Finding nodes(authors) that appears in all 5 graphs
g <- graph.intersection(g1, g2, g3, g4, g5, keep.all.vertices = FALSE)
g

#The random author I selected is Robert Keeling, so we will find the communities he is a member of every year
membership(communities_louvaing1)[ 'Robert Keeling']
membership(communities_louvaing2)[ 'Robert Keeling']
membership(communities_louvaing3)[ 'Robert Keeling']
membership(communities_louvaing4)[ 'Robert Keeling']
membership(communities_louvaing5)[ 'Robert Keeling']

#Checking the communities so we can spot any similarities
com1 <- communities_louvaing1[507]
write.table(com1, file = "com1.txt", sep = ",", quote = FALSE, row.names = T)
com2 <- communities_louvaing2[591]
write.table(com2, file = "com2.txt", sep = ",", quote = FALSE, row.names = T)
com3 <- communities_louvaing3[477]
write.table(com3, file = "com3.txt", sep = ",", quote = FALSE, row.names = T)
com4 <- communities_louvaing4[186]
write.table(com4, file = "com4.txt", sep = ",", quote = FALSE, row.names = T)
com5 <- communities_louvaing5[491]
write.table(com5, file = "com5.txt", sep = ",", quote = FALSE, row.names = T)

### 2016
V(g1)$color <- factor(membership(communities_louvaing1))
is_crossingg1 <- crossing(g1,communities = communities_louvaing1)
E(g1)$lty <- ifelse(is_crossingg1, "solid", "dotted")
community_size <- sizes(communities_louvaing1)
in_mid_community <-
  unlist(communities_louvaing1[community_size > 50 &
                               community_size < 90])
retweet_subgraph <-
  induced.subgraph(g1, in_mid_community)
plot(retweet_subgraph, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph),
     margin = 0, vertex.size = 3)

### 2017
V(g2)$color <- factor(membership(communities_louvaing2))
is_crossingg2 <- crossing(g2,communities = communities_louvaing2)
E(g2)$lty <- ifelse(is_crossingg2, "solid", "dotted")
community_size <- sizes(communities_louvaing2)
in_mid_community <-
  unlist(communities_louvaing2[community_size > 50 &
                                 community_size < 90])
retweet_subgraph <-
  induced.subgraph(g2, in_mid_community)
plot(retweet_subgraph, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph),
     margin = 0, vertex.size = 3)

### 2018
V(g3)$color <- factor(membership(communities_louvaing3))
is_crossingg3 <- crossing(g3,communities = communities_louvaing3)
E(g3)$lty <- ifelse(is_crossingg3, "solid", "dotted")
community_size <- sizes(communities_louvaing3)
in_mid_community <-
  unlist(communities_louvaing3[community_size > 50 &
                                 community_size < 90])
retweet_subgraph <-
  induced.subgraph(g3, in_mid_community)
plot(retweet_subgraph, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph),
     margin = 0, vertex.size = 3)

### 2019
V(g4)$color <- factor(membership(communities_louvaing4))
is_crossingg4 <- crossing(g4,communities = communities_louvaing4)
E(g4)$lty <- ifelse(is_crossingg4, "solid", "dotted")
community_size <- sizes(communities_louvaing4)
in_mid_community <-
  unlist(communities_louvaing4[community_size > 50 &
                                 community_size < 90])
retweet_subgraph <-
  induced.subgraph(g4, in_mid_community)
plot(retweet_subgraph, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph),
     margin = 0, vertex.size = 3)

### 2020
V(g5)$color <- factor(membership(communities_louvaing5))
is_crossingg5 <- crossing(g5,communities = communities_louvaing5)
E(g5)$lty <- ifelse(is_crossingg5, "solid", "dotted")
community_size <- sizes(communities_louvaing5)
in_mid_community <-
  unlist(communities_louvaing5[community_size > 50 &
                                 community_size < 90])
retweet_subgraph <-
  induced.subgraph(g5, in_mid_community)
plot(retweet_subgraph, vertex.label = NA,
     edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     coords = layout_with_fr(retweet_subgraph),
     margin = 0, vertex.size = 3)
