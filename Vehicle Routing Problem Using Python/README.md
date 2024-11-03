# Disaster Relief Supply Distribution Problem

## Problem Scenario

In this problem, relief supplies must be distributed to multiple locations following a natural disaster. The objective is to optimize the distribution process based on the following scenario details:

1. **Post-Disaster Relief Supply Distribution**  
   - Supplies are to be delivered to **200 geographically dispersed locations**.

2. **Demand at Locations**  
   - Each location serves a different region and has a **predetermined demand**.

3. **Vehicle Fleet**  
   - The fleet consists of **26 identical vehicles**, each with a carrying capacity of **3 tons**.
   - Each vehicle is assigned to **one route**.

4. **Central Depot**  
   - All vehicles start from a **central depot** (coordinates: \(d = \{0\}\)), where all supplies are stored.
   - Vehicles follow their designated routes from this depot to the service locations.

5. **Simultaneous Route Start Time**  
   - All vehicles begin their routes **simultaneously at \(t = 0\)**.

6. **Single Visit per Location**  
   - Each location is visited **only once by a single vehicle**.

7. **Constant Travel Speed**  
   - Vehicles maintain a **constant speed of 40 km/h**.

8. **Unloading Time**  
   - A fixed **15-minute unloading time** is applied at each service location.

### Objective

The goal is to **minimize the completion time** for serving the last customer. Each service location has a specific time, \(t_i\), representing when it receives its supplies. The objective is to minimize the maximum of these \(t_i\) values across all locations.
