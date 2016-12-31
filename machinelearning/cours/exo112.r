aexo112 <- function(x){
  (-1/2)*x+3 
}
sequence <- seq(from=-5, to=20, by=0.5)
p <-aexo112(sequence)
exp(p)
png(filename="exo-112-fonction.png",width=800,height=600)
plot(exp(p), type='l', xlab = "Centimetres", ylab = "variation", main = "f(x)=(-1/2)*x+3 ") 
lines(aexo112(sequence))
invisible(dev.off())

library("ggplot2")
exo112 <-function(x){(-1/2)*x+3 }
png(filename="exo-112-d.png",width=800,height=600)
ggplot(data.frame(x=c(1, 50)), aes(x=x)) + stat_function(fun=exo112, geom="line") + xlab("x") + ylab("y")
invisible(dev.off())
