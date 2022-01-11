library(deSolve)
library(ggplot2); theme_set(theme_classic())
library(tidyverse)
library(colorblindr) ## clauswilke/colorblindr on github

do_bifurc <- FALSE

bgSIR <- function(t,y,parms) {
  grad <- with(c(as.list(y),as.list(parms)),
               { beta <- (b0*(1+b1*cos(2*pi*t)/2));
                 c(mu*N-beta*exp(logI)*S/N-mu*S,
                   beta*S/N-(mu+gamma),
                   gamma*exp(logI)-mu*R) })
  list(grad,NULL)
}
## bgjac <- function(t,y,parms) {
##   jac <- with(c(as.list(y),as.list(parms)),
##                { beta <- (b0*(1+b1*cos(2*pi*t)/2))
##                  matrix(c(-beta*I/N-mu,-beta*S/N,0,
##                           beta*I/N,beta*S/N-(mu+gamma),0,
##                           0,gamma,-mu),byrow=TRUE,nrow=3)})
##   jac
## }

start1 <- c(S=0.99,logI=-4,R=0)
p1 <- c(b0=4,b1=0,gamma=1,mu=0.05,N=1)
d1 <- as.data.frame(lsoda(y=start1,
            times=seq(0,100,by=0.1),
            func=bgSIR,
            parms=p1))
p2 <- c(b0=12,b1=0,gamma=3,mu=0.05,N=1)
d2 <- as.data.frame(lsoda(y=start1,
        times=seq(0,100,by=0.1),
        func=bgSIR,
        parms=p2))

p3 <- c(b0=12,b1=0.4,gamma=3,mu=0.05,N=1)
d3 <- as.data.frame(lsoda(y=start1,
        times=seq(0,100,by=0.1),
        func=bgSIR,
        parms=p3))

p4 <- c(b0=36,b1=0.4,gamma=9,mu=0.05,N=1)
d4 <- as.data.frame(lsoda(y=start1,
        times=seq(0,100,by=0.1),
        func=bgSIR,
        parms=p4))

## measles!  R0 = 15, mu = 0.02,
##           gamma = 52,
##           [b0 =
p5 <- c(b0=15*52,b1=0,gamma=52,mu=0.02,N=1)
d5 <- as.data.frame(lsoda(y=start1,
        times=seq(0,100,by=0.1),
        func=bgSIR,
        parms=p5))

p6 <- c(b0=15*52,b1=0.1,gamma=52,mu=0.02,N=1)
start2 <- c(S=0.1,logI=-3,R=0.86)
d6 <- as.data.frame(lsoda(y=start2,
        times=seq(0,1000,by=0.1),
        func=bgSIR,
        parms=p6))

p7 <- c(b0=15*52,b1=0.3,gamma=52,mu=0.02,N=1)
d7 <- as.data.frame(lsoda(y=start2,
                          times=seq(0,1000,by=0.1),
                          func=bgSIR,
                          parms=p7))

tmpplot <- function(d,main="", lwr = NA) {
  d_long <- (d
    |> mutate(I = exp(logI))
    |> select(-logI)
    |> pivot_longer(-time, names_to = "compartment")
  )
  gg1 <- (ggplot(d_long, aes(time, value, colour = compartment))
    + geom_line()
    + scale_y_log10(limits = c(lwr, NA))
    + scale_color_OkabeIto()
  )
  gg2 <- (ggplot(d, aes(S, exp(logI))) +
          geom_path() +
          geom_point() +
          labs(x = "Susceptibles", y = "Infectives") +
          scale_y_log10()
  )
  cowplot::plot_grid(gg1, gg2, nrow=1)
}

if (do_bifurc) {
  bvec <- seq(0.01,0.3,by=0.01)
  res <- matrix(nrow=length(bvec),ncol=200)
  start0 <- start2
  for (i in 1:length(bvec)) {
    cat(i,bvec[i],"\n")
    dtmp <- as.data.frame(lsoda(y=start0,
                                times=seq(0,500,by=1),
                                func=bgSIR,
                                parms=c(b0=15*52,b1=bvec[i],
                                        gamma=52,mu=0.02,N=1)))
    res[i,] <- dtmp[302:501,"logI"]
    start0 <- unlist(dtmp[501,-1])
  }
  png("bifurc.png")
  matplot(bvec,res,pch=1,cex=0.5,type="p",col=1,
          xlab="amplitude of seasonality",ylab="seasonal I")
  dev.off()
}
