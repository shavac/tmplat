#!/bin/bash

find /usr/share/doc -type f | xargs md5sum |awk '{ b=substr($1,0,2); hash[b]=hash[b](hash[b]?"\n":"")$1":"$2;}
 END { 
    for (key in hash)
    {
        filename="/tmp/mydir/"key".log";
        print hash[key] > filename;
    }
}'

find /tmp/mydir -type f -name "*.log"|awk ' {


         num=1;x=1;y=0;
       while(getline line < $1)
         {
             split(line,keys,":");
             if (num ==1)
             {
                  flag = keys[1];
                  a=keys[2];
                num ++;
                  continue;
              }
              
              if(flag == keys[1])
{
                 hash2[flag]=hash2[flag](hash2[flag]?"\n":flag":")keys[2];
                 x=0;y++;
}
              else
             {
                 if(y>1){
                 hash2[flag]=hash2[flag]"\n"a;
print hash2[flag] >> "result";}
                 flag=keys[1];
                 a=keys[2];
                 x=1;y=1;
              }

              
         }
               if (x==0){
               hash2[flag]=hash2[flag]"\n"a;
     print hash2[flag] >> "result";}
        #system("rm -f *.log");
}'
