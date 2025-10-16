#Parameters
mu = 67
sd = 3.5
n = 100

set.seed(10935)
#Simulate B samples, each of size n, from N(mu, sd^2)
height_samples = sapply(1:100, function(x)
  rnorm(n, mu, sd))

#Sample means across the B samples
sample_mean <- colMeans(height_samples)

hist(sample_mean, main = "Sampling Distribution of the Mean (n=100)",
     xlab = "Sample Mean")
mean(sample_mean)
sd(sample_mean)
sample_sd <- apply(height_samples,
                   2, sd)
sample_sd
sample_se <- apply(height_samples, 
                   2, function(x) sd(x)/sqrt(n))
sample_se
t_crit   <- qt(0.975, df = n - 1)
lower_ci <- sample_mean - t_crit*sample_se
upper_ci <- sample_mean + t_crit*sample_se

# coverage: does each CI contain the true mean?
covered <- (lower_ci <= mu) & (upper_ci >= mu)
coverage_percent <- mean(covered) * 100
coverage_percent

list(
  mean_of_sample_means_n100 = mean(sample_mean),
  sd_of_sample_means_n100   = sd(sample_mean),
  theoretical_sd_n100       = sd / sqrt(n),
  coverage_percent_n100     = coverage_percent
)


#parameters
mu <- 67
sd <- 3.5
n <- 50

set.seed(10345)
heights_sample <- sapply(1:100, function(x) rnorm(n, mu, sd) )


#caculate the mean
samples_mean <- colMeans(heights_sample)
hist(samples_mean, main = "Sample distribution of the Mean (n=50)", xlab = "Sample mean")
#It likes the normal distribution

mean(samples_mean)
sd(samples_mean)

sample_se <- apply(heights_sample, 2, function(x) sd(x)/sqrt(n))
t_crits <- qt(0.975, df = n-1)
t_crits
lower_ci <- samples_mean - t_crits*sample_se     
upper_ci <- samples_mean + t_crits*sample_se
covered <- (lower_ci <= mu) & (upper_ci >= mu)
covered
coverage_percent <- mean(covered) * 100
coverage_percent

list(
  mean_of_sample_means = mean(samples_mean),
  sd_of_sample_means   = sd(samples_mean),
  theoretical_sd       = sd / sqrt(n),
  coverage_percent     = coverage_percent
)