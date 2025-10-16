set.seed(123)

lambdas <- c(10, 50, 100)
sample_sizes <- c(10, 100)
num_sim <- 10000

for (lambda in lambdas) {
  for (n in sample_sizes) {
    
  
  sp <- replicate(num_sim, mean(rpois(n, lambda)))  # sample means
  
  # Normal approximation: N(mu=lambda, sigma^2=lambda/n)
  sn <- rnorm(num_sim, mean=lambda, sd=sqrt(lambda/n))
  
#plot
plot(density(sp), type='l', lwd=2,
     main=paste('Poisson vs. Normal with lambda=', lambda, " & n=", n, sep=""),
     xlab='Simulated Values', ylab='Density')
lines(density(sn), type='l', lwd=2, col=2)
  
legend('topright', c('Poisson','Normal'),
       col=c('black','red'), lwd=2)
  }
}



