#########################################
##### Getting Started ##################
#######################################

## Creating a project in RStudio
#Under the File menu, click on New project, choose New directory, then New project
#Enter a name for this new folder (or “directory”) and choose a convenient location for it. This will be your working directory for the rest of the day (e.g., ~/data-carpentry)
#Click on Create project
#Create a new file where we will type our scripts. Go to File > New File > R script. Click the save icon on your toolbar and save your script as “script.R”.

install.packages()

dir.create("data")
dir.create("data_output")
dir.create("fig_output")

#download data we'll use & put in our data/ folder witn name SAFI_clean.csv
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb")



# interacting with R
# console to play and work out code 
# writing them as script and running lines or blocks of code with Run or cmd + return (mac), ctr + enter (win)
# many more shortcuts in Rstudio: <https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf> 
# diff ways to install packages 

#############################
# Introduction to R ## 
#############################
# Objectives 
# Define the following terms as they relate to R: object, assign, call, function, arguments, options.
# Assign values to objects in R.
# Learn how to name objects.
# Use comments to inform script.
# Solve simple arithmetic operations in R.
# Call functions and use arguments to change their default options.
# Inspect the content of vectors and manipulate their content.
# Subset and extract values from vectors.
# Analyze vectors with missing data.

# creating objects in R 
3 + 5
12 / 7

# to do useful things we need to assign values to variables/objects 

area_hectares <- 1.0

# <- is the assignment operator
#shortcuts:  Alt + - (win), Option + - (mac)
#The arrow can be read as 1.0 goes into area_hectares.
#objects names: can't start with number, are case sensitive, no spaces 
# can't use reserved words: https://stat.ethz.ch/R-manual/R-devel/library/base/html/Reserved.html

area_hectares <- 1.0    # doesn't print anything
(area_hectares <- 1.0)  # putting parenthesis around the call prints the value of `area_hectares`
area_hectares         # and so does typing the name of the object
2.47 * area_hectares
area_hectares <- 2.5
2.47 * area_hectares
area_acres <- 2.47 * area_hectares
area_hectares <- 50
# What do you think is the current content of the object area_acres? 123.5 or 6.175?

# Comments using the pound sign 
# anything to the right of the # is treated as comment and ignored 

area_hectares <- 1.0			# land area in hectares
area_acres <- area_hectares * 2.47	# convert to acres
area_acres				# print land area in acres.

# rstudio has short cuts for commenting: Ctrl + Shift + C to comment and uncomment

############################
## Functions and their arguments ## 
##############
# Functions are “canned scripts” that automate more complicated sets of commands
# many functions are predefined by R or packages we install 
# functions usually get inputs called **arguments** 
# let's look at the function for square root 

sqrt(25) #takes input an returns the square root 

# and another 

round(3.14159)
# default of round is to nearest whole number, but we can change with argument

args(round) #tells us the agruments round can take 

round(3.14159, digits = 3)

## Round help Exercise
## Type in ?round at the console and then look at the output in the Help pane. 
## What other functions exist that are similar to round? How do you use the digits 
## parameter in the round function? Type in chat. 

ceiling(3.14159)
floor(3.14159)

## Vectors 

hh_members <- c(3, 7, 10, 6)
hh_members

respondent_wall_type <- c("muddaub", "burntbricks", "sunbricks")
respondent_wall_type

# why do we quote the elements in the c function? without quotes r will tink they are existing objeccts
# and since they aren't it will throw an error. 
# length, class 
# subset 
# we can access elements in a vector: 

respondent_wall_type[-3]

# we can use th c() function to subset 

respondent_wall_type(c(1, 2))

# can subset by conditional: 

hh_members > 5

# note reurns vector of true and false 
# with this we can use this true/false vector to subset 


hh_members[hh_members > 5]

# this is saying we want to return only those elements grater than five


# skip length, class, str with starting with data 

#An atomic vector is the simplest R data type and is a linear vector of a single type.
# The other 4 atomic vector types are:
# "logical" for TRUE and FALSE (the boolean data type)
# "integer" for integer numbers (e.g., 2L, the L indicates to R that it’s an integer)
# "complex" to represent complex numbers with real and imaginary parts (e.g., 1 + 4i) and that’s all we’re going to say about them
# "raw" for bitstreams that we won’t discuss further

c(TRUE, FALSE)

# Vectors are one of the many data structures that R uses. Other important ones are lists (list), 
# matrices (matrix), data frames (data.frame), factors (factor) and arrays (array).


# Missing data 
# * Missing data are represented in vectors as NA. 
# * be aware of that many functions will return 

rooms <- c(2, 1, 1, NA, 7)
mean(rooms)
max(rooms)
mean(rooms, na.rm = TRUE)
mas(rooms, na.rm = TRUE)

###########################
## Starting with Data #####
############################

## Describe what a data frame is.
## Load external data from a .csv file into a data frame.
## Summarize the contents of a data frame.
## Subset and extract values from data frames.
## Change how character strings are handled in a data frame.
## Examine and change date formats.

# let's import libraries we need 

library(tidyverse)
#install.packages('here')
library(here)

# dataframe are defacto data structure in R for representing tabular data 
# what we use for data processing, stats & plotting 
# format of a table where columns are vectors that all have same length
# like excel but each column must have same data type 
# see: https://datacarpentry.org/r-socialsci/fig/data-frame.svg
# can be created by hand but more typically we read them in from a file like a CSV

## Data 

# we'll be using the SAFI(Studying African Farmer-Led Irrigation) study 
#looking at farming and irrigation methods in Tanzania and Mozambique
# collected through interviews conducted between November 2016 and June 2017
#show: 
# https://datacarpentry.org/r-socialsci/02-starting-with-data/index.html#presentation-of-the-safi-data

## Importing the data 
# to read in data we use a read_csv() function that is part of readr in the tidyverse
# when we loaded the tidyverse (library(tidyverse)), 
# the core packages (the packages used in most data analyses) get loaded, including readr

# it can be difficult to learn how to specify paths to file locations. 
# Enter the here package! 
# The here package creates paths relative to the top-level directory (your RStudio project). 
# These relative paths work regardless of where the associated source file lives 
# inside your project, like analysis projects with data and reports in different subdirectories. 
# This is an important contrast to using setwd(), 
# which depends on the way you order your files on your computer.


interviews <- read_csv(
  here("data", "SAFI_clean.csv"), 
  na = "NULL") # set our NA value from the data set, show data 

# * we notice the here() function takes folder and file names as inputs (e.g., "data", "SAFI_clean.csv"), each enclosed in quotations ("") and separated by a comma.
# * The here() will accept as many names as are necessary to navigate to a particular file 
# (e.g., here("analysis", "data", "surveys", "clean", "SAFI_clean.csv)).
# * note the diff b/t read_csv & read.csv 
# * The second statement in the code above creates a data frame but doesn’t output any data because, as you might recall, assignments (<-) don’t display anything. 
# * (Note, however, that read_csv may show informational text about the data frame that is created.) 
# * If we want to check that our data has been loaded, we can see the contents of the data frame by typing its name: interviews in the console.

interviews

# Note that read_csv() actually loads the data as a tibble. 
# A tibble is an extension of R data frames used by the tidyverse. 
#When the data is read using read_csv(), it is stored in an object of class tbl_df, tbl, and data.frame. 
# We can see the class of an object with:

class(interviews)

## inspecting data frames functions 
# note when we print out a data frame we get a lot of info in the out put 
# but there are a number of functions we will use to inspect data frames

dim(interviews) # rows & columns, how many rows do we have?
nrow(interviews) # just the rows
ncols(interviews) # cols 
#what do you think this produces? 
head(interviews) # first six rows, you can make it show more or less by add a number
#what if i add comma and 10?
head(interviews, 10) 
#what about this? 
tail(interviews) # bottom six
#again?
names(interviews) # this is a vector, we can subset it like a vector
#what if i want to get at just the `village` name
names(interviews)[2]

### summarization 
str(interviews) #structure of the object & info about the class, note the similarity to Environment
summary(interviews) # summary stats for each col 
glimpse(interviews) # num or col and rows, names, and value previews
# glimpse comes from the tidyverse
#most of these functions are generic - they can be used on other R data types

## indexing and subsetting data frames 

# first element of the data frame - returned as a data frame
interviews
interviews[1, 1]
# first element in the 6th column of the tibble
interviews[1,6]
#first column of the tibble (as a vector)
interviews[[1]] #think of unwrapping the onion here 
#first column of the tibble 
interviews[1]
#first three elements in the 7th column of the tibble 
interviews[1:3, 7] #we use the colon to get the first three rows of 7th column
#third row fo the tibble 
interviews[3,]
# equivalent of head_interviews <- head(interivews)
head_interviews <- interviews[1:6, ]
#what is this the equivalant to? 
# yes
head_interviews <- head(interviews)
#omission 
interviews[, -1] #what wil this give? 
#everything except the first column
interviews[-c(7:131),] #equivalent to ? 

# we can subset by names too: 
interviews["village"]
interviews[,"village"]
interviews[["village"]] #what does this return
interview$village 

# skip Factors section 


