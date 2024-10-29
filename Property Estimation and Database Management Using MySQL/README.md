# Developing and Querying a Relational Database in MySQL

E-Properties assesses a collection of properties managed by its appraisers. Each appraiser is identified by a unique code and has a first name, last name, gender, age, and address. Properties are characterized by a unique code, address, floor, size (in square meters), year of construction, and are classified as either offices or residences. Offices include additional details such as the owner's tax identification number, whereas residences include the owner's identification number. An appraiser evaluates a property, and each evaluation is documented with a unique code, value, and the date (day, month, year) of the assessment. Each property belongs to a specific area, which is described by a code, name, population, and average income.

## Tasks

**1.** Utilize MySQL to establish a database and write and execute SQL queries.

**2.** Represent your application using the entity-relationship model and design the diagram using any program of your choice.

**3.** Relational Model and SQL Tables:
   - Convert your design into the relational model.
   - Create tables, define attributes, and set constraints in SQL Server using SQL (`CREATE TABLE`).
   - Populate the tables using `INSERT INTO` statements.

**4.** Write and execute SQL queries for the following requirements:
    - Retrieve the code and address of properties located in areas with an average income exceeding €40,000 that were evaluated between December 24th, 2020, and December 31st, 2020.
    - For each appraiser, display the number of evaluations they completed in 2020.
    - Identify the codes of properties evaluated more than twice during 2020.
    - Using nested queries, find the codes of evaluations conducted in areas with an average income greater than €25,000.
    - Display the number of evaluations in 2020 for properties located in areas with a population exceeding 50,000.
    - For each area code, show the area code along with the average evaluation value per square meter, sorted in ascending order of the average evaluation value.
    - For each appraiser in 2020, present their code, the number of residential evaluations they performed, and the number of office evaluations (3 columns).
    - For each area code, display the change in the average evaluation value per square meter between 2020 and 2019.
    - For each area code in 2020, show the count of evaluations in that area as a percentage of the total evaluations conducted in 2020 (one column), and the population of the area as a percentage of the total population of all areas.

**5.** Using any programming language of your choice, connect to the database and implement query (i) from the previous section without using the GROUP BY clause in the SQL statement, meaning you can only use SELECT...FROM...WHERE.
