# Introduction: 
The purpose of this case study is to understand the Data Science/Engineer/Analyst job market. The analysis of the code can be found <a href="https://www.kaggle.com/code/lawrencemak/data-analyst-dataframe?scriptVersionId=113413389">here</a>.

# About This Dataset
This dataset was created by <a href="https://github.com/picklesueat/data_jobs_data">picklesueat</a> and contains more than 2000 job listing for data analyst positions, with features such as:
<ul>
  <li> Salary Estimate
  <li> Location
  <li> Company Rating
  <li> Job Description
  <li> and more.
</ul>

The coding for this dataset was done in Rstudio and can be found in the repository.

# Problems: 
<ul>
  <li> What is the salary spread of Data Analyst Jobs?
    <ul>
      <li> Spread of Minimum Starting Salary
        <li> Average Spread of Starting Salary
          <li> Spread of Maximum Starting Salary
    </ul>
      <li> What does the Salary Spread look like per sector?
            <li> Is there a correlation between Job Rating and Salary?
        </ul>


# Solutions:

### Data Cleaning

In order to answer the problems listed above, we must ensure that our data is clean and usable. 

'''
analyst_df <- 
  analyst_jobs_raw %>% 
  transmute(
    company_name = gsub("[[:digit:]]","",
                        gsub("\\.","",
                             company_name)),
    job_title = str_extract(job_title,
                            pattern = "^([^,])+"), 
    job_description, 
    location, 
    rating = case_when(rating != -1 ~ as.numeric(rating), TRUE ~ NA_real_),
    founded = case_when(founded != -1 ~ as.numeric(founded), TRUE ~ NA_real_),  
    industry = case_when(industry != "-1" ~ as.character(industry), TRUE ~ NA_character_), 
    sector = case_when(sector != "-1" ~ as.character(sector), TRUE ~ NA_character_),
    
    lower_bound_salary = str_extract(salary_estimate, 
                                     pattern = "[:digit:]{2,3}"), 
    lower_bound_salary = as.numeric(lower_bound_salary) * 1000, 
    
    upper_bound_salary = str_extract(salary_estimate, 
                                     pattern = "([:digit:]{2,})(?=K \\(G)"),
    upper_bound_salary = as.numeric(upper_bound_salary) * 1000, 
    
    average_bound = (lower_bound_salary + upper_bound_salary) / 2
  )

'''

### What is the salary spread of Data Analyst Jobs?

![Rplot001 (2)](https://user-images.githubusercontent.com/83872954/206821478-00aa9553-5b89-4f9a-a7f8-e87d9ffec19e.png)
'''

'''
![Rplot003 (2)](https://user-images.githubusercontent.com/83872954/206821480-7d030ee4-0627-4ed2-9485-8ae900a2189d.png)
![Rplot002 (4)](https://user-images.githubusercontent.com/83872954/206821481-318b33a6-1199-45a8-a1be-1e73e9ea21ca.png)

### What does the Salary Spread look like per sector?
![Rplot004](https://user-images.githubusercontent.com/83872954/206812908-7ac56b66-3e7b-43e2-87c7-b1cd59a93222.png)

### Is there a correlation between Job Rating and Salary?
<table>
  <tr>
    <th>term</th>
    <th>estimate</th>
    <th>std.error</th>
    <th>statistic</th>
    <th>p-value</th>
  </tr>
  <tr>
    <td>(Intercept)</td>
    <td>66402.503</td>
    <td>3012.8510</td>
    <td>22.039757</td>
    <td>1.923299e-96</td>
  </tr>
  <tr>
    <td>rating</td>
    <td>1505.589</td>
    <td>794.6819</td>
    <td>1.894581</td>
    <td>5.829370e-02</td>
  </tr>
</table>
Our t-statistic of 1.89 with a very high standard error does not meet the statistical threshold of significance.
The estimate shows us that for every unit increase in rating, the salary increases by $1506. While our P value is 0.058, higher than any alpha threshold would bear as significant.
So the long answer to the original question is: yes there is a correlation between rating and salary; however, it is not a significant linear correlation.

![Rplot005](https://user-images.githubusercontent.com/83872954/206822457-fcf0f5ab-0ad1-4994-a798-c30006b34acb.png)

# Conclusion: 


