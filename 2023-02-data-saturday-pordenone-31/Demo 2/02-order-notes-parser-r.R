
library(dplyr)
library(stringr)
library(tibble)
library(namedCapture)


#-- For debugging purpose
#   Comment to use the script in Power BI
library(readxl)
dataset <- read_xlsx(r'{C:\Users\LucaZavarella\OneDrive\MVP\Speaker\2023 - Data Saturday Pordenone\Demo 2\OrderNotes.xlsx}')
#--------

# Define a regex for the information (variables) contained in each row of the log
currency_regex  <- '(?:EUR|\u20ac)' # \u20ac is the unicode representation of '€'
amount_regex    <- r'{(?P<RefundAmount>\d{1,}\.?\d{0,2})}'
reason_regex    <- r'{(?P<RefundReason>.*?)}'
date_regex      <- r'{(?P<RefundDate>\d{2}[\-\/]\d{2}[\-\/]\d{4})}'
separator_regex <- r'{(?:\s+)?-?(?:\s+)?}'


regex_parts_alternative_1 <- c(
  currency_regex,
  amount_regex,
  reason_regex,
  date_regex
)

regex_parts_alternative_2 <- c(
  amount_regex,
  currency_regex,
  reason_regex,
  date_regex
)

regex_parts_alternative_3 <- c(
  date_regex,
  currency_regex,
  amount_regex,
  reason_regex
)

regex_parts_alternative_4 <- c(
  date_regex,
  amount_regex,
  currency_regex,
  reason_regex
)

regex_parts_template <- c(
  '(?J)', # this allows multiple named capturing groups to share the same name
  '^(?:',
  str_glue('(?:{paste(regex_parts_alternative_1, collapse = separator_regex)}', separator_regex, ')'),
  '|',
  str_glue('(?:{paste(regex_parts_alternative_2, collapse = separator_regex)}', separator_regex, ')'),
  '|',
  str_glue('(?:{paste(regex_parts_alternative_3, collapse = separator_regex)}', separator_regex, ')'),
  '|',
  str_glue('(?:{paste(regex_parts_alternative_4, collapse = separator_regex)}', separator_regex, ')'),
  ')$'
)

pattern <- paste0(regex_parts_template, collapse = '')

extracted_df <- data.frame( str_match_named( dataset$Notes, pattern = pattern )  )


df <- dataset %>% 
  bind_cols(
    extracted_df %>%
      mutate( across(where(is.character), ~na_if(., "")) ) %>% 
      mutate(
        RefundAmountMerged = as.numeric(coalesce(!!! select(., matches(r"{RefundAmount}")))),
        RefundDateMerged = coalesce(!!! select(., matches("RefundDate"))),
        RefundReasonMerged = coalesce(!!! select(., matches("RefundReason")))
      ) %>% 
      select( RefundAmount = RefundAmountMerged,
              RefundDate = RefundDateMerged,
              RefundReason = RefundReasonMerged )
  )
