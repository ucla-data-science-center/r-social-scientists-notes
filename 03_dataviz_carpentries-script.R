dir.create("data")
dir.create("data_output")
dir.create("fig_output")

download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb")

library(tidyverse)
library(here)

interviews <- read_csv(here("data", "SAFI_clean.csv"), na = "NULL")

View(interviews)

#Starting point
interviews_plotting <- interviews %>%
  ## pivot wider by items_owned
  separate_rows(items_owned, sep = ";") %>%
  ## if there were no items listed, changing NA to no_listed_items
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
  pivot_wider(names_from = items_owned,
              values_from = items_owned_logical,
              values_fill = list(items_owned_logical = FALSE)) %>%
  ## pivot wider by months_lack_food
  separate_rows(months_lack_food, sep = ";") %>%
  mutate(months_lack_food_logical = TRUE) %>%
  pivot_wider(names_from = months_lack_food,
              values_from = months_lack_food_logical,
              values_fill = list(months_lack_food_logical = FALSE)) %>%
  ## add some summary columns
  mutate(number_months_lack_food = rowSums(select(., Jan:May))) %>%
  mutate(number_items = rowSums(select(., bicycle:car)))


View(interviews_plotting)

library(tidyverse)

interviews_plotting %>% 
  ggplot(aes(x = no_membrs, y = number_items, color = village)) + 
  geom_count()

interviews_plotting %>% 
  ggplot(aes(x = no_membrs, y = number_items)) + 
  geom_jitter(aes(color = village) +
              alpha = 0.5,
              width = 0.2,
              height = 0.2) 

interviews_plotting %>% 
  ggplot(aes(x = no_membrs, y = number_items, color = village)) +
  geom_count()

interviews_plotting %>% 
  ggplot(aes(x = village, y = rooms)) +
  geom_jitter(aes(color = respondent_wall_type),
              alpha = 0.5,
              width = 0.2,
              height = 0.2
              )

interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type, y = rooms)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.5,
              color = "red",
              width = 0.2,
              height = 0.2)

interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village), position = "dodge") +
  labs(title = "Count of Wall Type by Village",
       x = "Wall Type Count",
       y = "Wall Type")


percent_wall_type <- interviews_plotting %>% 
  filter(respondent_wall_type != "cement") %>% 
  count(village, respondent_wall_type) %>% 
  group_by(village) %>% 
  mutate(percent = (n / sum(n)) * 100) %>% 
  ungroup

percent_wall_type %>% 
  ggplot(aes(x = respondent_wall_type, y = percent, fill = respondent_wall_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "My plot title goes here") +
  facet_wrap(~ village) + 
  theme_bw() +
  theme(panel.grid = element_blank())


percent_items <- interviews_plotting %>% 
  group_by(village) %>%
  summarize(across(bicycle:no_listed_items, ~ sum(.x) / n() * 100)) %>% 
  pivot_longer(bicycle:no_listed_items, names_to = "items", values_to = "percent")




percent_items %>%
  ggplot(aes(x = village, y = percent)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ items) +
  theme_bw() +
  theme(panel.grid = element_blank())


library(plotly)


ggplotly(interviews_plotting %>% 
  ggplot(aes(x = no_membrs, y = number_items, color = village)) +
  geom_count())

interviews_plotting %>% 
  write_csv("data/interviews_plotting.csv")


