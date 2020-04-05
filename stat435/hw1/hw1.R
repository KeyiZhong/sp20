source('home1-data.R')
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
        yhat <- sum(y[-i]*dnorm(x[i]-x[-i]))/gaussian_sum
      }else {
        gaussian_sum <- sum(dnorm(x[i]-x, 0, gaussian_sd))
        yhat <- sum(y*dnorm(x[i]-x))/gaussian_sum
      }
      yhat.train[i] <- yhat
    }
    return(list(x=x,y=yhat.train))
  }
}
ksmooth.train(Wage.train$age,Wage.train$wage,'normal',0.5,TRUE)
