from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"}

File_output=open("1000RKInfoAnikore.txt","w",encoding='utf-8')
playerwriter = csv.writer(File_output, delimiter=',')

baseurl='https://www.anikore.jp/pop_ranking/page:'
i=2
#for i in range(1,41):
print(i)
url=baseurl+str(i)
rankpage=requests.get(url,headers=headers)
soup=BeautifulSoup(rankpage.content.decode('utf-8'),"html.parser")

tempbody=soup.select('#page-top > section.l-searchPageRanking > div > div.l-searchPageRanking_list')

print(soup)#.find_all('div',class_='l-searchPageRanking_unit'))
# for div in tempbody[0].find_all('div',class_='l-searchPageRanking_unit'):
#     link=div.h2.a.get('href')
#     name=div.h2.a.contents[5].text
#     score=div.h2.a.contents[1].text
#     ul=div.find('div',class_='l-searchPageRanking_unit_toggleWrap').contents[3].ul
#     tags=[]
#     for li in ul.find_all('li'):
#         tags.append(li.a.text)
#     playerwriter.writerow([name,score,tags,link])