
#Installation of new packages - Only once
install.packages("readxl", "writexl")   #Comment out after 1st run

#Load packages
library(haven)        #Read data files from STata, SPSS and SAS
library(magrittr)     #Pipes
library(dplyr)        #Mutate, select,....  

library(readxl)       #Read Excel files 
library(writexl)      #Write Excel files 
library(ggplot2)      #Go ggplot

#Path of my desktop
path <- "C:/Users/DstMove/Desktop/test data/"

#Read Stata file "00_GHA_BASICINFO.dta"
df_BasicInfo_Stata <- read_dta(paste0(path,"00_GHA_BASICINFO.dta")) 

#If the path is not specified, R looks after files in the 
#working directory. The current working directory can be found with

getwd()

#If you are working in a project R sets the working
#directory to the project directorty

#Read  Statafile in path
df_ExpFood_Stata <- read_dta(paste0(path,"01_GHA_EXPFOOD.dta")) 

#The working directory can be set with the function setwd()

setwd(path)

#Read csv-file from new working directory
df_ExpFood_csv <- read.csv2("glss7.csv", sep = ",")

#Save data in Rda (R format) file
save(df_ExpFood_csv, file = "MyData.Rda")

#Save data in Excel file
write_xlsx(df_ExpFood_csv, "MyData.xlsx")

#Look at data
head(df_ExpFood_csv)
str(df_ExpFood_csv)

#Define more usefull dataframe
# * select select columns
# * Renames gives smaller colnames
# * Mutate changes charater vectors to numerical

df_ExpFood <- df_ExpFood_csv %>%
  select(Household.unique.ID,
         Geographical.code,
         Survey.year,
         Survey.month,
         Adult.equivalent.scale,
         Total.number.of.residents.excluding.household.help,
         Total.expenditure.on.purchased.food.excluding.beverages..tobacco..catering.and.r,
         Total.expenditure.on.purchased.non.alcoholic.beverages) %>%
  rename(ID = Household.unique.ID,
         Region = Geographical.code,
         Year = Survey.year,
         Month = Survey.month,
         Adults = Adult.equivalent.scale,
         Res = Total.number.of.residents.excluding.household.help,
         Food = Total.expenditure.on.purchased.food.excluding.beverages..tobacco..catering.and.r,
         Beverages = Total.expenditure.on.purchased.non.alcoholic.beverages) %>%
  mutate(Adults = as.numeric(Adults),
         Food = as.numeric(Food),
         Beverages = as.numeric(Beverages)) 
# %>% filter(Year == 2017, 
#          Month < 10)

#Table Two-way table of number of observations
table(df_ExpFood$Year,df_ExpFood$Month)

#Two-way table, other direction
table(df_ExpFood$Month,df_ExpFood$Year)

#Plot Food and beverage expenditures for different regions
ggplot(data = df_ExpFood , aes(x = Food, y = Beverages, col = Region)) +
  geom_point()

#Look at data for smaller data set - take a sample of df_ExpFood
nobs <- nrow(df_ExpFood)
indx_sample <- sample(1:nobs, 1000)

#Scatter plot + (LOESS) regression of reduced data
df_sample <- df_ExpFood[indx_sample,]
ggplot(data = df_sample, aes(x = Food, y = Beverages, col = Region)) +
  geom_point() +
  geom_smooth()

