# NU.r 
NU is for not understood. A corpus frequency analysis script, for french, english and arabic text.

## About

```sh

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
 		Be careful, don't forget to write the command with the right order into the commandline.
      Arguments:
      	-p=	   	- URL or full path of the file to analyse, ie:./Nu.r -p=http://siteweb.tld/data.txt
		-typei=		- The type of input to analyse (ie : url, text, file)
      	-wd= 		- Configure the working directory (advised to let this argument by default if you do not want to change the script execution   directory) ie : -wd=/your/path/directory/
      	-pngfw= 	- Wordcloud png output filename, ie : -pngfw=wordcloud.png
      	-lng= 		- Set langage (ie : en, english, french, arabic etc...)
      	-minfreq= 	- Minimal word frequency (integer)
    	-maxword=	- The maximum value of words to show, as integer (default value :200)
	-numft=		- Enter the minimum result to show in the num frequency table
	-numfto= 	- Select the table frequency filename (ie=table.csv)
	-bcof= 		- Select the barchart output filename (ie=barchart.png)
	-bartitle= 	- Select the barchart title (ie: "Most frequent words ")
	-ylabel= 	- Select the barchart y label (ie: "Word frequencies ")
	-correlfilename - Enter the filename for the correlation output file (ie:correlterms.csv)
	-correlterm	- Enter the correlation term (ie: "fu bar")
	-correlrate	- Select the correlation rate (limit) , from -1 to 0.99
	-freqterme	- Select the minimal value of the term frequencies to extract (ie : 6) 
	-termfreqtxt	- Choose the output destination file where to store results of the frequency analysis (ie: termsfrequency.csv)
      	--help          - Show this help
 
      Example:
      -------
      Rscript NU.r -p=http://www.thealmightyguru.com/Music/Lyrics/Beauty%20and%20the%20Beast/Bonjour.txt --typei=url -correlfilename=correlterms.csv -correlterm="bonjour" -correlrate=0.1


```
## Install 
Firstly install packages on your linux machine.
```sh
apt-get install libcurl4-gnutls-dev libcurl4-openssl-dev libxml2-dev r-cran-slam

rstudio &
```
Once done, install the package on your rstudio build.
```sh
packages <- function(paquets){
    new.paquets <- paquets[!(paquets %in% installed.packages()[, "Package"])]
    if (length(new.paquets))
        install.packages(new.paquets, dependencies = TRUE, repos='http://cran.rstudio.com/')
    sapply(paquets, require, character.only = TRUE)
}

packages(c("wordcloud", "tm", "slam","ggplot2","jsonlite","SnowballC"))
```
If it is not working, load http://datascience.stackexchange.com/questions/13759/getting-error-in-rstudio-while-loading-a-package-tm.

# Licenses
* DWYDTBWI (do what you do the best with it)
* Copyright - 3 letters.

## Contact
Thibaut LOMBARD,
 **contact@thibautlombard.space** , 
 sincerely.
