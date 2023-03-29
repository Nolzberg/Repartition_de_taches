# Repartition_de_taches

Un problème important en informatique est de répartir un grand nombre de tâches entre des processeurs parallèles de manière équitable, c’est-à-dire d’équilibrer leur charges. 

On se place dans un cadre où l'on dispose dans un premier temps de deux processeurs tournant en parallèle. Ainsi, chaque processeur aura des tâches à traiter et l'objectif est de les répartir équitablement entre ces deux derniers tout en minimisant la différence de charges. Nous allons étudier ce problème sur l’exemple d’un modèle élémentaire décrit ci-dessous.

Soient $X_1,\dots,X_N$ des variables aléatoires indépendantes, distribuées uniformément sur $[0, 1]$. La variable $X_k$ correspond au temps d’exécution de la k-ième tâche à effectuer par le processeur. Un partage de tâches sera représenté par une suite d’entiers $a_1,\dots,a_N$ à valeurs dans {-1,+1} tel que $a_k = 1$ si la tâche d’indice $k$ est affectée au processeur numéro 1 et $a_k = -1$ si elle est affectée au processeur numéro 2. La différence de charge entre les deux processeurs est alors donnée en valeur absolue par la quantité $|D_N|$ où :

```math
D_N = \sum_{k=1}^N a_k X_N 
```

On va alors mettre en place différents algorithmes de répartition de tâches sur deux, puis plusieurs processeurs :

- Répartition séquentielle : on ne connaît pas à l'avance le nombre de tâches à traiter, elles sont affectées au processeur au fur et à mesure de leur arrivée. On ne connaît donc que le temps nécessaire à la réalisation de la tâche qui arrive. On traite ici 2 méthodes :

  - Répartition au hasard
  - Répartition markovienne

- Répartition optimale : on connaît le nombre de tâches à effectuer et leurs temps de réalisations. On veut encore plus réduire la borne de la différence de charges.

- Répartition sur p processeurs : on ne se résout plus à seulement 2 processeurs mais on passe à p processeurs, avec p > 2.
