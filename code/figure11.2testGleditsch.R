# Tail test Gleditsch data
# http://ksgleditsch.com/expwar.html
# last update 2019 04 06
setwd("~/github/replication-material/war-decline")
load('data/gleditsch.Rda') # N=574

# Plot: Adjusted data
#plot(d$year,d$battle_deaths.s,axes=F,xlab='',
#     ylab='Battle deaths per 100,000',log='y')
#axis(1,tick=F);axis(2,tick=F,line=-2)

bd<-1:5000/100 # Battle-deaths per 100,000
p.value<-list()
bp.year<-c(1945,1950)
p<-c()

# Test turning points
for(j in 1:length(bp.year)){
  print(j)
  y<-bp.year[j]
  
  # Subset based on break-point year
  w1<-nrow(d[d$year<=y,])
  w2<-nrow(d[d$year>y,])
  
  # Estimate
  for(i in 1:length(bd)){
    
    # Number of wars before and after
    r1<-nrow(d[d$battle_deaths.s>=bd[i] & d$year<=y,])
    r2<-nrow(d[d$battle_deaths.s>=bd[i] & d$year>y,])
    
    # Statistics
    p[i]<-sum(dbinom(0:r2, w2, r1/w1))
    
  }
  p.value[[j]]<-p
}


# Plot results
par(mar=c(5,5,2,2),mfrow=c(1,2),pty='s',las=1,cex.lab=2,cex.axis=2)


# Panel a: 1945
plot(bd,p.value[[1]],type='h',axes=F,xlab='Battle deaths per 100,000',ylab='',
     main='(a) p-value: 1945',ylim=c(0,1))
abline(h=.05,lty=2,col='white',lwd=3)
axis(1,tick=F);axis(2,tick=F,line=-1)

# Panel b: 1950
plot(bd,p.value[[2]],type='h',axes=F,xlab='Battle deaths per 100,000',ylab='',
     main='(b) p-value: 1950',ylim=c(0,1))
abline(h=.05,lty=2,col='white',lwd=3)
axis(1,tick=F);axis(2,tick=F,line=-1)

## FIN