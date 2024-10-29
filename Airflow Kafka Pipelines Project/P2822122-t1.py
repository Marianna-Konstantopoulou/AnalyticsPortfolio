################################
##### Pipelines Assignment #####
################################
## Big Data Systems - Airflow ##
################################
# ---
# 
#Marianna Konstantopoulou
#P2822122
#MSc Business Analytics Part Time

#We import libaries & modules required for the code.

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime
import datetime as dt

#We specify the default arguments (configurations) for the DAG

default_args={
    'owner' : 'me',
    'start_date' : dt.datetime(2022, 4, 10),
    'retries' : 1,
    'retry_delay' : dt.timedelta(minutes=5)
}

#The following instantiates the DAG based on the arguments provided and other metadata.

dag = DAG('P2822122-t1',
         description = 'Pipelines Assignment Task 1',
         default_args=default_args)

#Define the nodes of the DAG:

#Task 1.1: Creates a string variable called “firstName” assigning to it the string that
#corresponds to your first name with all letters in lowercase.
task1_1 = BashOperator(
    task_id='firstName',
    bash_command='firstName=marianna',
    dag=dag,)

#Task 1.2: Creates a string variable called “lastName” assigning to it the string that
#corresponds to you last name with all letters in lowercase.

task1_2 = BashOperator(
    task_id='lastName',
    bash_command='lastName=konstantopoulou',
    dag=dag,)

#Task 2.1: It gets the firstName as input and outputs the same string with the first letter
#capitalized.

task2_1 = BashOperator(
    task_id='firstNamecapitalized',
    bash_command='echo ${(C)firstName}>firstNamecapitalized.txt | cat firstNamecapitalized.txt',
    dag=dag,)

#Task 2.2: It gets the lastName as input and outputs the same string with the first letter
#capitalized.

task2_2 = BashOperator(
    task_id='lastNamecapitalized',
    bash_command='echo ${(C)lastName}>lastNamecapitalized.txt | cat lastNamecapitalized.txt',
    dag=dag,)

#Task 3: Displays on screen a string that concatenates the firstName and the lastName
#adding a space character in between.

task3 = BashOperator(
    task_id='concatenate',
    bash_command='paste firstNamecapitalized.txt lastNamecapitalized.txt | column -s $'\t' -t',
    dag=dag,)

#Specify the dependencies between the tasks

task1_1 >> task2_1 >> task3
task1_2 >> task2_2 >> task3

