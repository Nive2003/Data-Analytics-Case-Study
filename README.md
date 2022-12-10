# Introduction: 
The purpose of this case study is to understand the Data Science/Engineer/Analyst job market.

# About This Dataset
This dataset was created by <a href="https://github.com/picklesueat/data_jobs_data">picklesueat</a> and contains more than 2000 job listing for data analyst positions, with features such as:
<ul>
  <li> Salary Estimate
  <li> Location
  <li> Company Rating
  <li> Job Description
  <li> and more.
</ul>

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
![Rplot001 (2)](https://user-images.githubusercontent.com/83872954/206821478-00aa9553-5b89-4f9a-a7f8-e87d9ffec19e.png)
![Rplot003 (2)](https://user-images.githubusercontent.com/83872954/206821480-7d030ee4-0627-4ed2-9485-8ae900a2189d.png)
![Rplot002 (4)](https://user-images.githubusercontent.com/83872954/206821481-318b33a6-1199-45a8-a1be-1e73e9ea21ca.png)
![Rplot004](https://user-images.githubusercontent.com/83872954/206812908-7ac56b66-3e7b-43e2-87c7-b1cd59a93222.png)


# Conclusion: 

Our t-statistic of 1.89 with a very high standard error does not meet the statistical threshold of significance.
The estimate shows us that for every unit increase in rating, the salary increases by $1506. While our P value is 0.058, higher than any alpha threshold would bear as significant.
So the long answer to the original question is: yes there is a correlation between rating and salary; however, it is not a significant linear correlation.
