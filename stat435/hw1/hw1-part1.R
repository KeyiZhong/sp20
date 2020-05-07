source('home1-part1-data.R')
Wage.test <- Wage.test[order(Wage.test$age),]
Wage.train <- Wage.train[order(Wage.train$age),]
## A
ksmooth.train <- function(x.train, y.train, kernel = c("box", "normal"),bandwidth = 0.5, CV = FALSE){
  ord <- order(x.train)
  x <- x.train[ord]
  y <- y.train[ord]
  if(kernel == 'box') {
    yhat.train <- rep(0,length(x))
    for (i in 1:length(x)) {
      if(CV) {
        yhat <- mean(y[-i][abs(x[i]-x[-i])<=bandwidth])
      }else {
        yhat <- mean(y[abs(x[i]-x)<=bandwidth])
      }
      yhat.train[i] <- yhat
    }
    return(list(x=x,y=yhat.train))
  }else {
    yhat.train <- rep(0,length(x))
    gaussian_sd <- -bandwidth/4/qnorm(0.25)
    for (i in 1:length(x)) {
      if(CV) {
        gaussian_sum <- sum(dnorm(x[i]-x[-i], 0, gaussian_sd))
        yhat <- sum(y[-i]*dnorm(x[i]-x[-i], 0, gaussian_sd))/gaussian_sum
      }else {
        gaussian_sum <- sum(dnorm(x[i]-x, 0, gaussian_sd))
        yhat <- sum(y*dnorm(x[i]-x, 0, gaussian_sd))/gaussian_sum
      }
      yhat.train[i] <- yhat
    }
    return(list(x=x,y=yhat.train))
  }
}

## B
ksmooth.predict <- function(ksmooth.train.out, x.query) {
  x <- x.query[order(x.query)]
  y.predict <- approxfun(ksmooth.train.out,rule = 2)(x)
  return(y.predict)
}

## C
plot(Wage.train$age, Wage.train$wage)
trained <- ksmooth.train(Wage.train$age, Wage.train$wage,'normal',3)
x <- trained$x
y <- trained$y
lines(trained)
sum <- 0
for(i in 1:length(x)) {
  sum <- sum + (Wage.train$wage[order(Wage.train$age)][i]-y[i])^2
}
sum

## D
trained <- ksmooth.train(Wage.train$age, Wage.train$wage,'normal',3)
test.predict <- ksmooth.predict(trained, Wage.test$age)
plot(Wage.test$age,Wage.test$wage)
lines(Wage.test$age[order(Wage.test$age)] ,test.predict)
sum <- 0
for(i in 1:length(Wage.test$age)) {
  sum <- sum + (Wage.test$wage[order(Wage.test$age)][i]-test.predict[i])^2
}
sum

## E
ESE <- rep(0,10)
for(i in 1:10) {
  yhat <- ksmooth.train(Wage.train$age,Wage.train$wage,'normal',i)$y
  ESE[i] <- mean((Wage.train$wage[order(Wage.train$age)]-yhat)^2)
}
plot(ESE,type = 'b')


## F
ESE <- rep(0,10)
for(i in 1:10) {
  fhat <- ksmooth.predict(ksmooth.train(Wage.train$age,Wage.train$wage,'normal',i,TRUE), Wage.test$age)
  ESE[i] <- mean((Wage.train$wage[order(Wage.train$age)]-fhat)^2)
}
plot(ESE,type = 'b')


## G
ESE <- rep(0,10)
for(i in 1:10) {
  fhat <- ksmooth.predict(ksmooth.train(Wage.train$age,Wage.train$wage,'normal',i), Wage.test$age)
  ESE[i] <- mean((Wage.test$wage[order(Wage.test$age)]-fhat)^2)
}
plot(ESE,type = 'b')

## H
ESE <- rep(0,10)
for(i in 1:10) {
  RSS <- 0
  for(j in 1:5) {
    train.age <- Wage.train$age[fold != j]
    train.wage <- Wage.train$wage[fold != j]
    trained <- ksmooth.train(train.age, train.wage, 'normal', i)
    test.age <- Wage.train$age[fold == j]
    test.wage <- Wage.train$wage[fold == j]
    fhat <- ksmooth.predict(trained, test.age)
    RSS <- RSS + sum((test.wage[order(test.age)] - fhat)^2)
  }
  ESE[i] <- RSS / 5
}
plot(ESE,type = 'b')
