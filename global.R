library(shiny)
library(stringr)
library(babynames)
library(rebus)
library(dplyr)
library(Hmisc)
library(plotly)

babynames1 <- babynames
# Extracting vector of names only and from 2015



#function that takes starting, ending, contains, gender, and years to create datafame of names and n
get_name_list <- function(begins = "", ends = "", contains = "", gender, start_year, end_year) {
  start_pattern <- if_else(!is.null(begins), tolower(begins), "")
  end_pattern <- if_else(!is.null(ends), tolower(ends), "")
  contains_pattern <- if_else(!is.null(contains), tolower(contains), "")
  gender1 <- ifelse(gender == "both", c("F", "M"), toupper(gender))
  if(gender == "M" | gender == "F") {
    babynames1 %>% filter(str_detect(tolower(name), pattern = START %R% start_pattern),
                         str_detect(tolower(name), pattern = end_pattern %R% END),
                         str_detect(tolower(name), pattern = contains_pattern),
                         sex == gender,
                         year >= start_year,
                         year <= end_year)%>%
      group_by(name, sex) %>%
      dplyr::summarise(total = sum(n)) %>%
      arrange(desc(total))
  } else {
    babynames1 %>% filter(str_detect(tolower(name), pattern = START %R% start_pattern),
                         str_detect(tolower(name), pattern = end_pattern %R% END),
                         str_detect(tolower(name), pattern = contains_pattern),
                         
                         year >= start_year,
                         year <= end_year)%>%
      group_by(name, sex) %>%
      dplyr::summarise(total = sum(n)) %>%
      arrange(desc(total))
  }
  
}

kevin <- babynames1 %>%
  filter(name == "Kevin" & sex == "M") 

#function to get n by years for a name and gender
years_name <- function(name_picked, gender, start_year, end_year) {
  babynames1 %>%
    filter(name == name_picked, sex == gender) %>%
    filter(year >= start_year & year <= end_year)
}
  