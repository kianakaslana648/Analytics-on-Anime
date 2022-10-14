from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

def digit_only(s:str):
    r=''
    for i in range(len(s)):
        if (s[i]).isdigit():
            r = r + s[i]
    return int(r)

File1=pd.read_csv("1000RKInfo.txt",encoding='utf-8',names=['Name','Link','Type','Episodes','Status','Aired','Premiered','Broadcast',\
                                                    'Producers','Licensors','Studios','Source','Genres','Duration','Rating',\
                                                    'Score','Users','Ranked','Popularity','Members','Favorites'])
df1=pd.DataFrame(File1)

File2=pd.read_csv("First1000RatingAnime.txt",encoding='utf-8',names=['Name','Score','Link'])
df2=pd.DataFrame(File2)

#File3=open("1000RKInfo_cleaned.txt","w",encoding='utf-8')
#playerwriter = csv.writer(File3, delimiter=',')

df1_cleaned=df1.drop(columns=['Link','Episodes','Status','Broadcast','Producers','Licensors','Studios','Duration','Score'])
df1_cleaned.insert(1,'Score',df2['Score'])

templist1=[]
templist2=[]
templist3=[]
templist4=[]
for i in range(1000):
    templist1.append(digit_only(df1_cleaned.loc[i, 'Ranked']))
    templist2.append(digit_only(df1_cleaned.loc[i, 'Popularity']))
    templist3.append(digit_only(df1_cleaned.loc[i, 'Members']))
    templist4.append(digit_only(df1_cleaned.loc[i, 'Favorites']))

df1_cleaned=df1_cleaned.drop(columns=['Ranked','Popularity','Members','Favorites'])
df1_cleaned.insert(9,'Ranked',templist1)
df1_cleaned.insert(10,'Popularity',templist2)
df1_cleaned.insert(11,'Members',templist3)
df1_cleaned.insert(12,'Favorites',templist4)

templist1=[]
templist2=[]

for i in range(1000):
    templist=df1_cleaned.loc[i,'Aired'].split()
    templist1.append(templist[0])
    if(len(templist)<3):
        templist2.append('None')
    else:
        templist2.append(templist[2])

df1_cleaned=df1_cleaned.drop(columns=['Aired','Premiered'])
df1_cleaned.insert(3,'Month',templist1)
df1_cleaned.insert(4,'Year',templist2)

df1_cleaned.loc[965,'Month']='None'
df1_cleaned.loc[965,'Year']='2007'
#print(df1_cleaned.iloc[1,])

MonthDict={'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,'Jul':7,'Aug':8,'Sep':9,\
           'Oct':10,'Nov':11,'Dec':12,'None':1}
cur_month='Sep'
cur_year='2021'

templist1=[]
for i in range(1000):
    if(df1_cleaned.loc[i,'Year']=='None'):
        templist1.append('None')
    else:
        temp_month=MonthDict[cur_month]-MonthDict[df1_cleaned.loc[i,'Month']] + \
                (int(cur_year)-int(df1_cleaned.loc[i,'Year']))*12
        templist1.append(str(temp_month))
df1_cleaned.insert(5,'Time',templist1)


df1_cleaned.to_csv('1000RKInfo_cleaned.txt',header=False,index=False)