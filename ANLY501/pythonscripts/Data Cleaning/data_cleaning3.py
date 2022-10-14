from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

File1=pd.read_csv("1000RKInfoBangumi.txt",encoding='utf-8',names=['Name','Score','Link','Tags'])
df1=pd.DataFrame(File1)
df1_cleaned=df1.drop(columns=['Link'])

print(df1_cleaned.loc[1,])
df1_cleaned.to_csv('1000RKInfoBangumi_cleaned.txt',header=False,index=False)