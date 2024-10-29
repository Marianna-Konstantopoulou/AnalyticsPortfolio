#!/usr/bin/env python
# coding: utf-8

# In[83]:


import os
import numpy as np 
import pandas as pd 
import datetime 


# In[84]:


new_york = pd.read_csv('/Users/mariannakonstantopoulou/Desktop/MSc Business Analytics/Data Management and Business Intelligence/Data Warehouse & Visualization Assignment/NYC-BikeShare-2015-2017-combined 2.csv')


# In[85]:


new_york.describe()
new_york.info()


# In[86]:


new_york[['Start Time','Stop Time']] = new_york[['Start Time','Stop Time']].apply(pd.to_datetime, format='%Y-%m-%d %H:%M:%S.%f')


# In[87]:


new_york['Birth Year'] = pd.to_numeric(new_york['Birth Year'], downcast='integer')


# In[88]:


new_york.drop('Unnamed: 0', inplace=True, axis=1)


# In[89]:


new_york['Start_Date'] = pd.to_datetime(new_york['Start Time']).dt.date
new_york['Start_Time'] = pd.to_datetime(new_york['Start Time']).dt.time


# In[90]:


new_york['Stop_Date'] = pd.to_datetime(new_york['Stop Time']).dt.date
new_york['Stop_Time'] = pd.to_datetime(new_york['Stop Time']).dt.time


# In[91]:


new_york.drop('Start Time', inplace=True, axis=1)
new_york.drop('Stop Time', inplace=True, axis=1)


# In[92]:


new_york['Start_Date'] = pd.to_datetime(new_york['Start_Date'],format='%Y-%m-%d')
# Create new columns
new_york['Start_year'] = pd.DatetimeIndex(new_york['Start_Date']).year
new_york['Start_month'] = pd.DatetimeIndex(new_york['Start_Date']).month
new_york['Start_day'] = pd.DatetimeIndex(new_york['Start_Date']).day


# In[94]:


new_york.describe()
new_york.info()


# In[95]:


new_york.drop('Start_Date', inplace=True, axis=1)
new_york.drop('Stop_Date', inplace=True, axis=1)
new_york.drop('Trip_Duration_in_min', inplace=True, axis=1)


# In[96]:


new_york_reorder = new_york[['Start_year','Start_month','Start_day', 'Start_Time', 'Stop_year', 'Stop_month', 'Stop_day', 'Stop_Time', 'Start Station ID', 'Start Station Name', 'Start Station Latitude', 'Start Station Longitude', 'End Station ID', 'End Station Name', 'End Station Latitude', 'End Station Longitude', 'Bike ID', 'User Type', 'Birth Year', 'Gender','Trip Duration']] # rearrange columns
new_york_reorder.to_csv('bike_share_new_york', index=False)


# In[98]:


new_york_reorder.head()


# In[99]:


new_york_reorder.insert(0, 'ID', range(1, 1 + len(new_york)))


# In[100]:


new_york_reorder.head()


# In[101]:


new_york_reorder.to_csv('bike_share_new_york', index=False)


# In[ ]:




