## Start of the script

## First we load the packages we need
library(tidyverse)
library(openxlsx)

## Read the Excel-files. Make sure they are in your project folder!

mar_credit <- read.xlsx("4_SB_MAINTENANCE and REPAIR.xlsx",
                        sheet = "Credit",
                        rows = 3:284)

mar_debit <- read.xlsx("4_SB_MAINTENANCE and REPAIR.xlsx",
                        sheet = "Debit",
                        rows = 3:284)

## It is a good idea to load most datasets in the start of your script. This makes
## it easier to see what data goes into your calculations. So event though we will
## not use it right now, we also read the group-data.
eu_groups <- read.xlsx("groups.xlsx")

## Make the debit-data into long format
mar_debit_long <- mar_debit |> 
  select(-Description) |> 
  pivot_longer(cols = matches("\\d{4}"),
               names_to = "year",
               values_to = "debit")

## The same with credit
mar_credit_long <- mar_credit |> 
  select(-Description) |> 
  pivot_longer(cols = matches("\\d{4}"),
               names_to = "year",
               values_to = "credit")

## Join the two datasets together
mar_long <- credit_long |> 
  ## Notice the use of full_join here! Useful if you need to have all values fro
  ## both datasets
  full_join(debit_long,
            by = c("Code", "year"))

## Calculate the balance
mar_long <- mar_long |> 
  mutate(balance = credit-debit)

## Convert the year into a numeric variable
mar_long <- mar_long |> 
  mutate(year = as.numeric(year))

## This is a long pipe!!
group_long <- mar_long |> 
  ## First we join the group data 
  left_join(eu_groups,
            by = c("Code" = "code")) |> 
  ## Then we remove the countries that don't have a group
  filter(!is.na(Code)) |> 
  ## We group the data by country-group and year and then just sum the different
  ## columns
  group_by(group, year) |> 
  summarise(debit = sum(debit),
            credit = sum(credit),
            balance = sum(balance)) |> 
  ungroup() |> 
  ## To make the dataset more consistent we rename our column to "Code"
  rename(Code = group) 

## Now we begin the process of rearranging the data into the format of the excel-file
## First the country-data
## Credit, debit and balance into a long format. We store them in a column called
## bop. Feel free to choose another name :)
mar_untidy <- mar_long |> 
  pivot_longer(cols = c(credit, debit, balance),
               names_to = "bop",
               values_to = "value") 

## Recode the value into a single letter like in the excel file
mar_untidy <- mar_untidy |> 
  mutate(bop = case_when(bop == "credit" ~ "C",
                         bop == "debit" ~ "D",
                         bop == "balance" ~ "B"))

## Rearrange the data so there is one column for each year
mar_untidy <- mar_untidy |> 
  pivot_wider(names_from = year, values_from = value)

##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##

## And now the group data. You have to fill out this part yourselves.
## You need to do exactly the same as for the country data
group_untidy <- "???" ## Insert your code here!

##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##

## Finally write the result to an excel-file with a little but of tidying
write.xlsx(list("EU groups" = group_untidy,
                "Countries" = mar_untidy),
           file = "output.xlsx",
           colNames = TRUE,
           borders = "columns",
           headerStyle = createStyle(fgFill = "yellow"))
