setwd(Sys.getenv("PWD"))
library(NLP)
library(tm)
library(NMF)
library(cluster)
library(factoextra)

# --------------------------------------------------------------------------------------------------------------
# Ferme toute connections déjà existantes
closeAllConnections()
# On nettoie la liste des variables préalablement enregistrées
rm(list=ls())
# --------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------
# Prépare le ficher d'écriture des résultats dans un fichier log
fileresults <- file("resultats-kmean.log")
sink(fileresults, append=TRUE)
sink(fileresults, append=TRUE, type="message")
# --------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------
# Ajoutons un Pangramme
# info : https://fr.wikipedia.org/wiki/Pangramme
monTexte <- c("Bâchez la queue du wagon-taxi avec les pyjamas du fakir",
              "la matrice du wagon-taxi",
              "le fakir est dans la matrice",
              "le taxi fait le pyjamas sous la bâche",
              "le fakir est dans le wagon",
              "la matrice est conduit par le fakir",
              "vous êtes avec la matrice de pyjamas",
              "le wagon-taxi de pyjamas apprennent le machine learning")
x <- data.frame(monTexte)    

# Mets le tableau x en document term matrix
docs <- Corpus(DataframeSource(x))
dtm <- DocumentTermMatrix(docs)
print('**************************************************************')
print('Matrice dtm : inspection')
print('**************************************************************')
inspect(dtm)
# Parsimonie ...
dtmss <- removeSparseTerms(dtm, 0.9)

# Algorithme de clustering Kmean
# définit la distance dans un espace Euclidien
# set.seed(1234)
print('**************************************************************')
print('Distance Matrix')
print('**************************************************************')
# Fabrique la distance matrix
d <- dist(t(dtmss), method="euclidian") 
d  
print('**************************************************************')
print('Résultats de kmeans (fonction k-moyen)')
print('**************************************************************')
res <- kmeans(d, 2, nstart = 25)
res
png(filename="sparse-kmean.png",width=800,height=600)
fviz_cluster(res, data = d)
invisible(dev.off())
# -------------------------------------------------------------------------
# Calcul du nombre optimal de clusters
print('**************************************************************')
print('Calcul du nombre optimal de clusters')
print('**************************************************************')
set.seed(123)
re <- eclust(t(dtmss), "kmeans")
re
png(filename="sparse-kmean2.png",width=800,height=600)
fviz_gap_stat(re$gap_stat)
invisible(dev.off())
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Graphique silhouette
png(filename="sparse-kmean-silhouette.png",width=640,height=480)
fviz_silhouette(re)
invisible(dev.off())
# -------------------------------------------------------------------------

# On termine l'écriture des résultats dans le fichier resultats-sparse.log
sink() 
sink(type="message")



