setwd(Sys.getenv("PWD"))
library(NLP)
library(ggplot2)
library(ggthemes)
library(tm)
library(dplyr)

# Ajoutons un Pangramme
# info : https://fr.wikipedia.org/wiki/Pangramme
monTexte <- c("Bâchez la queue du wagon-taxi avec les pyjamas du fakir.",
              "la matrice du wagon-taxi",
              "le fakir est dans la matrice",
              "le taxi fait le pyjamas sous la bâche",
              "le fakir est dans le wagon",
              "le sparse est conduit par le fakir",
              "vous êtes avec la matrice de pyjamas",
              "le wagon-taxi de pyjamas apprennent le machine learning")
monCorpus <- Corpus(VectorSource(monTexte))
tdm <- TermDocumentMatrix(monCorpus, control = list(minWordLength = 1))

# La somme des lignes en tant que matrices
tf <- rowSums(as.matrix(tdm))
# Sélectionne les 2 fréquences 
print('tf.2')
tf.2 <- subset(tf, tf>=2)
tf.2

# Créé un tableau avec comme nom de colonne term et freq
d <- data.frame(term = names(tf.2), freq = tf.2)
d

png(filename="frequence.png",width=640,height=480)
ggplot(d, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("Mots avec Fréquence +2") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
dev.off()

d$term <- factor(d$term, levels = d$term[order(d$freq)])
d$term  
png(filename="frequence-ordered-by-freq.png",width=640,height=480)
ggplot(d, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("Mots avec Fréquence +2") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
dev.off()

d$term <- factor(d$term, levels = d$term[rev(order(d$freq))])
d$term
png(filename="frequence-ordered-by-freq-asc.png",width=640,height=480)
ggplot(d, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("Mots avec Fréquence +2") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
dev.off()

png(filename="frequence-ordered-by-term-and-freq.png",width=640,height=480)
ggplot(d, aes(x = reorder(term, -freq), y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") + ggtitle("Mots avec Fréquence +2") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() +  scale_y_reverse() + theme_few() 
dev.off()

png(filename="frequence-ordered-by-term.png",width=640,height=480)
d2 <- within(d , term <- ordered(term, levels = rev(sort(unique(term))))) 
head(d2$term)
ggplot(d2, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") + ggtitle("Mots avec Fréquence +2") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() +  scale_y_reverse() + theme_few() 
dev.off()

