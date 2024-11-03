# Assignment
**Couse:** Mining Big Datasets

The goal of this assignment is to implement a simple workflow that assesses the similarity between bank customers and suggests a list of the 10 most similar customers for any given input customer. Additionally, the assignment involves predicting the rating of the customer to the bank based on the similarity results. The steps to fulfill this assignment are as follows:

## 1. Import and Pre-process the Dataset

Download the `bank.csv` dataset from Moodle. This dataset contains 43,191 bank customer profiles with 10 attributes each. The attributes are as follows:

- Age: The age of the customer.
- Job: Type of job (admin, unknown, unemployed, management, housemaid, entrepreneur, student, blue-collar, self-employed, retired, technician, services).
- Marital Status: Married, Single, Divorced.
- Education: Primary, Secondary, Tertiary.
- Default: If the customer has credit in default (yes/no).
- Balance: Average yearly balance in euros.
- Housing: If the customer has a housing loan (yes/no).
- Loan: If the customer has a personal loan (yes/no).
- Customer Rating: The rating of the bank from the customer (Poor, Fair, Good, Very Good, Excellent).
- Products: An array containing the bank products (1-20) each customer has.

For any missing numerical values, replace them with the average value of the attribute in the dataset (rounded to the nearest integer).

## 2. Compute Data (Dis-)Similarity

To assess the similarity between customers, you will create a dissimilarity matrix for all the given attributes. For each attribute, determine its type (categorical, ordinal, numerical, or set) and compute the dissimilarity of its values accordingly. For set similarity, use the Jaccard similarity between sets. Then, calculate the average of the computed dissimilarities to derive the dissimilarity over all attributes. Depending on the computational resources available, you can either pre-compute the dissimilarity matrices or perform the computations on-the-fly for a pair of customers.

## 3. Nearest Neighbor (NN) Search

Using the implementation from the previous step, calculate the 10-NN (most similar) customers for the customers with the following IDs (customer ID = line number - 1):

- 1200
- 3650
- 10400
- 14930
- 22330
- 25671
- 29311
- 34650
- 39200
- 42000

Your script should take the customer ID as input and return the list of the 10 nearest neighbors (most similar), along with the corresponding similarity score. An example of the script output for customer ID 1 is as follows:
| Customer ID          | Similarity Score |
|----------------------|------------------|
| 16641                | 7894             |
| 12329                |                  |
| 1247                 |                  |
| 33282                |                  |
| 25849                |                  |
| 24715                |                  |
| 6001                 |                  |
| 31996                |                  |
| 5914                 |                  |



## 4. Customer Rating Prediction

Implement a classification algorithm to predict the rating (poor, fair, good, very good, excellent) for a given customer. Follow these steps:

1) Calculate the similarities between the given customer and all other customers, excluding the customer rating attribute. Compute the 10-NN (most similar) customers for the given customer.
2) Based on the 10 most similar customers, predict the customer rating rank using:
   - The average rating rank of the 10 most similar customers (rounded to the nearest integer).
   - The weighted average rating rank of the 10 most similar customers (rounded to the nearest integer).
   The weighted average rating rank is calculated as follows:

![Weighted Average Rating Rank Formula](https://latex.codecogs.com/svg.image?%5Ctext%7BMean%20Prediction%20Error%7D%20%3D%20%5Cfrac%7B%5Csum_%7Bi%3D1%7D%5E%7B10%7D%20%5Ctext%7BRating%7D%28i%29%20%5Ctimes%20%5Ctext%7BSimilarity%7D%28i%29%7D%7B%5Csum_%7Bi%3D1%7D%5E%7B10%7D%20%5Ctext%7BSimilarity%7D%28i%29%7D)

3) Evaluate your classification algorithm by predicting the rating for the first 50 records of the dataset. Calculate the Mean Prediction Error for both prediction methods.

![Weighted Average Rating Rank Formula](https://latex.codecogs.com/svg.image?%5Ctext%7BMean%20Prediction%20Error%7D%20%3D%20%5Cfrac%7B1%7D%7Bn%7D%20%5Csum_%7Bi%3D1%7D%5En%20%7C%5Ctext%7Brank%7D%28%5Ctext%7BPredicted%20rating%7D%28i%29%29%20-%20%5Ctext%7Brank%7D%28%5Ctext%7BTrue%20rating%7D%28i%29%29%7C)
