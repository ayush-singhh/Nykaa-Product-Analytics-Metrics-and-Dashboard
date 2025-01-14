# Nykaa-Product-Analytics-Metrics-and-Dashboard


## Project Background


<details> 
<summary>
Project Background 
	
</summary>
<br>
THE SITUATION

You've just been hired as a Product Analyst for Nykaa, India's leading beauty and cosmetics e-commerce platform. The platform serves millions of customers daily and offers thousands of products across multiple beauty and personal care categories.

THE ASSIGNMENT

Your assignment is to design an explanatory dashboard for Product Managers to help them understand user behavior and product performance. They review this dashboard weekly and need information on user engagement patterns, product discovery metrics, and potential revenue loss due to cart abandonment.

They specifically need insights on:

- User journey patterns and engagement metrics
- Product-level performance and discovery rates
- Revenue impact from cart abandonment and user drop-offs

</details> 

***

## The Dataset


<details> 
<summary>
Click here to know the Dataset Details
	
</summary>
<br>


This dataset was taken from the Kaggle.
It contains 20 Million rows of dataset of a mid-size cosmetics e-commerce store in Russia. 

So I recided to take Nykaa as Company to undertstand this dataset much better.


</details> 

*** 


## Project Goal



<details> 
<summary>
Project Goal
	
</summary>
<br>


Create a Nykaa Product Engagement Dashboard for the Nykaa web platoform. 

This Dashboard will specifically give insights on:

- User journey patterns and engagement metrics
- Product-level performance and discovery rates
- Revenue impact from cart abandonment and user drop-offs


</details> 

*** 



## Data Cleaning Process


<details> 
<summary>
8-step Data Cleaning Process
	
</summary>
<br>


1. **Remove Irrelevant Data**: Excluded rows that didn’t align with the business objective, like transactions without key details.
2. **Handle Missing Data**: Replaced missing Description values with 'Unknown' and removed rows with missing or zero CustomerID, Quantity, or UnitPrice.
3. **Remove Duplicates**: Used ROW_NUMBER() to eliminate duplicate transaction entries.
4. **Fix Structural Errors**: Corrected inconsistencies like typos, wrong capitalization, and naming issues.
5. **Convert Data Types**: Ensured correct types (e.g., Quantity as integer, InvoiceDate as DATETIME).
6. **Standardize/Normalize Data**: Made sure units and scales (e.g., price format, quantity) were consistent.
7. **Dealing with Outliers**: Removed outliers using the IQR method or investigated their cause.
8. **Validate Data**: Conducted final checks to ensure data consistency and completeness.


</details> 

*** 



## Dashboard Designing Process

<details> 
<summary>
A comprehensive Dashboard Designing Process
	
</summary>
<br>


1. Purpose
- Who's the audience
- what are their goal
- what questions do they need ansers to
- how often will the dashboard be reviewed?


2. Choosing the right metric
- It should align with the business goals
- level of detail is appropiate for the audience

3. Presenting the data effectively and selecting the right visuals

4. Elimiate clutter and noice
- 3d formats
- excessive colors
- bg images 
- grid lines
(Anyting that takes space but doesn't add value)


5. Use layout to focus attention
- use F for logical flow
- Put important things first


6. Tell a clear story
- use texts to give context 
- use better chart title and data lables 






1. Purpose
- Who's the audience 
    - Product Manger
- what are their goals 
    - improve the product and user flow so that the users love the product and use it regularly.
    - Reduce the friction in the major funnel
    - to make first time site visitors buy products
    - to make users buy more in one order
    - to and make users buy regularly (Make them an active user)
- what questions do they need answers to
    - where users are getting stuck
    - where users are leaving the site most
    - how the first time users interact and an active user interact with the product
    - which category the first time users and regular user purchase the most.
    - how the users are finding their products, correlation between people who order and who drop without order
    - how people land on the site and from where they land
    - how many products users are purchasing in one go.
    - how long does an user session lasts. 
    - how many products does an user view before purchasing one 
    - does user views and purchases the product when showed below in the product in the recommendation section.
    - does user views and buys product from hero display in the home page
    - for how long users are viewing a product
    - how many user add product from recommendation and feed. and how many products are added via recommendation list or feed.
- how often will the dashboard be reviewed?
    - weekly 


2. Choosing the right metric
- It should align with the business goals
- level of detail is appropiate for the audience

3. Presenting the data effectively and selecting the right visuals

4. Elimiate clutter and noice
- 3d formats
- excessive colors
- bg images 
- grid lines
(Anyting that takes space but doesn't add value)


5. Use layout to focus attention
- use F for logical flow
- Put important things first


6. Tell a clear story
- use texts to give context 
- use better chart title and data lables 




2. Metrics



2. Choosing the right metric
- It should align with the business goals
- level of detail is appropriate for the audience



For the Engagement Dashboard, I followed the "three-by-three rule" - show no more than 3 key areas with 3 core metrics each. This keeps the dashboard focused and digestible.



First Section - 
User Activity Overview:
A time series graph showing DAU/WAU/MAU trends
Average session duration over time
Sessions per user per day

Second Section - 
Feature Engagement:
Feature usage frequency (top 5-7 features)
Time spent per feature
Click-through rates on key elements

Third Section - 
User Behavior:
Session time distribution (24-hour heat map)
User journey flow (simplified version)
Interaction depth (actions per session)


</details> 

*** 





## Insight and Visualization

***

## This Project is Work in Progress 


Thanks for visiting my repository 😃🌟