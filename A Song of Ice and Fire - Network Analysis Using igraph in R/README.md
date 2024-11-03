## Dataset Overview

This dataset represents character interaction networks from George R. R. Martin's *A Song of Ice and Fire* series. The edgelists capture connections between characters when their names (or nicknames) appear within 15 words of each other in the text. The weight of each edge corresponds to the number of interactions.

## Analysis Themes

- **R Programming**
- **iGraph Package**
- **Network Analysis**
- **PageRank Algorithm**

## Project Summary

In this analysis, we examined the network of character interactions within *A Song of Ice and Fire*. Using a CSV file with network edges, we constructed an undirected, weighted graph in iGraph, using the columns *Source*, *Target*, and *Weight*. 

### Key Steps

1. **Basic Network Properties**  
   We calculated essential network properties, including:
   - Number of vertices
   - Number of edges
   - Graph diameter
   - Number of triangles

2. **Top Characters by Degree**  
   We identified the Top 10 characters based on both degree and weighted degree.

3. **Network Visualization**  
   Using `plot()` and `rglplot()`, we visualized the entire network.

4. **Subgraph Analysis**  
   - We created a subgraph, retaining only vertices with 10 or more connections.
   - Compared the edge density of this subgraph to the full graph.

5. **Centrality Measures**  
   - Calculated the Top 15 characters based on **betweenness centrality** and **closeness centrality**.
   - Compared Jon Snow’s rank within these metrics.

6. **PageRank**  
   We implemented the PageRank algorithm to rank the characters and visualized the resulting network.

This project provided insights into character prominence and interaction patterns, contributing to a deeper understanding of the narrative structure in *A Song of Ice and Fire*.
