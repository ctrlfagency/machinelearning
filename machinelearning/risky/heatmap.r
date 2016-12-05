library(NLP)
library(tm)
library(SnowballC) 
library(reshape)
library(ggplot2)
library(NMF)
library(RColorBrewer)
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
# remove custom stopwords
c <- tm_map(c, removeWords, c("qui","que","quand","mon","dans","tout","une","pas","pour","mon","mais","des","est","jai","aucun","aussi"))

# Reorganise original file for after
c_orig <- c
#c <- tm_map(c, stemDocument)
stemCompletion2 <- function(x, dictionary) {
x <- unlist(strsplit(as.character(x), " "))
# Unexpectedly, stemCompletion completes an empty string to
# a word in dictionary. Remove empty string to avoid above issue.
x <- x[x != ""]
x <- stemCompletion(x, dictionary=dictionary)
x <- paste(x, sep="", collapse=" ")
PlainTextDocument(stripWhitespace(x))
}
c <- lapply(c, stemCompletion2, dictionary=c_orig)
c <- Corpus(VectorSource(a)) 
#cm <- tm_map(c, content_transformer(PlainTextDocument))

# create term document matrix
tdm <- TermDocumentMatrix(c_orig, control = list(minWordLength = 1))
# remove the sparse terms (need to review before)
tdm.s <- removeSparseTerms(tdm, sparse=0.9)
m2 <- as.matrix(tdm.s)

# clustering
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method = "ward")
png(filename="clustering.png",width=800,height=600)
plot(fit)
rect.hclust(fit, k = 6)
dev.off()

# we'll need the TDM as a matrix
m <- as.matrix(tdm.s)
print('tdm : ')
head(m)
# convert matri to data frame
m.df <- data.frame(m)
print('m.df dataframe :')
head(m.df)

# make keywords
m.df$keywords <- rownames(m.df)
m.df.melted <- melt(m.df)

print('keywords : ')
head(m.df$keywords)

print('melted keywords')
m.df.melted <- melt(m.df)
head(m.df.melted)

print('columns label')
rt <- colnames(m.df.melted) <- c("Keyword","Post","Freq")
head(rt)
# Sort with scale = row or col or c1 etc..
# aheatmap(m,scale="row"...)
aheatmap(m,cellwidth = 10, cellheight = 8, fontsize = 8, filename = "heatmap-and-dendrogram.png",Rowv=NA)

