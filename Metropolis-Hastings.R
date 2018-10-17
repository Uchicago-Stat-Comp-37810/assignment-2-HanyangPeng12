trueA <- 5 #set the beta1 of the model
trueB <- 0 #set the beta0 of the model
trueSd <- 10 #set the standard variance of the model
sampleSize <- 31 #set the sample size of the model

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2) #create x values
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd) 
#create y-values, and include some noise

plot(x,y, main="Test Data") # show the plot of x and y

likelihood <- function(param){ #set the likelihood function for the model that we want to fit
  a = param[1] #set value of a(slope)
  b = param[2] #set value of b(intercept)
  sd = param[3] #set value of sd(standard variance)
  #parameters(a,b,sd) as input, the linear model is y=b+a*x+N(0,sd)
  
  pred = a*x + b #compute the predicted value
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T) 
  #we want to return the probability of obtaining the test data above under this model
  #we can calculate the difference between predictions y=b+a*x and the observed y
  #dnorm can give us the probability densities for such deviations to occur
  sumll = sum(singlelikelihoods) #to calculate the sum of the likelihood
  return(sumll)   #return the value we want
}

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))} 
#set a function to calculate the likelihood by using different slope a
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
#imput different a and put all the results in slopelikelihoods
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")
#plot the likelihood profile of the slope a

# Prior distribution
prior <- function(param){ #Now we define the prior distribution of the model
  a = param[1] #set the value of slope a
  b = param[2] #set the value of intercept b
  sd = param[3] #set the value of standard variance
  aprior = dunif(a, min=0, max=10, log = T) #use uniform distributions to set the prior distribution for parameter a
  bprior = dnorm(b, sd = 5, log = T)#use normal distributions to set the prior distribution for parameter b
  sdprior = dunif(sd, min=0, max=30, log = T)#use uniform distributions to set the prior distribution for parameter sd
  return(aprior+bprior+sdprior) #return the results
}

posterior <- function(param){ #The product of prior and likelihood is the actual quantity the MCMC will be working on
  return (likelihood(param) + prior(param))
}

######## Metropolis algorithm ################

proposalfunction <- function(param){  
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3))) 
  #set the function to compute the proposal value for the model
}

run_metropolis_MCMC <- function(startvalue, iterations){ #set the main function of the Metropolis algorithm
  chain = array(dim = c(iterations+1,3)) #set the variable chain
  chain[1,] = startvalue #set the first value of chain
  for (i in 1:iterations){ #a loop
    proposal = proposalfunction(chain[i,]) #compute the proposal value for each iteration
    
    probab = exp(posterior(proposal) - posterior(chain[i,])) 
    #compute the exp of difference of the posterior value of proposal and chain[i,]
    if (runif(1) < probab){
      chain[i+1,] = proposal 
      #generate a uniform distribution u, if u<probab, then we set chain[i+1,]=proposal
    }else{
      chain[i+1,] = chain[i,]
      #otherwise we set chain[i+1,]=chain[i,], which showed in the algorithm
    }
  }
  return(chain) #return the results
}

startvalue = c(4,0,10) #set the start value
chain = run_metropolis_MCMC(startvalue, 10000) #compute the model with start value and iteration=10000

burnIn = 5000 # set the butnin number, we accept the value only after it
acceptance = 1-mean(duplicated(chain[-(1:burnIn),])) #computhe the acceptance of the results

### Summary: #######################

par(mfrow = c(2,3)) #set the structure of the plot
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
#plot the hist picture of posterior of parameter a, where the red line is true value of a
abline(v = mean(chain[-(1:burnIn),1])) #add the line of the mean value of chain[-(1:burnIn),1]
abline(v = trueA, col="red" ) #add the red line of true value
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
#plot the hist picture of posterior of parameter b, where the red line is true value of b
abline(v = mean(chain[-(1:burnIn),2])) #add the line of the mean value of chain[-(1:burnIn),2]
abline(v = trueB, col="red" ) #add the red line of true value
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
#plot the hist picture of posterior of parameter sd, where the red line is true value of sd
abline(v = mean(chain[-(1:burnIn),3]) ) #add the line of the mean value of chain[-(1:burnIn),3]
abline(v = trueSd, col="red" ) #add the red line of true value
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
#plot the chain values of a
abline(h = trueA, col="red" ) #add the red line of true value
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
#plot the chain values of b
abline(h = trueB, col="red" ) #add the red line of true value
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
#plot the chain values of sd
abline(h = trueSd, col="red" ) #add the red line of true value

# for comparison:
summary(lm(y~x)) #summury the model of lm() and compare the results with our Metropolis-Hastings algorithm

