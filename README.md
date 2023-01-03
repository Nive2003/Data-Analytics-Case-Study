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
The purpose of this study is to help familiarize new and upcoming data analysts into the norms of the industry. 

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

```
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
```

### What is the salary spread of Data Analyst Jobs?

To find the salary spread of data analyst jobs, extract lower, middle, and upper bound salary from the dataset. Then find the means of each segment and form a histogram with the information.


##### Spread of Lower Bound Starting Salary
```
ggplot(analyst_df, aes(x=lower_bound_salary)) + 
  geom_histogram(fill="lightblue1",
                 col="black")+
  labs(y="Count", 
       title="Distribution of Lower Bound Salary") + 
  scale_x_continuous(name="Lower Salary", limits=c(0, 200000),labels=scales::dollar_format()) +
  scale_y_continuous(name="Count", limits=c(0, 450)) +
  geom_vline(xintercept = m_l_l, col = "red") +
  theme_bw()
```
![Rplot001 (2)](https://user-images.githubusercontent.com/83872954/206821478-00aa9553-5b89-4f9a-a7f8-e87d9ffec19e.png)
The mean average lower bound salary for a data analyst is $54,267

##### Spread of Average Starting Salary
```
ggplot(analyst_df, aes(x=average_bound)) + 
  geom_histogram(
    fill="lightblue1",
    col="black")+
  labs(x="Average Bound Salary",
       y="Count", 
       title="Average Data Analyst Salary Distribution")+ 
  scale_x_continuous(name="Average Salary", limits=c(0, 200000),labels=scales::dollar_format()) +
  scale_y_continuous(name="Count", limits=c(0, 450)) +
  geom_vline(xintercept = m_a_l, col = "red") +
  theme_bw()   
```
![Rplot003 (2)](https://user-images.githubusercontent.com/83872954/206821480-7d030ee4-0627-4ed2-9485-8ae900a2189d.png)
The mean salary for an average data analyst is $72,123

##### Spread of Upper Bound Starting Salary
```
ggplot(analyst_df, aes(x=upper_bound_salary)) + 
  geom_histogram(fill="lightblue1",
                 col="black")+
  labs(y="Count", 
       title="Distribution of Upper Bound Salary") + 
  scale_x_continuous(name="Upper Salary", limits=c(0, 200000),labels=scales::dollar_format()) +
  scale_y_continuous(name="Count", limits=c(0, 450)) +
  geom_vline(xintercept = m_h_l, col = "red") +
  theme_bw() 
  ```
  ![Rplot002 (4)](https://user-images.githubusercontent.com/83872954/206821481-318b33a6-1199-45a8-a1be-1e73e9ea21ca.png)
  The mean upper bound salary for an average data analyst is $89,979

### What does the Salary Spread look like per sector?
To see this, seperate the minimum, average, and maximum salaries for each sector. Afterwards, plot accordingly by using salary on the X-axis and Sectors on the Y-axis.
```
sector_df <- analyst_df %>% 
  transmute(
    val1 = lower_bound_salary,
    val2 = average_bound,
    val3 = upper_bound_salary,
    cat = sector
  ) %>%
  na.omit(sector_df) %>%
  group_by(cat) %>%
  summarise(
    min = min(val1, na.rm = T),
    avg = mean(val2, na.rm = T),
    max = max(val3, na.rm = T)
  ) %>%
  arrange(cat)
# Plot the spread with dumbbell visual
ggplot() +
  # reshape the data frame & get min value in order to draw first eye-tracking 
  geom_segment(
    data = gather(sector_df, measure, val, -cat) %>% 
      group_by(cat) %>% 
      top_n(-1) %>% 
      slice(1) %>%
      ungroup(),
    aes(x = 0, xend = val, y = cat, yend = cat),
    linetype = "dotted", size = 0.5, color = "gray80"
  ) +
  # reshape the data frame & get min/max category values to draw segment 
  geom_segment(
    data = gather(sector_df, measure, val, -cat) %>% 
      group_by(cat) %>% 
      summarise(start = range(val)[1], end = range(val)[2]) %>% 
      ungroup(),
    aes(x = start, xend = end, y = cat, yend = cat),
    color = "gray80", size = 1
  ) +
  # reshape the data frame & plot the points
  geom_point(
    data = gather(sector_df, measure, value, -cat),
    aes(value, cat, color = measure), 
    size = 3
  ) +
  # Adding labels 
  scale_x_comma(position = "bottom", limits = c(0, 200000), labels=scales::dollar_format()) +
  scale_color_ipsum(name = "Legend") +
  labs(
    x = NULL, y = NULL,
    title = "Salary Spread by Sector"
  ) +
  theme_ipsum_rc(grid = "X") +
  theme(legend.position = "top") 
```
![Rplot004](https://user-images.githubusercontent.com/83872954/206812908-7ac56b66-3e7b-43e2-87c7-b1cd59a93222.png)

This plot clearly visualizes the minimum, average, and maximum salary when grouped by sectors. Quick observations: The Accounting and Legal sector has the highest minimum salary, and the highest maximum salary. The Mining and Metals sector has the highest minimum salary. The Travel and Tourism sector has the lowest salary spread.

### Is there a correlation between Job Rating and Salary?
To see this, run a linear regression with Salary being the Dependant Variable and Job Rating being the independant variable.
```
lm_analyst_mod <- 
  linear_reg() %>% 
  set_engine("lm")

analyst_fit <- 
  lm_analyst_mod %>% 
  fit(average_bound ~ rating, data = analyst_df) %>% 
  tidy()
```
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



