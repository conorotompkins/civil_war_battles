library(tidyverse)
library(rvest)

url <- "https://www.nps.gov/abpp/battles/bystate.htm"
read_html(url) %>%
  html_nodes("ul") %>%
  html_nodes("li") %>%
  html_text() %>% 
  tibble() -> states_basic


#read_html(url) %>%
#  html_nodes("ul") %>%
#  html_nodes("li") %>% 
#  html_attr("href")
  
states_basic
#write_csv(states_basic, "data/states_basic.csv")
states_basic <- read_csv("data/states_basic.csv")

states_basic %>% 
  rename(state_link = ".") %>% 
  separate(state_link, sep = "\\(", into = c("battle", "link")) %>% 
  mutate(battle = str_replace(battle, "''", ""),
         link = str_replace(link, "\\)", "")) -> states


states

base_url <- "https://www.nps.gov/abpp/battles/"
states %>% 
  mutate(link = str_c(base_url, link, ".htm")) -> states


states[1,] %>% 
  select(link) %>% 
  unlist() %>% 
  read_html() %>% 
  html_nodes("p") %>% 
  #html_nodes("b") %>% 
  #html_nodes("Location") %>% 
  html_text() %>% 
  tibble() %>% 
  rename(html = ".") %>% 
  mutate(id = row_number()) %>% 
  filter(id != 12) %>% 
  separate(html, sep = ":", into = c("column", "data"), extra = "merge") %>% 
  #mutate(data = str_replace(data, "\\\r|n", ""))
  select(-id) %>% 
  spread(column, data) -> battles


battles
?separate
