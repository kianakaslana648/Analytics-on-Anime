import csv

names=['black_heart','violet','fate_ubw']
indlist=[range(1,10),range(1,14),range(13,26)]


for name_ind in range(3):
    name=names[name_ind]
    for i in indlist[name_ind]:
        File1=open('bilibili bullet screens\\'+name+'\\'+name+'_p'+str(i)+'.ass',encoding='utf-8')
        File2=open('''bilibili bullet screens_cleaned\{}\{}_p{}_cleaned.txt'''.format(name,name,i),'w',encoding='utf-8')
        line=File1.readline()
        while(line):
            ind=line.find('}')
            if(ind!=-1):
                File2.write(line[ind+1:-1]+'\n')
            line=File1.readline()
