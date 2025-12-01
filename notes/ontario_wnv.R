## Sources: https://www.publichealthontario.ca/en/diseases-and-conditions/infectious-diseases/vector-borne-zoonotic-diseases/west-nile-virus
## Giordano, Bryan V., Sukhdeep Kaur, and Fiona F. Hunter. “West Nile Virus in Ontario, Canada: A Twelve-Year Analysis of Human Case Prevalence, Mosquito Surveillance, and Climate Data.” PLOS ONE 12, no. 8 (2017): e0183568. https://doi.org/10.1371/journal.pone.0183568.


## Public Health Ontario Vector-Borne Disease Tool
##   [PHO WNV Data Portal](https://www.publichealthontario.ca/en/data-and-analysis/infectious-disease/west-nile-virus)  
## Ontario Equine Data
## - [OMAFRA WNV & Horses](https://www.ontario.ca/page/west-nile-virus-and-horses)  
## - [OAHN Equine Disease Alerts](https://www.oahn.ca/resources/ontario-equine-disease-alerts/)
## Canada-wide Annual Reports
##  https://health-infobase.canada.ca/zoonoses/mosquito/annual-report.html


library(tidyverse); theme_set(theme_bw())
library(directlabels)
library(colorspace)
dd <- read_csv("ontario_wnv_data.csv") |>
  pivot_longer(-Year) |>
  mutate(across(name, ~forcats::fct_inorder(factor(.))))
ggplot(dd, aes(Year, value, colour = name, label = name)) +
  geom_line() + geom_point() +
  scale_y_log10() +
  scale_colour_discrete_qualitative(name = "type")
## + geom_dl(method = "last.points")

ggsave("ontario_wnv.png", height = 4, width = 6)
