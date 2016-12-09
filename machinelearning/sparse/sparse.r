setwd(Sys.getenv("PWD"))
library(NLP)
library(tm)
library(NMF)


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
# Algorithme de clustering Ward D
# définit la distance dans un espace Euclidien
distMatrix <- dist(t(d), method="euclidian")
print('**************************************************************')
print('Distance Matrix de b')
print('**************************************************************')
distMatrix   
#distMatrix <- dist(scale(lamatrice))
fit <- hclust(distMatrix, method = "ward.D")
png(filename="sparse-clust.png",width=800,height=600)
plot(fit)
rect.hclust(fit, k = 3,border="blue")
invisible(dev.off())
# ------------------------------------


# ------------------------------------
# Création des annotated Heatmap
aheatmap(b, filename = "sparse-heatmap-matrix.png")
aheatmap(ch, filename = "sparse-heatmap-50percent.png")
aheatmap(dh, filename = "sparse-heatmap-99percent.png")
# ------------------------------------


# On termine l'écriture des résultats dans le fichier resultats-sparse.log
sink() 
sink(type="message")
