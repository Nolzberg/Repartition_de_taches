## Projet Modele Proba ##

#install.packages('ggplot2')
library(ggplot2)
#install.packages('gridExtra')
library(gridExtra)
#install.packages('latex2exp')
library(latex2exp)

## Variables ----

N = 100
Nrep = 100

## Fonctions ----

Approche_hasard = function(N){
  proba_a = runif(N)
  X = runif(N)
  a = rep(NA, N)
  for(i in 1:N){
    if(proba_a[i]<=0.5){
      a[i] = 1
    }else{a[i] = -1}
  }
  D = sum(a*X)
  return(D)
}

Approche_markovienne = function(N){
  X = runif(N)
  a = rep(0, N)
  if(runif(1)<=0.5){
    a[1] = 1
  }else{a[1] = -1}
  for(i in 2:N){
    D = sum(a*X)
    if(D > 0){
      a[i] = -1
    }else{a[i] = 1}
  }
  return(sum(a*X))
}

Repartition_parfaite = function(N){
  X = runif(N)
  Y = sort(X,decreasing = T)
  delta = rep(NA,N)
  b = rep(0,N)
  b[1] = 1
  for(i in 2:N){
    delta[i-1] = sum(b*Y)
    if(delta[i-1] > 0){
      b[i] = -1
    }else{b[i] = 1}
  }
  for(j in (N-1):1){
    if(b[j] == 1){
      s = j
      break()
    }
  }
  delta[N]=sum(b*Y)
  return(list("D" = sum(b*Y),"Ys" = Y[s],'Y' = Y,'X' = X,'b' = b,'s'=s,'delta' = delta))
}

Approche_multiple = function(N,n_proc){
  X = runif(N)
  a = rep(0, N)
  D = rep(NA, n_proc)
  for(i in 1:n_proc){
    a[i] = i
    D[i] = X[i]
  }
  for(j in n_proc:N){
    m = which.min(D)
    a[j] = m
    D[m] = D[m] + X[j]
  }
  return(list('D'= D, 'a'= a, 'X' = X))
}

## Test d'une seule répartition au hasard variable en fonction du nombre de tâches ----

N = 100
X = runif(N)
a = rep(0, N)
if(runif(1)<=0.5){
  a[1] = 1
}else{a[1] = -1}
for(i in 2:N){
  D = sum(a*X)
  if(D > 0){
    a[i] = -1
  }else{a[i] = 1}
}
D = sum(a*X)
a[a==-1] = 2
a= factor(a)
df = data.frame('Indice' = 1:N, a, X)

par(mfrow=c(1,2))
plot1 = ggplot(data = df, aes(x = a, y = X, fill = 1:100)) + geom_col() + 
  labs(title = 'Répartition markovienne (N=100)',fill = 'Indice') +
  xlab('Processeur') + ylab('Temps de réalisation') + scale_fill_gradientn(colours=rainbow(4))

N = 1000
X = runif(N)
a = rep(0, N)
if(runif(1)<=0.5){
  a[1] = 1
}else{a[1] = -1}
for(i in 2:N){
  D = sum(a*X)
  if(D > 0){
    a[i] = -1
  }else{a[i] = 1}
}
D = sum(a*X)
a[a==-1] = 2
a= factor(a)
df = data.frame('Indice' = 1:N, a, X)

plot2 = ggplot(data = df, aes(x = a, y = X, fill = 1:N)) + geom_col() + 
  labs(title = 'Répartition markovienne (N=1000)',fill = 'Indice') +
  xlab('Processeur') + ylab('Temps de réalisation') + scale_fill_gradientn(colours=rainbow(4))

grid.arrange(plot1, plot2, ncol=2)

plot(0,1,xlim = c(-2,2),ylim=c(0,1))
curve((-(x-1))/2,xlim=c(0,2),add = T)
curve(((x+1))/2,xlim = c(-2,0),add=T)

## Tests des différentes méthodes ----

# Hasard

par(mfrow = c(1,1))
Dn = rep(NA, Nrep)
for(j in 1:Nrep){
  Dn[j] = Approche_hasard(N)
}
hist(abs(Dn)/sqrt(N),freq = F,main = TeX(r'(Distribution de $\frac{D_N}{\sqrt{N}}$)'),ylab = 'Probabilité',xlab = TeX(r'($\frac{D_N}{\sqrt{N}}$)'))
curve(2*dnorm(x,mean=0,sd=1/sqrt(3)),add = T)
shapiro.test(Dn)

# Markov

Dn_markov = rep(NA, Nrep)
for(j in 1:Nrep){
  Dn_markov[j] = Approche_markovienne(N)
}
hist(Dn_markov,freq = F,breaks = 20,ylim = c(0,1.1), main = TeX(r'(Distribution de $D_N)'), xlab = TeX(r'($D_N$)'),ylab = 'Densité')
curve(1-abs(x),add = T)
shapiro.test(Dn_markov)

# Parfaite

P = rep(NA,Nrep)
Dn_parfaite = rep(NA,Nrep)
Ys = 0
N_valide = 0
epsilon = 0.08
for (k in 1:Nrep){
  test = Repartition_parfaite(N)
  Dn_parfaite[k] = abs(test$D)
  Ys = test$Ys
  y = test$Y
  x = test$X

  if ((sum((epsilon/2 <= x) & (x <= epsilon))) >= (floor((2/epsilon)+1))){
    P[k] = (Ys <= epsilon)
    N_valide = N_valide +1
  }else{P[k] = FALSE}
}
sum(P)
hist(Dn_parfaite,freq = F,xlab = 'Différence de charge',ylab = 'Densité',main = 'Histogramme de la différence de charge')

# Cas où l'inégalité n'est pas respectée

N = 1000

Dn_parfaite = 0
Y_p = 1
while(Dn_parfaite<=Y_p){
  repa = Repartition_parfaite(N)
  Dn_parfaite = abs(repa$D)
  Y_p = repa$Ys
  print(Dn_parfaite<=Y_p)
}
b = repa$b
Y = repa$Y
delta = repa$delta

plot(1:N,delta,xlim = c((N-5),N),ylim=c(-0.003,0.003),xlab = 'Itérés',ylab = 'Différence de charge',main = 'Evolution de la différence de charge en fonction des itérés')
abline(h=0)
b[(N-5):N]
Y[(N-5):N]

## Approche sur plusieurs processeurs

N = 100
nb_processeurs = 5

test = Approche_multiple(N,nb_processeurs)
D = test$D
a = test$a
X = test$X

df2 = data.frame('Indice' = 1:N,a, X)

ggplot(data = df2, aes(x = a, y = X, fill = 1:N)) + geom_col() + 
  labs(title = 'Répartition sur 5 processeurs (N=100)',fill = 'Indice') +
  xlab('Processeur') + ylab('Temps de réalisation') + scale_fill_gradientn(colours=rainbow(4))
