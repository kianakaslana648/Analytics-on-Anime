import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np
from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
import jieba

stop = [line.strip() for line in open('scu_stopwords.txt',encoding='utf-8').readlines() ]

names=['black_heart','fate_ubw','violet']
indlist=[range(1,10),range(13,26), range(1,14)]

s_list=[]
for name_ind in range(3):
    name=names[name_ind]
    for i in indlist[name_ind]:
        tempString = ""
        File=open('''bilibili bullet screens_cleaned\{}\{}_p{}_cleaned.txt'''.format(name,name,i),'r',encoding='utf-8')
        for line in File.readlines():
            wordlist=jieba.cut(line)
            for word in wordlist:
                if word not in stop:
                    tempString = tempString + word + " "
        s_list.append(tempString)

MyCV=CountVectorizer(input='content')

My_DTM = MyCV.fit_transform(s_list)

MyColumnNames = MyCV.get_feature_names()
#print(MyColumnNames)
#exit()

My_DF=pd.DataFrame(My_DTM.toarray(),columns=MyColumnNames)

CleanNames=[]
for name_ind in range(3):
    name = names[name_ind]
    for i in indlist[name_ind]:
        CleanNames.append(name)

My_DF["LABEL"]=CleanNames

print(My_DF)

My_DF.to_csv('BulletScreen_CleanedData.txt',index=False)