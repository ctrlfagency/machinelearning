#!/usr/bin/Rscript
args <- commandArgs(TRUE)

## Default config while none args are assigned
if(length(args) < 1) {
  args <- c("-help")
}
 
## Help section
if("-help" %in% args) {
  cat("
#############################################################################
###                  NU.r WORD FREQUENCY ANALYSIS SCRIPT                  ###
#############################################################################
###         Thibaut LOMBARD. 3letters . August 2015 - 2017                ###
#############################################################################
### NU.R is for not understood,  is a commandline tool for generating     ###
### Frequency Analysis such as :                                          ###
### Wordcloud, graphs, tables & correllation, this script intends to throw###        
### the words, and strings related to a chosen URL or destination         ### 
### file. The languages available are French, English and Arabic.         ###
#############################################################################
###                     contact:contact@ctrlfagency.com                   ###
#############################################################################
    						  Frequency Analysis Script - Nu.r
 		Be careful, don\'t forget to write the command with the right order into the commandline.
      Arguments:
      	-p=	   	- URL or full path of the file to analyse, ie:./FAS.r -p=http://siteweb.tld/data.txt
		-typei=		- The type of input to analyse (ie : url, text, file)
      	-wd= 		- Configure the working directory (advised to let this argument by default if you do not want to change the script execution 				  directory) ie : -wd=/your/path/directory/
      	-pngfw= 	- Wordcloud png output filename, ie : -pngfw=wordcloud.png
      	-lng= 		- Set langage (ie : en, english, french, arabic etc...)
      	-minfreq= 	- Minimal word frequency (integer)
    	-maxword=	- The maximum value of words to show, as integer (default value :200)
	-numft=		- Enter the minimum result to show in the num frequency table
	-numfto= 	- Select the table frequency filename (ie=table.csv)
	-bcof= 		- Select the barchart output filename (ie=barchart.png)
	-bartitle= 	- Select the barchart title (ie: \"Most frequent words \")
	-ylabel= 	- Select the barchart y label (ie: \"Word frequencies \")
	-correlfilename - Enter the filename for the correlation output file (ie:correlterms.csv)
	-correlterm	- Enter the correlation term (ie: \"fu bar\")
	-correlrate	- Select the correlation rate (limit) , from -1 to 0.99
	-freqterme	- Select the minimal value of the term frequencies to extract (ie : 6) 
	-termfreqtxt	- Choose the output destination file where to store results of the frequency analysis (ie: termsfrequency.csv)
      	--help          - Show this help
 
      Example:
      -------
      Rscript NU.r -p=http://www.thealmightyguru.com/Music/Lyrics/Beauty%20and%20the%20Beast/Bonjour.txt --typei=url -correlfilename=correlterms.csv -correlterm=\"bonjour\" -correlrate=0.1


 \n\n")
 
  q(save="no")
}
 
## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) 
{
strsplit(sub("^-", "", x), "=")
}

argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1
{ 
## If p is invallid throw the error message : invalid args
  if(is.null(argsL$p)) {
	stop('-p= invalid args')
	dev.off()
#close all opened task
	closeAllConnections()
	rm(list=ls())
	}	else	{
	print("your file path : ")
	print(toString(argsL$p))
	FilePath <- toString(argsL$p)
		}
  if(is.null(argsL$typei)){
	print("The default value for type input is file.. ")
	typei <- "file"
	print(typei)
	}	else	{
	print("You have set the input type to :  ")
	typei <- toString(argsL$typei)
	print(typei)
		}
  if(is.null(argsL$wd)){
	print("Set working directory to current directory.. to change it, add wd=/your/path/directory/ to the commandline argument")
	print(Sys.getenv("PWD"))
	setwd(Sys.getenv("PWD"))
	}	else	{
	wd <- toString(argsL$wd)
	setwd(wd)
		}

  if(is.null(argsL$pngfw)){
	print("Set png wordcloud filename to default filename...")
	png("wordcloud.png")
	}	else	{
	pngfw <- toString(argsL$pngfw)
	print("Set png wordcloud filename to :")
	print(toString(pngfw))
	png(pngfw)
		}

  if(is.null(argsL$lng)){
	print("By default langage is set to english.. ")
	lng <- "en"
	print(lng)
	}	else	{
	print("your selected langage is: ")
	lng <- toString(argsL$lng)
		}

  if(is.null(argsL$minfreq)){
	print("The minimal word frequency is set by default to  2.. ")
	minfreq <- 2
	print(minfreq)
	}	else	{
	print("You have set up the minimal word's frequency to: ")
	minfreq <- as.integer(argsL$minfreq)
		}

  if(is.null(argsL$maxword)){
	print("The maximal word frequency is set by default to  200.. ")
	maxword <- 200
	print(maxword)
	}	else	{
	print("You have set up the maximal word's frequency to: ")
	maxword <- as.integer(argsL$maxword)
		}

  if(is.null(argsL$numft)){
	print("The default value for the num frequency table is set to  10.. ")
	numft <- 10
	print(numft)
	}	else	{
	print("You have set up the num frequency table to: ")
	numft <- as.integer(argsL$numft)
		}

  if(is.null(argsL$numfto)){
	print("The default value for the num frequency table filename output destination is.. ")
	numfto <- "tableoutput.csv"
	print(numfto)
	}	else	{
	print("You have set up the num frequency table 's output filename to: ")
	numft <- toString(argsL$numfto)
		}

  if(is.null(argsL$bcof)){
	print("The default value for the barchart output filename is.. ")
	bcof <- "barchart.png"
	print(bcof)
	}	else	{
	print("You have set up the barchart output filename to: ")
	bcof <- toString(argsL$bcof)
		}

   if(is.null(argsL$bartitle)){
	print("The default value for the barchart title.. ")
	bartitle <- "Most frequent words"
	print(bartitle)
	}	else	{
	print("You have set up the barchart title to: ")
	bartitle <- toString(argsL$bartitle)
		}

  if(is.null(argsL$ylabel)){
	print("The default value for the barchart y axis label.. ")
	ylabel <- "Word frequency"
	print(ylabel)
	}	else	{
	print("You have set up the barchart y axis label to: ")
	ylabel <- toString(argsL$ylabel)
		}

  if(is.null(argsL$freqterme)){
	print("The default minimal value of the terms frequency iterations is set to 6.. ")
	freqterme <- 6
	}	else	{
	print("The minimal terms frequency iteration : ")
	freqterme <- as.integer(argsL$freqterme)
		}

  if(is.null(argsL$termfreqtxt)){
	print("The default value for the filename  that contains term fequency is set to termsfrequency.txt.. ")
	termfreqtxt <- file("termsfrequency.csv")
	}	 else	{
	print("The terms frequency filename: ")
	termfreqtxt <- file(toString(argsL$termfreqtxt))
		}

#set the correlation term
  if(is.null(argsL$correlterm)){
	print("No correlation terms chosen, please choose one !")
	correlterm<-'unavailable'
	}	else	{
	print("The correllation term is : ")
	correlterm <- toString(argsL$correlterm)
	print(correlterm)
		}

#set the correlation filename
  if(is.null(argsL$correlfilename)){
	print("No correlation filename chosen, please choose one !")
	correlfilename <- file("correlterms.csv")
	}	else	{
	correlfilename <- toString(argsL$correlfilename)
	print("the correlation filename is set to :")
	print(correlfilename)
		}

#set the correlation rate
  if(is.null(argsL$correlrate)){
	print("No correlation rate (limit) chosen, please choose one, default is set to 0.5 ")
	correlrate <- 0.5
	}	else	{
	correlrate <- as.numeric(argsL$correlrate)
	print("the correlation rate (limit) is set to :")
	print(correlrate)
		}

	}

rquery.wordcloud <- function(x, type=c("text", "url", "file"), 
                          lang=c("english", "french", "arabic"), excludeWords=NULL, 
                          textStemming=FALSE,  colorPalette="Dark2",
                          min.freq=minfreq, max.words=maxword)
{ 
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")
  library("jsonlite")


  if(type[1]=="file") text <- readLines(x)
  else if(type[1]=="url") text <- html_to_text(x)
  else if(type[1]=="text") text <- x
  
  # Load the text as a corpus
  docs <- Corpus(VectorSource(enc2utf8(text)))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove stopwords for the language 
  docs <- tm_map(docs, removeWords, stopwords(lang))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove your own stopwords
  if(!is.null(excludeWords)) 
    docs <- tm_map(docs, removeWords, excludeWords) 
  # Text stemming
  if(textStemming) docs <- tm_map(docs, stemDocument)
  # Create term-document matrix
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  # Find terms following a constant
datafreqterme <- findFreqTerms(tdm, lowfreq = freqterme)
write.table(datafreqterme, file=termfreqtxt,quote=F,sep=";")
print(datafreqterme)
#if isset(var) equiv
if(is.atomic(correlterm)) {
print("Correlation")
lassoc <- findAssocs(tdm, terms = correlterm, corlimit = correlrate)
write.table(lassoc, file=correlfilename,quote=F,sep=";")
JSONcorreltable <- toJSON(lassoc, pretty=TRUE)
write(JSONcorreltable, file="JSONcorreltable.json")
print(lassoc)
}
  # check the color palette name 
  if(!colorPalette %in% rownames(brewer.pal.info)) colors = colorPalette
  else colors = brewer.pal(8, colorPalette) 
  # Plot the word cloud

  set.seed(1234)
  invisible(wordcloud(d$word,d$freq, min.freq=min.freq, max.words=max.words,
            random.order=FALSE, rot.per=0.35, 
            use.r.layout=FALSE, colors=colors))

  invisible(list(tdm=tdm, freqTable = d))

}

#++++++++++++++++++++++
# Helper function
#++++++++++++++++++++++
# Download and parse webpage
html_to_text<-function(url){
  library(RCurl)
  library(XML)
  # download html
  #add user-agent string in order to bypass robot detection system
  html.doc <- getURL(url)  
  #convert to plain text
  doc = htmlParse(html.doc, asText=TRUE)
 # "//text()" returns all text outside of HTML tags.
 # We also don’t want text such as style and script codes
  text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
  # Format text vector into one character string
  return(paste(text, collapse = " "))
}


#exec rquery function and output it to a png
res<-rquery.wordcloud(FilePath, type = typei, lang = lng, min.freq =minfreq,  max.words = maxword)
#close wordcloud session
dev.off()
#Load freq table
freqTable <- res$freqTable
#retreive n results
h=head(freqTable,numft)
#prepare the output file
fichier <- file(numfto)
headjson <- toJSON(h, pretty=TRUE)
write(headjson, file="JSONfreqtable.json")
#write the data into a table
write.table(h, file=fichier,quote=F,sep=";")
#prepare the barchart 
png(bcof)
#create the invisible barplot graph function
 invisible(barplot(freqTable[1:10,]$freq, las = 2, 
        names.arg = freqTable[1:10,]$word,
        col ="lightblue", main =bartitle,
        ylab = ylabel))
#close session and write into outfiles.

dev.off()
closeAllConnections()
rm(list=ls())



