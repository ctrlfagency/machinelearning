setwd("/var/www/")
library(NLP)
library(ggplot2)
library(ggthemes)
library(tm)
library(SnowballC) 
library(RWeka) 
library(reshape)
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
c <- tm_map(c, removeWords, c("qui","que","quand","mon","dans","tout","une","pas","pour","mon","mais","des","est","jai"))

# Reorganise original file
c_orig <- c
c <- tm_map(c, stemDocument)
# Stemming
cm <- tm_map(c, stemCompletion, dictionary = c_orig)  
cm <- tm_map(c, content_transformer(PlainTextDocument))

# term document matrix
tdm <- TermDocumentMatrix(c, control = list(minWordLength = 1))

# sum rows
tf <- rowSums(as.matrix(tdm))
# select the +5 freq words
tf.5 <- subset(tf, tf>=5)
dfr <- data.frame(term = names(tf.5), freq = tf.5)

bf <- ggplot(dfr, aes(x = term, y = freq)) + geom_bar(stat = "identity",color="blue", fill="steelblue") +
ggtitle("les mots risqués") + xlab("Termes") + ylab("Fréquence") + coord_flip() + theme_few()
ggsave(plot=bf,filename="frequence.png",width=8.5,height=11)
