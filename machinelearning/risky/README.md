# Risky Words
This is a small proof of concept for generating data visualisation from a corpus, (with barcharts, and heatmaps).
 
## Installation
```sh
sudo apt-get install r-cran-rjava
```
Install depedencies here : 
```
packages <- function(paquets){
    new.paquets <- paquets[!(paquets %in% installed.packages()[, "Package"])]
    if (length(new.paquets))
        install.packages(new.paquets, dependencies = TRUE, repos='http://cran.rstudio.com/')
    sapply(paquets, require, character.only = TRUE)
}
packages(c("ggplot2", "ggthemes", "tm", "RWeka","reshape","SnowballC"))
```
## Usage
In order to create an heatmap : 
```
Rscript risky.r

```
For making the barchart : 
```
Rscript freqbarchart.r 
```

## Contact
Thibaut LOMBARD,
 **contact@thibautlombard.space** , 
 sincerely.
