#!/usr/bin/env python
# coding: utf-8

# In[6]:


#installation of mysql-connector
import mysql.connector
conn = mysql.connector.connect(
    host='localhost', user='root', passwd='Wel8come', database='properties')
myCursor = conn.cursor()


# In[7]:


def views():
    list_views = []
    #We created an empty list and we add the views created by mySQL in it
    view1 = 'create view location_estimations2020_3 as                select location_code, cnt                            from (                                select x.location_code,                                    (select count(estimation.ecode)                                    from estimation                                    left join property                                        on estimation.property_id=property.property_id                                    where x.location_code = property.location_code and year(estimation_date) = 2020) as cnt                                from (                                select distinct location_code from property) as x) as y'

    view2 = 'create view total_estimations2020_3 as                select count(estimation.ecode) as total_estimations                from property                join estimation on estimation.property_id=property.property_id and year(estimation_date)=2020                join location on property.location_code=location.location_code;'
                
    view3 = 'create view location_population2020_3 as                select location.location_code, location.population                from location;'

    view4 = 'create view total_population2020_3 as                select sum(distinct(location.population)) as total_population                from property                join estimation on estimation.property_id=property.property_id and year(estimation_date)=2020                join location on property.location_code=location.location_code;'
    for i in (view1, view2, view3, view4):
        list_views.append(i)

    return(list_views)


# In[8]:


def final():
    final = 'select location_population2020_3.location_code as locations,    round((location_estimations2020_3.cnt/total_estimations2020_3.total_estimations * 100 ),2) as perc_est,     round((location_population2020_3.population/total_population2020_3.total_population * 100 ),2) as perc_pop                from total_estimations2020_3,  total_population2020_3, location_estimations2020_3                join location_population2020_3 on location_population2020_3.location_code=location_estimations2020_3.location_code;'
    return final


# In[9]:


def final_result():
    # The cursor executes the views, the final query and prints the table with results
    for i in views():
        myCursor.execute(i)
    myCursor.execute(final())
    print("\nExercise 5 result\n")
    for location_code, perc_est, perc_pop in myCursor:
        print(location_code, perc_est, perc_pop)


# In[10]:


if __name__ == "__main__":
    final_result()


# In[ ]:




