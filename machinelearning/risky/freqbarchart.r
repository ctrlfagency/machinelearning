setwd("/var/www/")
library(NLP)
library(ggplot2)
library(ggthemes)
library(tm)
library(SnowballC) 
library(reshape)
library(dplyr)

# Copyleft : Thibaut LOMBARD
# input the raw corpus raw text
a <- readLines("article.txt")

# convert raw text into a Corpus object
c <- Corpus(VectorSource(a))
# Convert the text to lower case
c <- tm_map(c, content_transformer(tolower))
c <- tm_map(c, content_transformer(PlainTextDocument))
# Remove numbers
c <- tm_map(c, content_transformer(removeNumbers))
# Remove punctuations
c <- tm_map(c, content_transformer(removePunctuation))
# Eliminate extra white spaces
c <- tm_map(c, content_transformer(stripWhitespace))
# remove common stopwords
c <- tm_map(c, removeWords, stopwords("french"))
# remove custom stopwords (I made this list after inspecting the corpus)
c <- tm_map(c, removeWords, c("qui","que","quand","mon","dans","tout","une","pas","pour","mon","mais","des","est","jai","car"))

# Reorganise original file
c_orig <- c
#c <- tm_map(c, stemDocument)
# Stemming
cm <- tm_map(c, stemCompletion, dictionary = c_orig)  
cm <- tm_map(c, content_transformer(PlainTextDocument))

# term document matrix
tdm <- TermDocumentMatrix(cm, control = list(minWordLength = 1))

# sum rows
tf <- rowSums(as.matrix(tdm))
# select the +5 freq words
print('tf.5')
tf.5 <- subset(tf, tf>=5)
head(tf.5)

dfr <- data.frame(term = names(tf.5), freq = tf.5)

#print('data frame freq sorted by asc order using dplyr ')
#dfrterm <- arrange(dfr, term)
#head(dfrterm)
#print('sort the term column contained into the data frame with order')
#dfrr <- dfr[order(dfr[,'term']), ]
#head(dfrr)

png(filename="frequence.png",width=850,height=1100)
ggplot(dfr, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
#ggsave(plot=bf,filename="frequence.png",width=8.5,height=11)
dev.off()

dfr$term <- factor(dfr$term, levels = dfr$term[order(dfr$freq)])
dfr$term  
png(filename="frequence-ordered-by-freq.png",width=850,height=1100)
ggplot(dfr, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
dev.off()

dfr$term <- factor(dfr$term, levels = dfr$term[rev(order(dfr$freq))])
dfr$term
png(filename="frequence-ordered-by-freq-asc.png",width=850,height=1100)
ggplot(dfr, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() + theme_few() 
dev.off()


png(filename="frequence-ordered-by-term-and-freq.png",width=850,height=1100)
ggplot(dfr, aes(x = reorder(term, -freq), y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") + ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() +  scale_y_reverse() + theme_few() 
dev.off()


png(filename="frequence-ordered-by-term.png",width=850,height=1100)
dfr2 <- within(dfr , term <- ordered(term, levels = rev(sort(unique(term))))) 
head(dfr2$term)
ggplot(dfr2, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") + ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + labs(y='term',x='freq') + coord_flip() +  scale_y_reverse() + theme_few() 
dev.off()

