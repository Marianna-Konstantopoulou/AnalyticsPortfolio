# Pipelines Assignment

## Task 1 

Use Airflow to define a small workflow that leverages `BashOperator` containing the following tasks:

- **Task 1.1:** Creates a string variable called `firstName` assigning it the string that corresponds to your first name in lowercase.
- **Task 1.2:** Creates a string variable called `lastName` assigning it the string that corresponds to your last name in lowercase.
- **Task 2.1:** Gets the `firstName` as input and outputs the same string with the first letter capitalized.
- **Task 2.2:** Gets the `lastName` as input and outputs the same string with the first letter capitalized.
- **Task 3:** Displays on screen a string that concatenates `firstName` and `lastName`, adding a space character in between.

## Task 2 

Use the `kafka-python` package to create a `KafkaProducer` to publish messages in a topic called `clima`. Each message should be in JSON format, containing:

- A temperature value (integer)
- A humidity reading (integer)
- A timestamp representing the time point during which the measurements took place.

Additionally, implement a consumer that subscribes to the `clima` topic and prints the entire history of messages on screen. Ensure that your code connects to a locally hosted Kafka deployment (port 9092).

