setwd("/var/www/")
library(NLP)
library(ggplot2)
library(ggthemes)
library(tm)
library(SnowballC) 
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
# remove custom stopwords
c <- tm_map(c, removeWords, c("qui","que","quand","mon","dans","tout","une","pas","pour","mon","mais","des","est","jai"))

# Reorganise original file for after
c_orig <- c
c <- tm_map(c, stemDocument)
# stemming
cm <- tm_map(c, stemCompletion, dictionary = c_orig)  
cm <- tm_map(c, content_transformer(PlainTextDocument))

# create term document matrix
tdm <- TermDocumentMatrix(c, control = list(minWordLength = 1))

# remove the sparse terms (need to review before)
tdm.s <- removeSparseTerms(tdm, sparse=0.9)

# we'll need the TDM as a matrix
m <- as.matrix(tdm.s)

# convert matri to data frame
m.df <- data.frame(m)

# make keywords
m.df$keywords <- rownames(m.df)

# takes data in wide format and stacks a set of columns
m.df.melted <- melt(m.df)

# Column names (facultative)
colnames(m.df.melted) <- c("Keyword","Post","Freq")

# generate the heatmap
hm = ggplot(m.df.melted, aes(x=Post, y=Keyword)) + 
  geom_tile(aes(fill=Freq), colour="white") + 
  scale_fill_gradient(low="black", high="steelblue") + 
  labs(title="Les mots risqués : article « Laissé pour mort à l’Everest » en 1996, l’Américain Beck Weathers a réappris à vivre") + 
  theme_few() +
  theme(axis.text.x  = element_text(size=6))
ggsave(plot=hm,filename="matrice-mots-risques.png",width=11,height=8.5)
