#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# War magnitude | population adjusted
# Gleditsch data
# Last update: 2018 06 28
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
setwd("~/Dropbox/submitted/war")

# Libraries
library(plyr)

# Aggregate war data
d1<-read.csv('data/exp_iwpart.asc',stringsAsFactors=FALSE,sep='\t')
d2<-read.csv('data/exp_cwpart.asc',stringsAsFactors=FALSE,sep='\t')

# Merge data
d<-rbind(d1[,c(1,2,5,7,10)],
         d2[,c(1,2,5,6,13)])

# Add variable for start and end year
d$sdate<-format(as.Date(d$sdate1),"%Y-%m-%d")
d$syear<-lubridate::year(d$sdate)

d$edate<-format(as.Date(d$edate1),"%Y-%m-%d")
d$eyear<-lubridate::year(d$edate)

# Add variable for interstate wars
d$interstate_war<-ifelse(d$warid %in% d1$warid,1,0)

# Aggregate data
# NB - There are 3 coding errors in 'warid'; use 'warname' instead
d<-ddply(d,.(warname,interstate_war),summarise,
         battle_deaths=sum(deaths,na.rm=TRUE),year=min(syear),eyear=max(eyear))
d<-d[d$battle_deaths>0,] # N=574

# Calculate battle deaths per 100,000
load('output/population.Rda')
d<-merge(d,pop,all.x=TRUE)
d$battle_deaths.s<-d$battle_deaths/d$population*100000


# Save data
save(d,file='output/gleditsch.Rda')

## FIN