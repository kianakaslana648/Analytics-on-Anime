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
#File1=pd.read_csv('First1000RatingAnime.txt',encoding='utf-8',names=['Name','Rank','Link'])
#df1=pd.DataFrame(File1)

File2=pd.read_csv('First1000PopAnime.txt',encoding='utf-8',names=['Name','Rank','Link'])
df2=pd.DataFrame(File2)

#File3=open("1000RKInfo.txt","a",encoding='utf-8')
File4=open("1000POPInfo.txt","a",encoding='utf-8')
#playerwriter1 = csv.writer(File3, delimiter=',')
playerwriter2 = csv.writer(File4, delimiter=',')

#info_DF1=pd.DataFrame(columns=['Name','Rank','Link'],index=[])
#info_DF2=pd.DataFrame(columns=['Name','Rank','Link'],index=[])
#playerwriter1.writerow(['Name','Link','Type','Episodes','Status','Aired','Premiered'\
#                            ,'Broadcast','Producers','Licensors','Studios','Source','Genres'\
#                           ,'Duration','Rating','Score','Ranked','Popularity','Members','Favorites'])
#i=791
for i in range(791,1000):
    print(i)
    templink=df2.loc[i,'Link']
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
    tempepi=digit_only(epitag.text)

    stattag=epitag.next_sibling.next_sibling
    tempstat=stattag.contents[2].strip()

    airedtag=stattag.next_sibling.next_sibling
    tempaired=airedtag.contents[2].strip()

    pretag=airedtag.next_sibling.next_sibling

    if(pretag.contents[1].text.strip()=='Premiered:'):
        temppre=pretag.text.strip().replace(" ","")[10:].strip()
        broadtag=pretag.next_sibling.next_sibling
    else:
        temppre='None'
        broadtag=pretag

    if(broadtag.contents[1].text.strip()=='Broadcast:'):
        tempbroad=broadtag.contents[2].strip()
        prodtag=broadtag.next_sibling.next_sibling
    else:
        tempbroad='None'
        prodtag=broadtag

    prodtag.span.extract()
    tempprod=prodtag.text.strip().replace(" ","")

    #print(prodtag)
    #print(temptype, tempepi, tempstat, tempaired, temppre)

    lictag=prodtag.next_sibling.next_sibling
    lictag.span.extract()
    templic=lictag.text.strip().replace(" ","")

    studtag=lictag.next_sibling.next_sibling
    tempstud=studtag.a.text.strip()

    sourcetag=studtag.next_sibling.next_sibling
    tempsource=sourcetag.contents[2].strip()

    genretag=sourcetag.next_sibling.next_sibling
    for anyspan in (genretag.find_all("span")):
        anyspan.extract()
    tempgenre=genretag.text.strip().replace(" ","")

    #print(tempgenre)

    durtag=genretag.next_sibling.next_sibling
    tempdur=durtag.contents[2].strip()

    ratingtag=durtag.next_sibling.next_sibling
    temprating=ratingtag.contents[2].strip()

    tempscore=df2.loc[i,'Rank']

    #print(temptype, tempepi, tempstat, tempaired, temppre,templic,tempstud,tempsource,tempgenre,tempdur,temprating,tempscore)

    usertag=ratingtag.next_sibling.next_sibling.next_sibling.next_sibling.next_sibling.next_sibling
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
    playerwriter2.writerow([df2.loc[i,'Name'],df2.loc[i,'Link'],temptype,tempepi,tempstat,tempaired,temppre,tempbroad,tempprod,templic,tempstud\
             ,tempsource,tempgenre,tempdur,temprating,tempscore,tempuser,temprank,temppop,tempmem,tempfav])