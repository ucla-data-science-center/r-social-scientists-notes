---
title: "r_social_scientists_datawrangling"
author: "carpentry lesson"
date: "2/1/2022"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R for Social Scientists: Data Wrangling with dplyr and tidy r 

### Questions
- How can I select specific rows and/or columns from a dataframe? 
- How can I combine multiple commands into a single command? 
- How can I create new columns or remove existing columns from a dataframe? 
- How can I rearrange data to meet my needs? 
- How do I save my new data to a file? 

### From last workshop:
1) set up folders 
dir.create("data") 
dir.create("data_output") 
dir.create("fig_output") 

2) download the data 
download.file("https://ndownloader.figshare.com/files/11492171", 
              "data/SAFI_clean.csv", mode = "wb") 

3) install packages 
install.packages("tidyverse") 
Note: tidyverse includes dplyr and tidyr as well as other related packages 
install.packages("here") 

4) load the packages 
library(tidyverse) 
library(here) 

5)  read the data into a frame 
interviews <- read_csv(here("data", "SAFI_clean.csv"), na = "NULL") 

### Quick Review: functions from previous workshop
**dim(data)** returns a vector with the number of rows as the first element, and the number of columns as the second element (the dimensions of the object)  
**nrow(data-frame)** returns the number of rows  
**ncol(data-frame)** returns the number of columns   

**head(data-frame)** shows the first 6 rows  
**tail(data-frame)** shows the last 6 rows  

**names(data-frame)** returns the column names (synonym of colnames() for data.frame objects) 

**str(data-frame)** structure of the object and information about the class, length and content of each column  
**summary(data-frame)** # summary statistics for each column  
**glimpse(data-frame)** # returns the number of columns and rows of the tibble, the names and class of each column, and previews as many values will fit on the screen. Unlike the other inspecting functions listed above, glimpse() is not a “base R” function so you need to have the dplyr or tibble packages loaded to be able to execute it.  


## Inspecting the Data with dplyr  
### common dplyr functions  
- **select()** subset columns  
- **filter()** subset rows on conditions  
- **mutate()** create new columns by using information from other columns  
- **arrange()**  sort results  
- **count()** count discrete values  

### select() 
#### Columns can be selected individually or in a range. 

select(interviews, village, no_membrs, items_owned, no_meals, months_lack_food)  

interviews[c("village", "no_membrs", "items_owned", "no_meals", "months_lack_food")] 

#### or in a range. 
select(interviews, village:respondent_wall_type)  


#### Creating a subset of your data  
data_subset <- select(interviews, village, no_membrs, items_owned, no_meals, months_lack_food)  

### filter() 
#### filter rows 
filter(interviews, village == "Chirodzo") 

#### multiply conditions with "and" or  "or" 
**And:** observations must meet every criteria  use , (comma) or & (ampersand)  
**Or:** observations must meet at least one criterisk   use | logical operator symbol 


#### Examples using And 
filter(interviews, village == "Chirodzo",  
       rooms > 1,  
       no_meals > 2) 

filter(interviews, village == "Chirodzo" & rooms > 1 & no_meals > 2) 

#### Example using OR 
filter(interviews, village == "Chirodzo" | village == "Ruaca") 

### pipes  

#### Pipes in R  %>%    (cntl-shift-M  or cmd-shift-M) 

A pipe is a form of redirection (transfer of standard output to some other destination) that is used in Linux and other Unix-like operating systems to send the output of one command/program/process to another  

interviews %>%  
  filter(village == "Chirodzo") %>%  
  select(village:respondent_wall_type)  

## Exercise 1:  
#### Subsetting your data  
Using pipes, subset the interviews data to include interviews where respondents were members of an irrigation association (memb_assoc) and retain only the columns affect_conflicts, liv_count, and no_meals.   

answer:  

interviews %>% 
  filter(memb_assoc == "yes") %>% 
  select(affect_conflicts, liv_count, no_meals) 
  

### mutate()  Creating new columns from existing columns  

people_per_room <- interviews %>%  
  mutate(people_per_room = no_membrs / rooms)  

people_per_room <- interviews %>%  
  mutate(people_per_room = no_membrs / rooms, people_per_room = as.integer(people_per_room))  
 
interviews %>% 
  filter(!is.na(memb_assoc)) %>% 
  mutate(people_per_room = no_membrs / rooms) 


### summarize and group_by:  often used together  

summary(interviews)  # not the same as summarize  
 
 
interviews %>%   
  group_by(village)  

**summarize a column**  

interviews %>%     
  group_by(village) %>% 
  summarize(mean(no_membrs))  

**give the new column a better title**
interviews %>% 
  group_by(village) %>% 
  summarize(new_title = mean(no_membrs))

**group by multiple columns  
interviews %>%   
  group_by(village, memb_assoc) %>%   
  summarize(new_title = mean(no_membrs))  

**ungroup   
interviews %>%  
  group_by(village, memb_assoc) %>%  
  summarize(mean_no_membrs = mean(no_membrs)) %>%  
  ungroup()  

**again getting rid of the NAs  
 
interviews %>%  
  filter(!is.na(memb_assoc)) %>%  
  group_by(village, memb_assoc) %>%  
  summarize(mean_no_membrs = mean(no_membrs))  

interviews %>%  
  filter(!is.na(memb_assoc)) %>%  
  group_by(village, memb_assoc) %>%  
  summarize(mean_no_membrs = mean(no_membrs),  
            min_membrs = min(no_membrs))  

### arrange():   ie. sort, rearranges your youput.  Descending is the default  
#### rearranging your output.
#### Descending order is the default   

**default ascending order** 
interviews %>%  
  filter(!is.na(memb_assoc)) %>%  
  group_by(village, memb_assoc) %>%  
  summarize(mean_no_membrs = mean(no_membrs),  
            min_membrs = min(no_membrs)) %>%   
  arrange(min_membrs)  

**specifiy decending   
interviews %>%  
  filter(!is.na(memb_assoc)) %>%  
  group_by(village, memb_assoc) %>%  
  summarize(mean_no_membrs = mean(no_membrs),  
            min_membrs = min(no_membrs)) %>%  
  arrange(desc(min_membrs))  

### count()   
interviews %>%   
  count(village)  


interviews %>%   
  count(village, sort = TRUE)  
  
  
#### Note:  n() gives the current group size.  
**?n**    get information about n() function  
**n()**  
**Context dependent expressions**  
- These functions return information about the "current" group or "current" variable, so only work inside specific contexts like summarise() and mutate()  
 - n() can **only** be used within dplyr verbs such as **summarise** or **mutate**  

**incorrect usage of n()**
interviews %>%  
  count(village) %>%  
  number_villages = n()  # doesn't work' 

**correct useage of n()**  
interviews %>%   
  group_by(village) %>%   
  summarize ( max_num_members = max(no_membrs), village_group_size = n())  
  
  
## Exercise 2a: 
How many households in the survey have an average of two meals per day? Three meals per day? Are there any other numbers of meals represented?  

interviews %>% 
  count(no_meals) 
 

## Exercise 2b:  
Use group_by() and summarize() to find the mean, min, and max number of household members for each village. Also add the number of observations (hint: see ?n). 

interviews %>%  
  group_by(village) %>%  
  summarize(  
    mean_num_membrs = mean(no_membrs),  
    min_num_membrs = min(no_membrs),  
    max_num_membrs = max(no_membrs),  
    number = n()  
  )  


## Reformating your data:  
#### tidyr functions:  
**pivot_wider()**  
**pivot_longer()**  

pivot_longer() can work with multiple value variables that may have different types, inspired by the enhanced melt() and dcast() functions provided by the data.table package by Matt Dowle and Arun Srinivasan.  
pivot_longer() and pivot_wider() can take a data frame that specifies precisely how metadata stored in column names becomes data variables (and vice versa), inspired by the cdata package by John Mount and Nina Zumel.  
__From:  https://tidyr.tidyverse.org/articles/pivot.html__

pivot_wider() "widens" data, increasing the number of columns and decreasing the number of rows. The inverse transformation is pivot_longer(). 
__see:  vignette("pivot") and https://tidyr.tidyverse.org/articles/pivot.html__

## Exporting your data from R: 
write_cst(frame-name, file = "folder_name/output_file_name.csv") 
