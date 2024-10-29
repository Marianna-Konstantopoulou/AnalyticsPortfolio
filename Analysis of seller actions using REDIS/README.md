# Data Analysis with REDIS

This project involves performing an analysis on data related to seller actions using REDIS. The analysis aims to derive insights from user modifications and email interactions.

## Instructions

1. **Install REDIS** on your workstation:
   - If you are using Windows, download Version 4 of REDIS from the following link: [REDIS Releases](https://github.com/tporadowski/redis/releases).
   - Ensure you upgrade to Version 4 if you have an older version, as some required commands are not supported by earlier versions. The installation process is straightforward.

2. **Download the Dataset**:
   - Download the "RECORDED_ACTIONS.zip" dataset from [Google Drive](https://drive.google.com/open?id=1wyL8nQKDEu6rdr9BH6CgBwGnPnvRT8cJ).

3. **Complete the Tasks**:
   - Refer to the "TASKS" section for the specific tasks you need to accomplish.
   - Provide answers for the following additional questions:

## Tasks

1.1 How many users modified their listing in January?  
   *Tip: Create a BITMAP called "ModificationsJanuary" and use "SETBIT -> 1" for each user that modified their listing. Use BITCOUNT to calculate the answer.*

1.2 How many users did NOT modify their listing in January?  
   *Tip: Use "BITOP NOT" to perform inversion on the "ModificationsJanuary" BITMAP and use BITCOUNT to calculate the answer. Combine the results with the answer from 1.1. Do these numbers match the total number of your users? If not, provide an explanation for the discrepancy.*

1.3 How many users received at least one email per month (January, February, and March)?  
   *Tip: Create three BITMAPS named "EmailsJanuary", "EmailsFebruary", and "EmailsMarch". Fill them with "SETBIT" and use "BITOP AND" followed by "BITCOUNT" to calculate the answer.*

1.4 How many users received an email in January and March but NOT in February?  
   *Tip: Perform "BITOP AND" on "EmailsJanuary" and "EmailsMarch". Invert "EmailsFebruary" and use "BITOP AND" as well.*

1.5 How many users received an email in January that they did not open but still updated their listing?  
   *Tip: Create a new BITMAP named "EmailsOpenedJanuary".*

1.6 How many users received an email in January that they did not open but still updated their listing in January OR received an email in February that they did not open but still updated their listing in February OR received an email in March that they did not open but still updated their listing in March?  
   *Tip: Create two new BITMAPs named "EmailsOpenedFebruary" and "EmailsOpenedMarch". Perform the same steps as in 1.5 and calculate the answer using "BITOP OR".*

1.7 Does it make any sense to keep sending emails with recommendations to sellers? Does this strategy really work? How would you describe this in terms a business person would understand?  
   *Tip: Use the findings from previous questions or calculate anything else you want to justify your answer.*
