# Figure largest wars
# last update 2019 04 06
setwd('~/github/replication-material/war-decline')
par(mar=c(5,15,2,5),las=1,bty='n',cex.lab=2,cex.axis=2,cex.main=2)

# Libraries
library(plyr)
library(devtools)

load('data/gleditsch.Rda') #data

# Minor adjustment to year
colnames(d)[1]<-'syear'
d[d$syear==d$eyear,]$eyear=d[d$syear==d$eyear,]$eyear+0.1

# Subet wars with more than 10 deaths per 100,000
d<-d[order(-d$battle_deaths.s),]
f<-d[1:25,]
f<-f[order(f$battle_deaths.s),]
war<-unique(f$warname)

# Plot figure
plot(f$syear,factor(f$warname),axes=FALSE,xlab="",ylab="",type="n",
     xlim=c(1816,2015))

rect(1945,1,2025,nrow(f),col="grey90",lwd=0) # Rectangle
abline(h=1:nrow(f),lty=2,lwd=.5,col="dimgrey") # Lines

# Axis
axis(2,at=1:nrow(f),labels=factor(f$warname),tick=F,cex.axis=.8)
axis(1,las=1,at=seq(1815,2015,10),tick=F)
axis(4,at=1:nrow(f),labels=round(f$battle_deaths.s),tick=F,cex.axis=.8)

# Add lines
for(i in 1:nrow(f)){
  start = f[i,]$syear
  end   = f[i,]$eyear
  idx   = match(f[i,]$warname,war)
  #my_col = my_colors[ df[i,]$decade ]
  
  segments(start, idx, end, idx, lwd=5, lend=2,col="grey30")
  print(c(as.character(f[i,]$warname), idx))
  print(c(start,i,end,i))
}

rug(f$syear,side=1,line=0.8,ticksize=.02,lwd=.5)

## FIN