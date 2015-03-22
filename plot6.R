# load required packages
library(dplyr)
library(ggplot2)

# read datasets from disk into dataframes
pm <- readRDS("summarySCC_PM25.rds")
ssc <- readRDS("Source_Classification_Code.rds")

# wrap dataframes for dplyr
pm = tbl_df(pm)
ssc = tbl_df(ssc)

# use dplyr to find motor vehicle sources
ssc.motor_vehicle = filter(ssc, grepl("Onroad", Data.Category))

# use dplyr to filter, group and summarise emission data as total per year  for the city of Baltimore (fips == "24510") or Los Angeles (fips == "06037") from motor vehicle sources
pm.summary = pm %>% filter((fips == "24510" | fips == "06037") & SCC %in% ssc.motor_vehicle$SCC) %>% group_by(year, fips) %>% summarize(total_emissions = sum(Emissions))

# scatterplot matrix of the summarised data + regression lines to visualize linear trends
ggplot(pm.summary, aes(x = year, y = total_emissions)) +
  ggtitle("Total emissions (PM2.5) per year per city (06037:Los Angeles, CA and 24510:Baltimore, MD)\nfrom motor vehicle sources") +
  ylab("total emissions (tons)") +
  facet_grid(. ~ fips) +
  geom_point() +
  geom_smooth(method=lm) + 
  theme_bw()

# write plot to disk
dev.copy(png, file="plot6.png", width=960, height=480)
dev.off()
