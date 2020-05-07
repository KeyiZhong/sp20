source("test-data.R")
library("leaps")
truncated.power.design.matrix <- function(x) {
  result <- matrix(0,nrow=length(x),ncol=length(x))
  for (i in 1:length(x)) {
    for (j in 1:length(x)) {
      result[i,j] <- max(0,x[i]-x[j])
    }
  }
  for (j in 1:length(x)) {
    result[j,length(x)] <- 1
  }
  return(result)
}

regsubsets.fitted.values <- function(X, regsubsets.out, nterm) {
  out.summary <- summary(regsubsets.out)
  vorder <- regsubsets.out$vorder[1:nterm][order(regsubsets.out$vorder[1:nterm])]
  coeff <- coef(regsubsets.out,nterm)
  coefficient <- rep(0,100)
  for (i in 1:nterm) {
    coefficient[vorder[i]] <- coeff[i]
  }
  return(X%*%coefficient)
}

## 3
truncated <- truncated.power.design.matrix(x)
regsubsets.out <- regsubsets(truncated,y,method="forward",nvmax=100,intercept = FALSE)
out.summary <- summary(regsubsets.out)
res.sum <- rep(0,100)
for(k in 1:100) {
  fit.values <- regsubsets.fitted.values(truncated,regsubsets.out,k)
  res.sum[k] <- sum((y-fit.values)^2)
}
plot(res.sum,type='l')


## 4
GCV <- rep(0,100)
for(i in 1:100) {
  fit.values <- regsubsets.fitted.values(truncated,regsubsets.out,i)
  GCV[i] <- mean((y-fit.values)^2/(1-i/100)^2)
}
plot(GCV,type='l')

## 5
GCV <- rep(0,100)
for(i in 1:100) {
  fit.values <- regsubsets.fitted.values(truncated,regsubsets.out,i)
  GCV[i] <- mean((y-fit.values)^2/(1-3*i/100)^2)
}
plot(GCV,type='l')

## 6
k <- which(GCV==min(GCV[1:30]))
fit.values <- regsubsets.fitted.values(truncated,regsubsets.out,k)
plot(x,y)
lines(x,fit.values)

## 2.2
library('glmnet')
ridge.mod <- glmnet(truncated,y,alpha=0,lambda = c(0,1,10,1000000))
coeff <- coef(ridge.mod)
coeff[101,]=coeff[1,]
for (i in 1:4) {
  plot(x,y)
  lines(x,truncated%*%coeff[,i][2:101])
}


## 2.3
cv.out <- cv.glmnet(truncated,y,alpha=0)
plot(cv.out)
optlam <- cv.out$lambda.min
ridge.mod <- glmnet(truncated,y,alpha=0,lambda = optlam)
coeff <- coef(ridge.mod)
coeff[101,]=coeff[1,]
y_hat <- truncated%*%coeff[2:101]
plot(x,y)
lines(x,y_hat)
