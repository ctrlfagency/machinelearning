
setwd(Sys.getenv("PWD"))
library(NLP)
library(tm)
library(NMF)
library(proxy)


# -------------------------------------------------------------------------
# Ferme toute connections déjà existantes
closeAllConnections()
# On nettoie la liste des variables préalablement enregistrées
rm(list=ls())
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Prépare le ficher d'écriture des résultats dans un fichier log
fileresults <- file("resultats-sparse.log")
sink(fileresults, append=TRUE)
sink(fileresults, append=TRUE, type="message")
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Ajoutons un Pangramme
# info : https://fr.wikipedia.org/wiki/Pangramme
monTexte <- c("Bâchez la queue du wagon-taxi avec les pyjamas du fakir.",
              "la matrice du wagon-taxi",
              "le fakir est dans la matrice")
monCorpus <- Corpus(VectorSource(monTexte))
# -------------------------------------------------------------------------


# Affiche les résultats dans la console
print('*************************')
print('Les Matrices')
print('*************************')
print('                         ')

# ------------------------------------
# Créé la matrice term document
maTdm <- DocumentTermMatrix(monCorpus, control = list(minWordLength = 1))
# ------------------------------------

print('*************************************')
print('La matrice Term document maTdm')
print('*************************************')
maTdm

# ------------------------------------
# Parsimonie removeSparseTerms à 50%
c <- removeSparseTerms(maTdm, 0.5)
# ------------------------------------

print('*************************************')
print('parsimonie removeSparseTerms a  50%')
print('*************************************')
c

# ------------------------------------
# Parsimonie removeSparseTerms a  90%
d <- removeSparseTerms(maTdm, 0.9)
# ------------------------------------

print('*************************************')
print('parsimonie removeSparseTerms a  90%')
print('*************************************')
d

# ------------------------------------
# Pour info : maTdm est TOUJOURS une triplet-matrix
b <- as.matrix(maTdm)
# ------------------------------------

print('**************************************************************')
print('Inspection de la matrice Term document maTdm avec as.matrix()')
print('**************************************************************')
maTdm
b

# ------------------------------------
# transforme c en matrice ch pour visualisation avec aheatmap
ch <- as.matrix(removeSparseTerms(maTdm, 0.5))
# ------------------------------------

print('**************************************************************')
print('Inspection de la parsimonie removeSparseTerms a  50%')
print('**************************************************************')
inspect(c)

# ------------------------------------
# transforme d en matrice dh pour visualisation avec aheatmap
dh <- as.matrix(removeSparseTerms(maTdm, 0.9))
# ------------------------------------

print('**************************************************************')
print('Inspection de la parsimonie removeSparseTerms a  90%')
print('**************************************************************')
inspect(d)

# ------------------------------------
# Algorithme de clustering 
#-------------------------------------
print('**************************************************************')
print('Distance Matrix de b Cosine et Euclidienne')
print('**************************************************************')
cosineDistEisen <- function(x){
  as.dist(1 - x%*%t(x)/(sqrt(rowSums(x^2) %*% t(rowSums(x^2))))) 
}
print('**************************************************************')
print('Distance Matrix de b cosine correlation (Eisen et al., 1998)')
print('**************************************************************')
distance_cosinus <- cosineDistEisen(as.matrix(t(b)))
distance_cosinus

fitcos <- hclust(distance_cosinus)
png(filename="sparse-clust-cosinus.png",width=800,height=600)
plot(fitcos, main = "Distance Matrix (similarité) Cosinus", ylab = "Indice", hang = 0, col.main = "#21759B",col.lab = "#21759B",col.axis = "#21759B",sub = "")
rect.hclust(fitcos, k = 3,border="blue")
invisible(dev.off())  

print('**************************************************************')
print('Distance Matrix de b Euclidienne')
print('**************************************************************') 
distance_Euclidienne <- dist(as.matrix(t(b)), method = "Euclidean")
distance_Euclidienne
#distMatrix <- dist(scale(lamatrice))
fit <- hclust(distance_Euclidienne)
# /!\ Dans hclust "(matrice, method=" la méthode concerne l'agglomération et non la méthode appliquée sur la distance
png(filename="sparse-clust-euclidean.png",width=800,height=600)
plot(fit, main = "Distance Matrix (dissimilarité) Euclidienne", ylab = "Indice", hang = 0, col.main = "#21759B",col.lab = "#21759B",col.axis = "#21759B",sub = "")
rect.hclust(fit, k = 3,border="blue")
invisible(dev.off())
# ------------------------------------


# ------------------------------------
# Création des annotated Heatmap
aheatmap(b, filename = "sparse-heatmap-matrix.png", fontsize = 18,main = 'Sparse Matrix')
aheatmap(ch, filename = "sparse-heatmap-50percent.png",fontsize = 18, main = 'Sparse Matrix 50%')
aheatmap(dh, filename = "sparse-heatmap-99percent.png",fontsize = 18, main = 'Sparse Matrix 90%')
# ------------------------------------


# On termine l'écriture des résultats dans le fichier resultats-sparse.log
sink() 
sink(type="message")
