# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~ BIOS 721 Topic 1 | Simulation Studies in R Part 1 ~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# -----------------------------------------------------------------

# How to Generate Data in a Simulation Study:

#Slide 6:
# Designed-based data generation
# - Suppose we wanted to randomly generate a sample of
#   size 10 from the integers 10 through 50 without
#   replacement.

set.seed(123)
sample(10:50, 10, replace=FALSE)
sample(7:77, 7, replace = TRUE)





#Slide 8:
# Model-based data generation
# - Suppose we wanted to randomly generate a sample of
#   size 10 from the standard normal distribution (i.e.
#   a normal distribution withe mean=1 and sd=1).

# Look up the help page of rnorm() function
?rnorm()


#Slide 9:
# Use the 'r-version' for the norm() function
# to randomly generate values form ANY normal distribution
set.seed(456)
rnorm(100,mean=0,sd=1)


















# Just as an FYI ...
# - Can use the 'd-version' of the norm() function to plot
#   ANY normal pdf
plot(x=seq(-3,3,0.001),y=dnorm(seq(-3,3,0.001)),
     type='l',lty=1,lwd=2,col='red',
     main='Standard Normal PDF',
     ylab='Density',xlab='Z-Values')


# - Can use the 'p-version' of the norm() function to ...
#   (1) plot ANY normal CDF
plot(x=seq(-3,3,0.001),y=pnorm(seq(-3,3,0.001)),
     type='l',lty=1,lwd=2,col='red',
     main='Standard Normal CDF',
     ylab='P(Z < z)',xlab='Z-Values')



#   (2) calculate probabilities for ANY normal distrib
pnorm(0)        # P(Z < 0)
pnorm(-2)       # P(Z < -2)
1-pnorm(1.5)    # P(Z > 1.5)



# - Can use the 'q-version' of the norm() function to
#   calculate quantiles of ANY normal distribution
qnorm(0.5)
qnorm(0.025)
qnorm(0.90)



# -----------------------------------------------------------------

# Example 1|
# When does the CLT kick in for Population ~ Chi-Sq(df=2)?

#Slide 16:
# - Assuming sample size is 5 (really small)
set.seed(55)
n <- 5
runs <- 10000
means <- rep(NA,runs)


for (i in 1:runs) {
  samp <- rchisq(n,df=2)
  means[i] <- mean(samp) }






plot(density(means),type='l',lwd=2,
     main='Empirical vs. Theoretical Sampling Distribution',
     xlab='Possible Sample Mean Values',
     ylab='Density')
lines(x=seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
      y=dnorm(seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
              mean=2,sd=2/sqrt(n)),
      lwd=2,col='red',lty=2)
legend('topright',c('Empirical PDF','Theoretical PDF'),
       col=c('black','red'),lwd=2,lty=1:2)
mtext('Assuming sample size is 5',line=0.25)





#Slide 21:
# - Assuming sample size is 10 (small)
set.seed(1010)
n <- 10
runs <- 10000
means <- rep(NA,runs)

for (i in 1:runs) {
  samp <- rchisq(n,df=2)
  means[i] <- mean(samp) }

plot(density(means),type='l',lwd=2,
     main='Empirical vs. Theoretical Sampling Distribution',
     xlab='Possible Sample Mean Values',
     ylab='Density')
lines(x=seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
      y=dnorm(seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
              mean=2,sd=2/sqrt(n)),
      lwd=2,col='red',lty=2)
legend('topright',c('Empirical PDF','Theoretical PDF'),
       col=c('black','red'),lwd=2,lty=1:2)
mtext('Assuming sample size is 10',line=0.25)







# - Assuming sample size is 25 (moderate)
set.seed(2525)
n <- 25
runs <- 10000
means <- rep(NA,runs)

for (i in 1:runs) {
  samp <- rchisq(n,df=2)
  means[i] <- mean(samp) }

plot(density(means),type='l',lwd=2,
     main='Empirical vs. Theoretical Sampling Distribution',
     xlab='Possible Sample Mean Values',
     ylab='Density')
lines(x=seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
      y=dnorm(seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
              mean=2,sd=2/sqrt(n)),
      lwd=2,col='red',lty=2)
legend('topright',c('Empirical PDF','Theoretical PDF'),
       col=c('black','red'),lwd=2,lty=1:2)
mtext('Assuming sample size is 25',line=0.25)




# - Assuming sample size is 50 (large)
set.seed(5050)
n <- 50
runs <- 10000
means <- rep(NA,runs)

for (i in 1:runs) {
  samp <- rchisq(n,df=2)
  means[i] <- mean(samp) }

plot(density(means),type='l',lwd=2,
     main='Empirical vs. Theoretical Sampling Distribution',
     xlab='Possible Sample Mean Values',
     ylab='Density')
lines(x=seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
      y=dnorm(seq(2-6/sqrt(n),2+6/sqrt(n),0.001),
              mean=2,sd=2/sqrt(n)),
      lwd=2,col='red',lty=2)
legend('topright',c('Empirical PDF','Theoretical PDF'),
       col=c('black','red'),lwd=2,lty=1:2)
mtext('Assuming sample size is 50',line=0.25)

# - Note: Could this simulation be done using vectorized
#         programming? If so, do for n = 50?

# -----------------------------------------------------------------

# Example 2 > You Try It!|
# - Use a simulation study based on 10000 runs to
#   estimate the probably of at least set of siblings
#   being paired together in the study assuming 15
#   sibling sets are recruited.

# -----------------------------------------------------------------

# Example 3 > You Try It!|
# - Use a simulation study based on 10000 runs to
#   estimate the probability of observing 10 tagged
#   animals if 25 animals are selected on the second
#   draw from a population of 100 animals where 35
#   randomly selected animals were tagged previously.

# -----------------------------------------------------------------
# End of Program
