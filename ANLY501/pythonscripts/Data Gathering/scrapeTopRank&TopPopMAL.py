from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"}
DF1=pd.DataFrame(columns=['Name','Rate','Link'],index=[])
DF2=pd.DataFrame(columns=['Name','Rate','Link'],index=[])
File1=open("First1000RatingAnime.txt","w",encoding='utf-8')
File2=open("First1000PopAnime.txt","w",encoding='utf-8')
playerwriter1 = csv.writer(File1, delimiter=',')
playerwriter2 = csv.writer(File2, delimiter=',')

rankurl="https://myanimelist.net/topanime.php?limit="
popurl="https://myanimelist.net/topanime.php?type=bypopularity&limit="

i=1
while(i<=20):
    limit=(i-1)*50
    rankpage=requests.get(rankurl+str(limit),headers=headers)
    soup=BeautifulSoup(rankpage.text,"html.parser")

    tempbody=soup.select("#content > div.pb12 > table")
    #print((tempbody[0].contents)[2].contents[5].div.span.text)
    #print((tempbody[0].contents)[2].contents[3].contents[3].contents[2].h3.a)

    for j in range(50):
        print((i-1)*50+j)
        rank = float((tempbody[0].contents)[2*(j+1)].contents[5].div.span.text)
        a=(tempbody[0].contents)[2*(j+1)].contents[3].contents[3].contents[2].h3.a
        name=a.text
        link=a.get('href')
        #print(name,rank,link)
        DF1.loc[(i - 1) * 50 + j] = [name, rank, link]
        playerwriter1.writerow([name,rank,link])

    i=i+1

i=1
while(i<=20):
    limit=(i-1)*50
    poppage=requests.get(popurl+str(limit),headers=headers)
    soup=BeautifulSoup(poppage.text,"html.parser")

    tempbody=soup.select("#content > div.pb12 > table")
    #print((tempbody[0].contents)[2].contents[5].div.span.text)
    #print((tempbody[0].contents)[2].contents[3].contents[3].contents[2].h3.a)

    for j in range(50):
        print((i - 1) * 50 + j)
        rank = (tempbody[0].contents)[2*(j+1)].contents[5].div.span.text
        a=(tempbody[0].contents)[2*(j+1)].contents[3].contents[3].contents[2].h3.a
        name=a.text
        link=a.get('href')
        #print(name,rank,link)
        DF2.loc[(i - 1) * 50 + j] = [name, rank, link]
        playerwriter2.writerow([name,rank,link])

    i=i+1
#rank = (tempbody[0].contents)[4]
#print(rank)