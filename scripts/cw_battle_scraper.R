library(tidyverse)
library(rvest)

url <- "https://www.nps.gov/abpp/battles/bystate.htm"
read_html(url) %>%
  html_nodes("ul") %>%
  html_nodes("li") %>%
  html_text() %>% 
  tibble() -> states


#read_html(url) %>%
#  html_nodes("ul") %>%
#  html_nodes("li") %>% 
#  html_attr("href")
  
states

states %>% 
  rename(state_link = ".") %>% 
  separate(state_link, sep = "\\(", into = c("battle", "link")) %>% 
  mutate(battle = str_replace(battle, "\"", ""),
         link = str_replace(link, "\\)", "")) -> states


states

base_url <- "https://www.nps.gov/abpp/battles/"
states %>% 
  mutate(link = str_c(base_url, link, ".htm"))


unlist(states$battle)


url <- "https://www.hsx.com/security/view/ADRIV"
movie <- read_html(url) %>%
  html_nodes(".credit a") %>%
  html_text()
movie
