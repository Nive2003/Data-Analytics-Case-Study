# Install and load packages
library(tidyverse)
library(readr)
library(ggplot2)
library(ggalt)


# Load and sweep data
analyst_jobs_raw <- 
  read_csv("~/Rstudio WD/DataAnalyst.csv") %>%
  janitor::clean_names()
View(analyst_jobs_raw)
# Get a quick look at our data using head() and skim()
skimr::skim(analyst_jobs_raw)
head(analyst_jobs_raw)

# Data Cleaning
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


# Salary Distribution of lower bound

ggplot(analyst_df, aes(x=lower_bound_salary)) + 
  geom_histogram(fill="white",
                 col="black")+
  labs(y="Count", 
       title="Distribution of Lower Bound Salary") + 
  scale_x_continuous(name="Lower Bound Salary", limits=c(0, 100000)) +
  scale_y_continuous(name="Count", limits=c(0, 375)) +
  theme_bw()

# Salary Distribution High End

ggplot(analyst_df, aes(x=upper_bound_salary)) + 
  geom_histogram(fill="white",
                 col="black")+
  labs(y="Count", 
       title="Distribution of Upper Bound Salary") + 
  scale_x_continuous(name="Upper Bound Salary", limits=c(0, 210000)) +
  scale_y_continuous(name="Count", limits=c(0, 335)) +
  theme_bw()

# Average Data Analyst Salary Distribution

avg_sal_dist = 
  ggplot(analyst_df, aes(x=average_bound)) + 
  geom_histogram(
    fill="white",
    col="black")+
  labs(x="Average Bound Salary",
       y="Count", 
       title="Average Data Analyst Salary Distribution")+ 
  scale_x_continuous(name="Upper Bound Salary", limits=c(0, 150000)) +
  scale_y_continuous(name="Count", limits=c(0, 350)) +
  theme_bw()


# Salary spread by Sector

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

# Heat map 

ggplot(analyst_df, aes(long, lat, group = group))+
  geom_polygon(aes(fill = total), color = "white")+
  scale_fill_distiller(palette= "OrRd", direction=1)+
  labs(x="",
       y="",
       title = "World COVID Deaths", 
       fill="Number Of Deaths")+
  theme_bw()+
  theme(plot.title = element_text(size=22)
        ,axis.text.x= element_text(size=15),
        axis.text.y= element_text(size=15),
        axis.title=element_text(size=18))
