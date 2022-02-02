#########################################
##### Data Wrangling with dplyr and tidyr
#########################################

# Questions  -  find the line, also review
# How can I select specific rows and/or columns from a dataframe?
# How can I combine multiple commands into a single command?
# How can I create new columns or remove existing columns from a dataframe?
# How can I reformat a dataframe to meet my needs?


#########################################
##### from previous lesson
#########################################

# 1) set up folders
dir.create("data")
dir.create("data_output")
dir.create("fig_output")

# 2) download the data
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb")

# 3) install packages
install.packages("tidyverse")
install.packages("here")


#########################################
##### What is an R Package
#########################################

# In the previous lesson we touched on R packages, how to install and 
# load them. Packages extend the functionality of R.

# Today we are going to be working with dplyr and tidyr:
# tidyverse:  The tidyverse is an opinionated collection of R packages 
#    designed for data science.<https://www.tidyverse.org/>
# The tidverse collection INCLUDES both dplyr and tidyr

# dplyr: provides easy tools for most common data wrangling taskes.  
#    it is built to work with dataframes.

# tidyr: addresses the common problem of wanting to reshape your data 
#    for plotting and use by other R package

# here: The goal of the here package is to enable easy file referencing 
#    in project-oriented workflows. In contrast to using setwd(), 
#    which is fragile and dependent on the way you organize your files, 
#    here uses the top-level directory of a project to easily build paths 
#    to files. <https://here.r-lib.org/>


# load the tidyverse
library(tidyverse)
library(here)

interviews <- read_csv(here("data", "SAFI_clean.csv"), na = "NULL")

View(interviews)
interviews

#########################################
##### Inspect the data with dplyr
########################################## 

# common dplyr functions we will be using:
#     select(): subset columns
#     filter(): subset rows on conditions
#     mutate(): create new columns by using information from other columns
#     arrange(): sort results
#     count(): count discrete values


## review
dim(interviews) # returns a vector with the number of rows as the first element, and the number of columns as the second element (the dimensions of the object)
nrow(interviews) # returns the number of rows
ncol(interviews) # returns the number of columns

head(interviews) # shows the first 6 rows
tail(interviews) # shows the last 6 rows

names(interviews) # returns the column names (synonym of colnames() for data.frame objects)

str(interviews) # structure of the object and information about the class, length and content of each column
summary(interviews) # summary statistics for each column
glimpse(interviews) # returns the number of columns and rows of the tibble, the names and class of each column, and previews as many values will fit on the screen. Unlike the other inspecting functions listed above, glimpse() is not a “base R” function so you need to have the dplyr or tibble packages loaded to be able to execute it.

names(interviews)

#  select columns and filter rows

# select columns individually or in a range
select(interviews, village, no_membrs, items_owned, no_meals, months_lack_food)
select_test <-select(interviews, village, no_membrs, items_owned, no_meals, months_lack_food)

# base-R  method
interviews[c("village", "no_membrs", "items_owned", "no_meals", "months_lack_food")]
select_test2 <-interviews[c("village", "no_membrs", "items_owned", "no_meals", "months_lack_food")]

# select a range of columns
select(interviews, village:respondent_wall_type)

# filter rows
filter(interviews, village == "Chirodzo")

# multiply conditions with "and" or  "or"
# And: observations must meet every criteria  use , (comma) or & (ampersand)
# Or: observations must meet at least one criterisk   use | logical operator symbol

# example of And

filter(interviews, village == "Chirodzo", 
       rooms > 1, 
       no_meals > 2)

filter(interviews, village == "Chirodzo" & rooms > 1 & no_meals > 2)



# example OR

filter(interviews, village == "Chirodzo" | village == "Ruaca")



# select And filter
interviews2 <- filter(interviews, village == "Chirodzo")
interviews_ch <- select(interviews2, village:respondent_wall_type)

interviews_ch <- select(filter(interviews, village == "Chirodzo"),
                        village:respondent_wall_type)

##  Pipes
## Pipes in R  %>%    (cntl-shift-M  or cmd-shift-M)
# A pipe is a form of redirection (transfer of standard output to some other destination) 
#  that is used in Linux and other Unix-like operating systems to send the output 
#  of one command/program/process to another

# task:  you want to both select and filter
#multiple calls - 
interviews2 <- filter(interviews, village == "Chirodzo")
interviews_ch <- select(interviews2, village:respondent_wall_type)

#  nest functions
interviews_ch <- select(filter(interviews, village == "Chirodzo"),
                        village:respondent_wall_type)

# pipping
interviews %>%
  filter(village == "Chirodzo") %>%
  select(village:respondent_wall_type)

interviews_filtered <- interviews %>%
  filter(village == "Chirodzo") %>%
  select(village:respondent_wall_type)

##################################
#   Exercise
##################################

# Using pipes, subset the interviews data to include interviews where respondents 
# were members of an irrigation association (memb_assoc) and retain only the columns 
# affect_conflicts, liv_count, and no_meals.

interviews %>%
  filter(memb_assoc == "yes") %>%
  select(affect_conflicts, liv_count, no_meals)


################################
#  Mutate  create new columns from existing columns
################################

people_per_room <- interviews %>%
  mutate(people_per_room = no_membrs / rooms)


people_per_room <- interviews %>%
  mutate(people_per_room = no_membrs / rooms, people_per_room = as.integer(people_per_room))
  
#  We may be interested in investigating whether being a member of an irrigation association
#  had any effect on the ratio of household members to rooms. To look at this relationship, 
#  we will first remove data from our dataset where the respondent didn’t answer the question 
#  of whether they were a member of an irrigation association. 
#  These cases are recorded as “NULL” in the dataset.

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  mutate(people_per_room = no_membrs / rooms)

# ?summarize
#########################################
#  Summarize function, group_by and statistics
# often grouped together
# collapse each group into a single-row summary of that group
########################################

summary(interviews)  # not the same as summarize


interviews %>% 
  group_by(village)

# summarize a column

interviews %>% 
  group_by(village) %>% 
  summarize(mean(no_membrs))

#  give the new column a better title
interviews %>% 
  group_by(village) %>% 
  summarize(new_title = mean(no_membrs))

# group by multiple columns
interviews %>% 
  group_by(village, memb_assoc) %>% 
  summarize(new_title = mean(no_membrs))

#  ungroup   ungroup is needed 
# because group() creates a grouped dataframe under the hood
interviews %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs)) %>%
  ungroup()

#  again getting rid of the NAs

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs))

interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            min_membrs = min(no_membrs))

# rearranging your output
#  summarize()

# default ascending order
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            min_membrs = min(no_membrs)) %>%
  arrange(min_membrs)

# specifiy decending
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs),
            min_membrs = min(no_membrs)) %>%
  arrange(desc(min_membrs))


#  Counting observations
interviews %>% 
  count(village)


interviews %>% 
  count(village, sort = TRUE)

## Note:  n() gives the current group size.
?n  
# n()
# Context dependent expressions
# These functions return information about the "current" group or "current" variable, 
# so only work inside specific contexts like summarise() and mutate()
#  n() can only be used within dplyr verbs such as summarise or mutate
interviews %>% 
  count(village) %>% 
  number_villages = n()  # doesn't work'

interviews %>% 
  group_by(village) %>% 
  summarize ( max_num_members = max(no_membrs), village_group_size = n())

#####################################
#  Exercise 2a: 
###################################
# How many households in the survey have an average of two meals per day? 
# Three meals per day? Are there any other numbers of meals represented?

interviews %>%
  count(no_meals)



#######################################
# Exercise 2b: 
##############################
# Use group_by() and summarize() to find the mean, min, and max number of household members for each village. Also add the number of observations (hint: see ?n).

interviews %>%
  group_by(village) %>%
  summarize(
    mean_num_membrs = mean(no_membrs),
    min_num_membrs = min(no_membrs),
    max_num_membrs = max(no_membrs),
    number = n()
  )


# Exporting your data
write_csv(people_per_room, file = "data_output/people_per_room.csv")


############################
# Reshaping data with pivot_wider() and pivot_longer()
################################

# 3 Rules of TidyData
# 1) Each variable has its own column
# 2) Each observation has its own cell
# 3) Each value must have its own cell

# Long and wide data formats
# may affect readability
# Long data: each column represents a differnt variable
#     Generally only 3 columns,
#     1 for the id variable, 1 for the observed variable, and 1 for the observed value

#  pivot_wider()
#  pivot_longer()

#pivot_wider() "widens" data, increasing the number of columns and decreasing the 
# number of rows. The inverse transformation is pivot_longer().

#Reformating your data:
#  tidyr functions:
#  pivot_wider()
#pivot_longer()


# Wide data: each column can represent different levels/values of a variable
# https://tidyr.tidyverse.org/reference/pivot_wider.html#details

# Example 1: using pivot_wider(), create new colums for wall constructions type


# If instead of the default value being NA, we wanted these values to be FALSE, 
# we can insert a default value into the values_fill argument. 
# By including values_fill = list(wall_type_logical = FALSE) inside pivot_wider(), 
# we can fill the remainder of the wall type columns for that row with the value FALSE.

interviews_wide <- interviews %>%
  mutate(wall_type_logical = TRUE) %>%    #  create new column
  pivot_wider(names_from = respondent_wall_type,
              values_from = wall_type_logical,
              values_fill = list(wall_type_logical = FALSE))


# just see the columns you created:

select(interviews_wide, village, muddaub:cement)
