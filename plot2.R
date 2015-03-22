# load required packages
library(dplyr)

# read datasets from disk into dataframes
pm <- readRDS("summarySCC_PM25.rds")
ssc <- readRDS("Source_Classification_Code.rds")

# wrap dataframes for dplyr
pm = tbl_df(pm)
ssc = tbl_df(ssc)

# use dplyr to filter, group and summarise emission data as total per year for the city of Baltimore (fips == "24510")
pm.summary = pm %>% filter(fips == "24510") %>% group_by(year) %>% summarize(total_emissions = sum(Emissions))

# scatterplot of the summarised data + regression line to visualize linear trend
plot(total_emissions ~ year, pm.summary, ylab = "total emissions (tons)", main = "Total emissions (PM2.5) per year (Baltimore, MD)")
abline(lm(total_emissions ~ year, pm.summary))

# write plot to disk
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()
