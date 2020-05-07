source('home1-part2-data.R')
squared.bias <- rep(0,200)
variance <- rep(0,200)
sds <- seq(0.01,2,by=0.01)
weights <- matrix(nrow = length(x.train),ncol=length(x.train))
for(i in 1:200) {
  for(j in 1:200) {
    gaussian_sum <- sum(dnorm(x.train[j]-x.train, 0, sds[i]))
    weight <- dnorm(x.train[j]-x.train, 0, sds[i])/gaussian_sum
    variance[i] <- variance[i] + sum(weight^2)
    weight[j] <- weight[j] - 1
    squared.bias[i] <- squared.bias[i] + abs(sum(weight*f))^2
  }
  squared.bias[i] <- (squared.bias[i])/200
  variance[i] <- noise.var*variance[i]/200
}
sums <- variance + squared.bias
plot(variance,type='l')
lines(squared.bias,col='red')
lines(sums,col='blue')

which(sums==min(sums))


sigma <- which(sums==min(sums))*0.01
fhat <- rep(0,200)
for(i in 1:200) {
  gaussian_sum <- sum(dnorm(x.train[i]-x.train, 0, sigma))
  yhat <- sum(y.train*dnorm(x.train[i]-x.train, 0, sigma))/gaussian_sum
  fhat[i] <- yhat
}
plot(x.train,y.train)
lines(x.train, f,col='blue')
lines(x.train,fhat,col='red')


legend("topleft",
       c("train","fhat", "f"),
       fill=c("black","red", "blue")
)