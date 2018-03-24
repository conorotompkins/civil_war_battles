library(tidyverse)
library(rvest)

#target websites
#https://www.nps.gov/abpp/battles/bystate.htm
#https://www.nps.gov/abpp/battles/al002.htm

#web scraping tutorial
#http://schd.ws/hosted_files/user2017/92/webscraping_with_rvest_and_purrr.pdf
#https://channel9.msdn.com/Events/useR-international-R-User-conferences/useR-International-R-User-2017-Conference/Scraping-data-with-rvest-and-purrr

#url <- "https://www.nps.gov/abpp/battles/bystate.htm"
#read_html(url) %>%
#  html_nodes("ul") %>%
#  html_nodes("li") %>%
#  html_text() %>% 
#  tibble() -> battles_basic

#write_csv(battles_basic, "data/battles_basic.csv")
battles_basic <- read_csv("data/battles_basic.csv")
battles_basic

battles_basic %>% 
  rename(state_link = ".") %>% 
  separate(state_link, sep = "\\(", into = c("battle", "link")) %>% 
  mutate(battle = str_replace(battle, "''", ""),
         link = str_replace(link, "\\)", "")) -> battles


battles

base_url <- "https://www.nps.gov/abpp/battles/"
battles %>% 
  mutate(link = str_c(base_url, link, ".htm")) -> battles_links
battles_links

battles_links[2,] %>% 
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
  spread(column, data)



get_battle <- function(url){
  read_html(url) %>% 
    html_nodes("p") %>% 
    html_text() %>% 
    tibble() %>% 
    rename(html = ".") %>% 
    mutate(id = row_number()) %>% 
    filter(id != 12) %>% 
    separate(html, sep = ":", into = c("column", "data"), extra = "merge") %>% 
    select(-id) %>% 
    spread(column, data) -> df
  return(df)
}

get_battle
test <- unlist(battles_links[1,2])
test
get_battle(url = test)

params <- battles_links[1:5,] %>% select(link)
params
battle_df <- pmap(params, get_battle) %>% bind_rows()

params %>% 
  map(get_battle)
