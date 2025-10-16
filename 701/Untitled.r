n = 100
p = 0.3
x = rbinom(n, 1, p)
x
xbar = mean(x )
xbar
x = rbinom(n, 1, p)
mean(x)

?replicate
dat = replicate(1000, rbinom(n, 1, p))
str(dat)
colMeans(dat)
hist(colMeans(dat))
mean(colMeans(dat))
p
