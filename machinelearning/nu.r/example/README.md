# Example in Arabic
This is a small example from the speech of cheikh Abu Khaled Ahmed El Habti regarding his wishes for friday to the community.
 
## Selected Configuration
* typei  : type of input (filename)
* nuage_de_mots.png (pngfw) and graphique_discour.png (bcop) barchart and wordcloud filename.
* selected frequency discour_frequence_txt.txt
* terms for correlation chosen : doctor(PhD) in arabic
* correlation rate : 0.5 (max 1)
* csv file for saving correlation 'correlations.csv'
```
Rscript NU.r -p=discour.txt -typei=file  -pngfw=nuage_de_mots.png --minfreq=6 -freqterme=4 -bcof=graphique_discour.png -bartitle=discour_cheikh_Ahmed_Abu_Khaled_El_Habti_25_11_2016 -ylabel=quantite_de_mots --termfreqtxt=discour_frequence_txt.txt -correlrate=0.5 -correlterm="الدكتوراه" -correlfilename=correlations.csv

```

## Special Thanks
My hearthy greetings to cheikh Abu Khaled Ahmed El Habti.
Peacefully.

## Contact
Thibaut LOMBARD,
 **contact@thibautlombard.space** , 
 sincerely.
