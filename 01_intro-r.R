#########################################
## Getting Started ##################


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

###########################
## Starting with Data #####
############################

## Describe what a data frame is.
## Load external data from a .csv file into a data frame.
## Summarize the contents of a data frame.
## Subset and extract values from data frames.
## Change how character strings are handled in a data frame.
## Examine and change date formats.


library(tidyverse)
library(here)

interviews <- read_csv(
  here("data", "SAFI_clean.csv"), 
  na = "NULL")

# go thru code 

# skip Factors section 


