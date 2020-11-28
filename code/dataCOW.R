#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# War magnitude | population adjusted
# COW data
# Last update 2018 07 02
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
setwd("~/Dropbox/surrey/decline")
library(plyr)

# Load data
inter<-read.csv("data/Inter-StateWarData_v4.0.csv",stringsAsFactors=FALSE)
extra<-read.csv("data/Extra-StateWarData_v4.0.csv",stringsAsFactors=FALSE)
intra<-read.csv("data/Intra-StateWarData_v4.1.csv",stringsAsFactors=FALSE)
non<-read.csv("data/Non-StateWarData_v4.0.csv",stringsAsFactors=FALSE)

# For some reason R is being bit difficult with importing some csv-files;
# Changing numeric values to factors for no good reason. 
# Need to sort this out.
intra$A<-as.numeric(intra$SideADeaths) 

# Need to fix NAs
intra$SideADeaths[is.na(intra$A)]
intra$WarNum[is.na(intra$A)]
intra$A[is.na(intra$A) & intra$WarNum==516]<-1500
intra$A[is.na(intra$A) & intra$WarNum==682]<-2100
intra$A[is.na(intra$A) & intra$WarNum==856]<-10480

# Same spiel for side B
intra$B<-as.numeric(intra$SideBDeaths)
intra$SideBDeaths[is.na(intra$B)]
intra$WarNum[is.na(intra$B)]
intra$A[is.na(intra$A) & intra$WarNum==512]<-10000
intra$A[is.na(intra$A) & intra$WarNum==688]<-3000
intra$A[is.na(intra$A) & intra$WarNum==856]<-17681

# Set negative to NA
intra$A[intra$A<0]<-NA
intra$B[intra$B<0]<-NA

# Total battle deaths
intra$BatDeath<-rowSums(intra[,c("A", "B")], na.rm=TRUE)
intra<-intra[intra$BatDeath>0,] # N=257

# Calculate total battle deaths for non-state wars
# Also need to calculate total of battle deaths for non-state wars
non$SideADeaths[non$SideADeaths<0]<-NA
non$SideBDeaths[non$SideBDeaths<0]<-NA
non$BatDeath<-rowSums(non[,c("SideADeaths", "SideBDeaths")], na.rm=TRUE)
non<-non[non$BatDeath>0,] # N=26

non$StartYear1<-non$StartYear # Adjust start year variable

# Merge data
d<-rbind(inter[,c(1,2,3,9,24)],
         extra[,c(1,2,3,10,26)],
         intra[,c(1,2,3,11,31)],
         non[,c(1,2,3,26,27)])

d<-d[d$BatDeath>0,] # Exclude wars with no battle deaths (N=783)

# Aggregate data: total and per period
d<-ddply(d,.(WarNum,WarName),summarise,
         battle_deaths=sum(BatDeath),year=min(StartYear1)) # 474

# Indicator for interstate wars
d$interstate_war<-ifelse(d$WarNum %in% inter$WarNum,1,0)

# Rescale deaths
load('output/population.Rda')
d<-merge(d,pop,all.x=T)
d$battle_deaths.s<-d$battle_deaths/d$population*100000

# Save
save(d,file='output/cow.Rda')

## FIN