library(dplyr)
library(stringr)

#-- For debugging purpose
#   Comment to use the script in Power BI
library(readxl)
dataset <- read_xlsx(r'{C:\Users\LucaZavarella\OneDrive\MVP\Speaker\2022 - Data Saturday Parma\Demo 1\Users.xlsx}')
#--------

regex_local_part        <- r'{([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\")}'
regex_domain_name       <- r'{(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,})}'
regex_domain_ip_address <- r'{(\[?[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\]?)}'

pattern <- str_glue(
  '^({regex_local_part})@({regex_domain_name}|{regex_domain_ip_address})$'
)

df <- dataset %>% 
  mutate( isEmailValidFromRegex = as.integer(str_detect(Email, pattern)) )
