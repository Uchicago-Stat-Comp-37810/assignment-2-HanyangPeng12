# STAT 37810 Assignment 2
# Author: Hanyang Peng

trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

source('function.R')
compare_outcomes<-function(iteration){
  burnIn=0.5*iteration #set the burnIn value, which we choose values only after burnIn
  for(i in 1:10){ #every loop
    startvalue=c(runif(1)*10,runif(1)*5,runif(1)*20) #set the random startvalue
    chain=run_metropolis_MCMC(startvalue,iteration) #compute the chain
    a=chain[-(1:burnIn),1] #get a from the chain
    abar=mean(a) #compute the mean of a
    astd=sqrt(sum((a-abar)^2)/length(a)) #compute the std of a
    print(abar) #print mean of a
    print(astd) #print std of a
  }
}

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")

# Example: plot the likelihood profile of the slope a
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")

# Prior distribution
######## Metropolis algorithm ################

compare_outcomes(1000)
compare_outcomes(10000)
compare_outcomes(100000)

#startvalue = c(4,0,10)
#chain = run_metropolis_MCMC(startvalue, 10000)

#burnIn = 5000
#acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################
plotfunc(chain,burnIn,trueA,trueB,trueSd)
#par(mfrow = c(2,3))
#hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
#abline(v = mean(chain[-(1:burnIn),1]))
#abline(v = trueA, col="red" )
#hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
#abline(v = mean(chain[-(1:burnIn),2]))
#abline(v = trueB, col="red" )
#hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
#abline(v = mean(chain[-(1:burnIn),3]) )
#abline(v = trueSd, col="red" )
#plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
#abline(h = trueA, col="red" )
#plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
#abline(h = trueB, col="red" )
#plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
#abline(h = trueSd, col="red" )

# for comparison:
summary(lm(y~x))

