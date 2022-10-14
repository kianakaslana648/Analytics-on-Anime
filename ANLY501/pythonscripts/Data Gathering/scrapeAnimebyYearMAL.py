from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

def digit_only(s:str):
    r=''
    for i in range(len(s)):
        if (s[i]).isdigit():
            r = r + s[i]
    return r

seasons=['spring','summer','fall','winter']

headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"}

baseurl='https://myanimelist.net/anime/season/'

#i=2014
for i in range(2015,2022):
    print(i)
    File=open("AnimebyYear\\"+str(i)+".txt","w",encoding='utf-8')
    playerwriter = csv.writer(File, delimiter=',')
    for j in seasons:
        print(j)
        url=baseurl+str(i)+'/'+j
        rankpage=requests.get(url,headers=headers)
        soup=BeautifulSoup(rankpage.text,"html.parser")
        tempbody=soup.select("#content > div.js-categories-seasonal")
        tempassemblies=tempbody[0].find_all('div')
        for assembly in tempassemblies:
            tempdivs=assembly.find_all('div',class_="seasonal-anime js-seasonal-anime")
            #div=tempdivs[0]
            for div in tempdivs:
                a=div.div.div.h2.a
                link=a.get('href')
                name=a.text
                playerwriter.writerow([name,link])
File.close()