from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"}

File=open("First1000RatingAnimeBangumi.txt","w",encoding='utf-8')
playerwriter = csv.writer(File, delimiter=',')

baseurl='https://bangumi.tv/anime/browser?sort=rank&page='

#i=1
for i in range(1,51):
    print(i)
    url=baseurl+str(i)
    #print(url)
    rankpage=requests.get(url,headers=headers)
    soup=BeautifulSoup(rankpage.content.decode('utf-8'),"html.parser")

    tempbody=soup.select("#browserItemList")
    #anim=tempbody[0].contents[0]
    for anim in tempbody[0].contents:
        playerwriter.writerow([anim.div.h3.a.text,anim.div.h3.a.get('href')])