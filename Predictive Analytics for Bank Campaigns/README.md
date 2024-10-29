# Project I: Telemarketing Campaign Analysis (2021-2022)

This project analyzes data related to telemarketing phone calls aimed at selling long-term deposits. The dataset encompasses around 40,000 phone contacts collected from a retail bank between May 2008 and June 2010. The goal is to determine which variables contribute to a successful contact, indicating whether a client subscribes to the product.

## Data Overview

### Input Variables

#### Bank Client Data
1. **Age**: Numeric (client's age)
2. **Job**: Categorical (type of job: 'admin.', 'blue-collar', 'entrepreneur', 'housemaid', 'management', 'retired', 'self-employed', 'services', 'student', 'technician', 'unemployed', 'unknown')
3. **Marital Status**: Categorical ('divorced', 'married', 'single', 'unknown'; note: 'divorced' includes divorced or widowed)
4. **Education**: Categorical ('basic.4y', 'basic.6y', 'basic.9y', 'high.school', 'illiterate', 'professional.course', 'university.degree', 'unknown')
5. **Default**: Categorical (has credit in default? 'no', 'yes', 'unknown')
6. **Housing**: Categorical (has housing loan? 'no', 'yes', 'unknown')
7. **Loan**: Categorical (has personal loan? 'no', 'yes', 'unknown')

#### Last Contact Attributes
8. **Contact Type**: Categorical (contact communication type: 'cellular', 'telephone')
9. **Month**: Categorical (last contact month of the year: 'jan', 'feb', 'mar', ..., 'nov', 'dec')
10. **Day of Week**: Categorical (last contact day of the week: 'mon', 'tue', 'wed', 'thu', 'fri')
11. **Duration**: Numeric (last contact duration in seconds)

#### Other Attributes
12. **Campaign**: Numeric (number of contacts performed during this campaign for this client, including last contact)
13. **Pdays**: Numeric (number of days since last contact from a previous campaign; 999 means client was not previously contacted)
14. **Previous**: Numeric (number of contacts performed before this campaign for this client)
15. **Poutcome**: Categorical (outcome of the previous marketing campaign: 'failure', 'nonexistent', 'success')

#### Social and Economic Context Attributes
16. **Emp.var.rate**: Numeric (employment variation rate - quarterly indicator)
17. **Cons.price.idx**: Numeric (consumer price index - monthly indicator)
18. **Cons.conf.idx**: Numeric (consumer confidence index - monthly indicator)
19. **Euribor3m**: Numeric (Euribor 3-month rate - daily indicator)
20. **Nr.employed**: Numeric (number of employees - quarterly indicator)

### Output Variable
21. **Subscribed**: Binary (has the client subscribed to a term deposit? 'yes', 'no')

## Analysis Goals
- Identify which variables are important for predicting successful contacts.
- Assess if any transformations are necessary for the variables.
- Evaluate the model's performance.
- Examine any assumptions that need careful checking.

