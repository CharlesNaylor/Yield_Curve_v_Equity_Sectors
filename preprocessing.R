# Data-wrangling script
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tidyquant))

# Fetch or load in Data
if(!("sector_returns.rds.gz" %in% dir())) {
  download.file("http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/49_Industry_Portfolios_daily_CSV.zip",
                destfile="raw_returns.csv.zip") #You can plug an URL to a zip file directly into read_csv, but I was getting inconsistent results
  read_csv("raw_returns.csv.zip", skip=9, n_max=24286,
           col_types = cols(X1=col_date("%Y%m%d"))) %>% # the CSV contains 2 sets of data, one for value-weighted and one for equal-weighted. We're using only the first set, but to keep things clean, `n_max` is the best way to specify that.
    rename(Date=X1) %>%
    filter(Date>=ymd(19620102)) %>%
    gather(sector,avg_return,-Date) %>%
    mutate(avg_return= replace(avg_return, which(avg_return<=-99.99), NA) / 100) ->
    sector_returns
  write_rds(sector_returns, "sector_returns.rds.gz", compress="gz")
} else {
  sector_returns <- read_rds("sector_returns.rds.gz")
}

if(!("yc.csv" %in% dir())) {
  FRED_CODES <- list(`1MO`=1/12, `3MO`=3/12, `6MO`=6/12,
                     `1`=1,`2`=2,`5`=5,`7`=7,`10`=10,
                     `20`=20,`30`=30)
  tq_get(paste0("DGS",names(FRED_CODES)), get="economic.data", 
         complete.cases=F, from="1962-01-02") %>%
    mutate(is_mo=grepl("MO",symbol),
           duration=as.numeric(gsub("DGS([0-9]+)(MO)?", 
                                    "\\1",symbol)), 
           duration=ifelse(is_mo, duration/12, duration),
           value=price/100) %>%
    select(-is_mo, -symbol) %>%
    drop_na() ->
    yc
  write_csv(yc, "yc.csv")
} else {
  yc <- read_csv("yc.csv")
}