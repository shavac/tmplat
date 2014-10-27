#!/bin/bash
 
cat /dev/null > size.txt
cat /dev/null > md5.txt
cat /dev/null > info.txt
 
find /usr/share/doc -type f|awk '{fname[NR]=$1}END{for(i in fname){print system("du -h "fname[i]" >>size.txt"),system("md5sum "fname[i]" >>md5.txt")}}'
 
paste -d " " size.txt md5.txt > info.txt
 
awk '{size[NR]=$1;info[NR]=$2;md5[NR]=$3}{for(i in size){for(j=i+1;j<=length(size);j++){if(size[i]==size[j]&&md5[i]==md5[j]) {print "zhe same file: " info[i],info[j]} }}}' info.txt > samefile.txt
 
awk '!a[$0]++' samefile.txt > samefiles.txt
