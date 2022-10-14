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

headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"}
File=pd.read_csv('First1000RatingAnimeBangumi.txt',encoding='utf-8',names=['Name','Link'])
df=pd.DataFrame(File)

File_output=open("1000RKInfoBangumi.txt","a",encoding='utf-8')
playerwriter = csv.writer(File_output, delimiter=',')

#i=40
for i in range(863,df.shape[0]):
    print(i)
    baselink='https://bangumi.tv'
    templink=df.loc[i,'Link']
    link=baselink+templink
    rankpage=requests.get(link,headers=headers)
    #print(rankpage.content.decode('utf-8'))
    soup=BeautifulSoup(rankpage.content.decode('utf-8'),"html.parser")
    tempbody=(soup.select("#subject_detail > div.subject_tag_section > div")[0]).find_all('a')
    tempscore=(soup.select('#panelInterestWrapper > div > div > div > div > span')[0].text)
    templist=[]
    for a in tempbody:
        templist.append(a.span.text)
    #print(tempscore)
    playerwriter.writerow([df.loc[i,'Name'],tempscore,df.loc[i,'Link'],templist])