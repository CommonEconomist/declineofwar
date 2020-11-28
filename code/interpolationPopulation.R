#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# Population interpolation
# Sources;
# https://www.clio-infra.eu/Indicators/TotalPopulation.html
# http://themasites.pbl.nl/tridion/en/themasites/hyde/basicdrivingfactors/population/index-2.html
# Last update 2018 06 08
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# Libraries
library(plyr)
library(zoo)

# 1) Load data and move to dataframe
# Clio Infra data (in thousands)
ci<-read.csv('data/CLIOINFRA_population_thousands.csv')
ci<-ddply(ci,.(year),summarise,ci=sum(value)*1000)

# HYDE data (in millions)
h<-read.csv('data/HYDE_population_millions.csv')
h$hyde<-h$population*1e6
h$population<-NULL

# UN data
un<-read.csv('data/WPP2017_TotalPopulationBySex.csv')
un<-ddply(un[un$Variant=='Medium' & un$Location=='World',],
         .(Time),summarise, un=sum(PopTotal,na.rm=TRUE)*1000)
colnames(un)[1]<-'year'

# Move to data frame
d<-data.frame(year=1800:2100)
d<-merge(d,ci,all.x=TRUE)
d<-merge(d,h,all.x=TRUE)
d<-merge(d,un,all.x=TRUE)

# 2) Interpolate data

# Clio Infra
y<-ts(d$ci,start=1800)
z<-zoo(y)
z.a<-na.approx(z)
d2<-data.frame(year=1800:(1799+length(z.a)),
               ci.a=z.a)
d<-merge(d,d2,all.x=T)

# Hyde
y<-ts(d$hyde,start=1800)
z<-zoo(y)
z.a<-na.approx(z)
d2<-data.frame(year=1800:(1799+length(z.a)),
               hyde.a=z.a)
d<-merge(d,d2,all.x=T)

# UN
y<-ts(d$un,start=1800)
z<-zoo(y)
z.a<-na.approx(z)
d2<-data.frame(year=1950:(1949+length(z.a)),
               un.a=z.a)
d<-merge(d,d2,all.x=T)

d$population<-rowMeans(d[,c('ci.a','hyde.a','un.a')],na.rm=T)

pop<-d[,c('year','population')]

# 3) Plot data
#par(mar=c(5,5,2,2),las=1,bty='n',cex.lab=2,cex.axis=2,cex.main=2)
#plot(d$year,d$population,log='y',type='l',lwd=2,
#     axes=F,xlab='',ylab='',main='Population')
#lines(d$year,d$un,type='p',pch=1,cex=1.2)
#lines(d$year,d$ci,type='p',pch=4,cex=1.2)
#lines(d$year,d$hyde,type='p',pch=4,cex=1.2)
#axis(1,tick=F)
#axis(2,tick=F,line=-1,at=c(1e9,2e9,5e9,1e10),label=c('10^8','20^8','50^8','10^9'))


# Save
save(pop,file='output/population.Rda')

## FIN