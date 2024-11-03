# Airline Network Graph Database with Neo4j

## Assignment Overview

This assignment involves designing and implementing a Neo4j graph database to represent part of the OpenFlights Airports network. The dataset contains information on airports, airlines, cities, countries, and flights. The main goals are to model this data as a property graph, import it into Neo4j, and perform specific queries to extract insights from the network.

## Dataset

The provided dataset includes:
- **Airports**: 7,698 entries
- **Airlines**: 6,161 entries
- **Cities**: 6,956 entries
- **Countries**: 237 entries
- **Flights**: 65,935 entries

The dataset is provided in CSV format and contains three files with detailed attribute descriptions. 

## Property Graph Model

You are required to design a property graph to represent the airline network, following these guidelines:
- Define entities (nodes and edges) and assign relevant labels, types, and properties.
- Only essential attributes should be included for each node and edge type.
- Avoid duplicating properties on both nodes and edges.
- Do not connect nodes unless necessary.

## Steps

### 1. Importing the Dataset into Neo4j

Based on your graph model, create a Neo4j database and import the data. You can load the dataset directly from the provided CSV files, using:
- The Neo4j browser
- The Neo4j import tool
- A supported programming language (e.g., Python)

To improve performance, consider creating indexes on key properties.

### 2. Querying the Database

After importing the data, use Cypher to perform the following queries:

1. **Top 5 airports by number of flights**: Return airport name and flight count.
2. **Top 5 countries by airport count**: Return country name and airport count.
3. **Top 5 airlines with international flights from/to 'Greece'**: Return airline name and flight count.
4. **Top 5 airlines with domestic flights in 'Germany'**: Return airline name and flight count.
5. **Top 10 countries with flights to Greece**: Return country name and flight count.
6. **Air traffic percentage for each city in Greece**: Return city name and traffic percentage (in descending order).
7. **International flights to Greece by plane types '738' and '320'**: Return plane type and flight count.
8. **Top 5 longest flights**: Return departure airport, destination airport, and distance (in km).
9. **Top 5 cities not connected to 'Berlin'**: Return city name and score (total flights to other destinations).
10. **All shortest paths from 'Athens' to 'Sydney'**: Use only flight and airport relationships.

## Assignment Handout

### Deliverables

Submit a compressed file with the following items:

1. **Report.pdf**:
   - A detailed description of your graph model, including a diagram and a verbal explanation.
   - Commands used for importing the data into Neo4j.
   - Cypher code for each query with corresponding results.

2. **Program/Script**: Any scripts or programs used to support the assignment.

3. **queries.cy**: A text file containing all the Cypher queries used.

---

Ensure your code and documentation are well-structured for easy understanding and grading. This will be valuable for future reference and will enhance your skills with graph database technology and Cypher.
