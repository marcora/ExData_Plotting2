# load required packages
library(dplyr)

# read datasets from disk into dataframes
pm <- readRDS("summarySCC_PM25.rds")
ssc <- readRDS("Source_Classification_Code.rds")

# wrap dataframes for dplyr
pm = tbl_df(pm)
ssc = tbl_df(ssc)

# use dplyr to find motor vehicle sources
ssc.motor_vehicle = filter(ssc, grepl("Onroad", Data.Category))

# use dplyr to filter, group and summarise emission data as total per year for the city of Baltimore (fips == "24510") from motor vehicle sources
pm.summary = pm %>% filter(fips == "24510" & SCC %in% ssc.motor_vehicle$SCC) %>% group_by(year) %>% summarize(total_emissions = sum(Emissions))

# scatterplot of the summarised data + regression line to visualize linear trend
plot(total_emissions ~ year, pm.summary, ylab = "total emissions (tons)", main = "Total emissions (PM2.5) per year (Baltimore, MD)\nfrom motor vehicle sources")
abline(lm(total_emissions ~ year, pm.summary))

# write plot to disk
dev.copy(png, file="plot5.png", width=480, height=480)
dev.off()
