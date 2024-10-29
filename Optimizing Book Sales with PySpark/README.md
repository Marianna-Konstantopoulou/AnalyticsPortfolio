# Background

The assignment focuses on using Apache Spark, with a focus on PySpark, to analyze a dataset of book metadata and derive insights to optimize sales for a small bookstore company.

## Task 1 

Your first task is to explore the dataset. You need to use SparkSQL with DataFrames in a Jupyter notebook that delivers the following:

- It uses the `json()` function to load the dataset.
- It counts and displays the number of books in the database.
- It counts and displays the number of e-books in the database (based on the "is_ebook" field).
- It uses the `summary()` command to display basic statistics about the "average_rating" field.
- It uses the `groupby()` and `count()` commands to display all distinct values in the "format" field and their number of appearances.

Your deliverable should be a ready-to-run Jupyter notebook named `id-t1.ipynb`, containing your details (name, id) and explanations for each step of the code.

## Task 2 

For this task, you continue to work with SparkSQL. This time, you need to provide a Jupyter notebook (again using PySpark and DataFrames) that delivers the following:

- It returns the "book_id" and "title" of the book with the largest "average_rating" that its title starts with the first letter of your last name.
- It returns the average "average_rating" of the books that their title starts with the second letter of your last name.
- It returns the "book_id" and "title" of the Paperback book with the most pages when only books with titles starting with the third letter of your last name are considered.

Your deliverable should be a ready-to-run Jupyter notebook named `id-t2.ipynb`, containing your details (name, id) and explanations for each step of the code.

## Task 3 

As a final task, your supervisor assigned you to investigate if it is possible to train a linear regression model (using the `LinearRegression()` function) that could predict the "average_rating" of a book. The input for the model should include the following features: "language_code," "num_pages," "ratings_count," and "publication year." You should use Python and DataFrames, this time with MLlib.

Your code should:

- Prepare the feature vectors.
- Prepare the training and testing datasets with a 70%-30% split.
- Train the model.
- Evaluate the accuracy of the model based on the Rsquared metric and display the corresponding metric on the screen.
