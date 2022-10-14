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

year=2010
print(year)
File=pd.read_csv('AnimebyYear\\'+str(year)+'.txt',encoding='utf-8',names=['Name','Link'])
File_output=open('AnimeInfobyYear\\'+str(year)+'.txt',"a",encoding='utf-8')
playerwriter = csv.writer(File_output, delimiter=',')
df=pd.DataFrame(File)
for i in range(241,df.shape[0]):
    #i=0
    print('  '+str(i))
    templink=df.loc[i,'Link']
    rankpage=requests.get(templink,headers=headers)
    soup=BeautifulSoup(rankpage.text,"html.parser")
    tempbody=(soup.select("#content > table")[0]).contents[1].contents[1].div

    #print(tempbody.find_all('h2')[1].next_sibling.next_sibling)
    #print((tempbody[0]).contents[1].contents[1].div.contents[26])

    if(tempbody.find_all('h2')[1].text=='Information'):
        typetag=tempbody.find_all('h2')[1].next_sibling.next_sibling
    else:
        typetag=tempbody.find_all('h2')[0].next_sibling.next_sibling
    temptype=typetag.text.strip().replace(" ","")[5:].strip()

    epitag=typetag.next_sibling.next_sibling

    stattag=epitag.next_sibling.next_sibling

    airedtag=stattag.next_sibling.next_sibling

    pretag=airedtag.next_sibling.next_sibling

    if(pretag.contents[1].text.strip()=='Premiered:'):
        broadtag=pretag.next_sibling.next_sibling
    else:
        broadtag=pretag

    if(broadtag.contents[1].text.strip()=='Broadcast:'):
        prodtag=broadtag.next_sibling.next_sibling
    else:
        prodtag=broadtag


    #print(prodtag)
    #print(temptype, tempepi, tempstat, tempaired, temppre)

    lictag=prodtag.next_sibling.next_sibling

    studtag=lictag.next_sibling.next_sibling

    sourcetag=studtag.next_sibling.next_sibling

    genretag=sourcetag.next_sibling.next_sibling
    for anyspan in (genretag.find_all("span")):
        anyspan.extract()
    tempgenre=genretag.text.strip().replace(" ","")

    #print(tempgenre)

    durtag=genretag.next_sibling.next_sibling

    ratingtag=durtag.next_sibling.next_sibling

    #print(temptype, tempepi, tempstat, tempaired, temppre,templic,tempstud,tempsource,tempgenre,tempdur,temprating,tempscore)

    usertag=ratingtag.next_sibling.next_sibling.next_sibling.next_sibling.next_sibling.next_sibling
    tempscore=usertag.contents[3].text
    tempuser=usertag.contents[6].text

    ranktag=usertag.next_sibling.next_sibling
    temprank=ranktag.contents[2].strip()

    poptag=ranktag.next_sibling.next_sibling
    temppop=poptag.contents[2].strip()

    memtag=poptag.next_sibling.next_sibling
    tempmem=memtag.contents[2].strip()

    favtag=memtag.next_sibling.next_sibling
    tempfav=favtag.contents[2].strip()

    #print([temptype,tempepi,tempstat,tempaired,temppre,tempbroad,tempprod,templic,tempstud\
    #        ,tempsource,tempgenre,tempdur,temprating,tempscore,tempuser,temprank,temppop,tempmem,tempfav])
    playerwriter.writerow([df.loc[i,'Name'],df.loc[i,'Link'],temptype\
             ,tempgenre,tempscore,tempuser,temprank,temppop,tempmem,tempfav])