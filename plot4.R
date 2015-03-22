# load required packages
library(dplyr)

# read datasets from disk into dataframes
pm <- readRDS("summarySCC_PM25.rds")
ssc <- readRDS("Source_Classification_Code.rds")

# wrap dataframes for dplyr
pm = tbl_df(pm)
ssc = tbl_df(ssc)

# use dplyr to find coal combustion-related sources
ssc.coal_comb = filter(ssc, grepl("Coal", Short.Name) & grepl("Comb", Short.Name))

# use dplyr to filter, group and summarise emission data as total per year from coal combustion-related sources
pm.summary = pm %>% filter(SCC %in% ssc.coal_comb$SCC) %>% group_by(year) %>% summarize(total_emissions = sum(Emissions))

# scatterplot of the summarised data + regression line to visualize linear trend
plot(total_emissions ~ year, pm.summary, ylab = "total emissions (tons)", main = "Total emissions (PM2.5) per year (USA)\nfrom coal combustion-related sources")
abline(lm(total_emissions ~ year, pm.summary))

# write plot to disk
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
