# load required packages
library(dplyr)
library(ggplot2)

# read datasets from disk into dataframes
pm <- readRDS("summarySCC_PM25.rds")
ssc <- readRDS("Source_Classification_Code.rds")

# wrap dataframes for dplyr
pm = tbl_df(pm)
ssc = tbl_df(ssc)

# use dplyr to filter, group and summarise emission data as total per year per source type for the city of Baltimore (fips == "24510")
pm.summary = pm %>% filter(fips == "24510") %>% group_by(year, type) %>% summarize(total_emissions = sum(Emissions))

# scatterplot matrix of the summarised data + regression lines to visualize linear trends
ggplot(pm.summary, aes(x = year, y = total_emissions)) +
  ggtitle("Total emissions (PM2.5) per year per source type (Baltimore, MD)") +
  ylab("total emissions (tons)") +
  facet_grid(. ~ type) +
  geom_point() +
  geom_smooth(method=lm) + 
  theme_bw()

# write plot to disk
dev.copy(png, file="plot3.png", width=1440, height=480)
dev.off()
