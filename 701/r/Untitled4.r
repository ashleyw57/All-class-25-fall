set.seed(10932)

z <- rnorm(100)          
q1 <- sum(z^2)          
q1
cat("Method 1 (sum of squared normals):", q1, "\n")

q2 <- rchisq(1, df=100)  
q2                     
cat("Method 2 (rchisq df=100):", q2, "\n")

N <- 10000

q1_sim <- replicate(N, sum(rnorm(100)^2))

q2_sim <- rchisq(N, df=100)

hist(q1_sim, breaks=50, col=rgb(1,0,0,0.5),
     main="Comparison: Method1 vs Method2 (Chi-square df=100)",
     xlab="Value", freq=FALSE)
hist(q2_sim, breaks=50, col=rgb(0,0,1,0.5), add=TRUE, freq=FALSE)

legend("topright", legend=c("Method1: sum(z^2)", "Method2: rchisq"),
       fill=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)))