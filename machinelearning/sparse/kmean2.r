setwd(Sys.getenv("PWD"))
library(NLP)
library(tm)
library(NMF)
library(cluster)
library(factoextra)
library(NbClust)

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
inspect(dtm)
dtmss <- removeSparseTerms(dtm, 0.9)

# -------------------------------------------------------------------------
# Clustering hierarchique avec hclust
png(filename="kmean2-rect-hclust.png",width=800,height=600)
# Calcul de distance sur un espace Euclidien
distance <- dist(t(dtmss),method = "euclidean")
distance
# Utilise la method="complete" et non Ward.D
hc <- hclust(distance, method = "complete")
plot(hc, hang = -1)
# Ajoute des rectangles multicolores
rect.hclust(hc, k = 4, border = 2:4) 
dev.off()
# -------------------------------------------------------------------------

# Méthode elbow
# Inspirée de http://www.sthda.com/english/wiki/print.php?id=239
distance.scaled <- scale(distance)
k.max <- 4 # Maximal number of clusters
data <- distance.scaled
wss <- sapply(1:k.max, 
        function(k){kmeans(data, k, nstart=10 )$tot.withinss})
png(filename="kmean2-plot-clust.png",width=800,height=600)

plot(1:k.max, wss,
       type="b", pch = 19, frame = FALSE, 
       xlab="Nombre de clusters K",
       ylab="Total de la somme des cercles à l'intérieur du cluster")
abline(v = 3, lty =2)
dev.off()

# Méthode sihouette
#k.max <- 6
#data <- distance
#sil <- rep(0, k.max)

#for(i in 2:k.max){
#  km.res <- kmeans(data, centers = i, nstart = 25)
#  ss <- silhouette(km.res$cluster, dist(data))
#  sil[i] <- mean(ss[, 3])
#}
#png(filename="kmean2-fviz-nbclust-silhouette.png",width=800,height=600)
#fviz_nbclust(distance.scaled, kmeans, method = "silhouette")
#dev.off()

# Méthode nbclust
datatwo <-  dist(t(dtmss),method = "euclidean")
res <- NbClust(datatwo, distance = "euclidean",
                  min.nc = 2, max.nc = 10, 
                  method = "complete", index ="gap")
res 
# Créé la visualisation cluster
km <- kmeans(datatwo, 2, nstart = 25)
png(filename="kmean2-fviz-nbclust-optimal.png",width=800,height=600)
fviz_cluster(km, data = scale(t(dtmss)))
dev.off()
