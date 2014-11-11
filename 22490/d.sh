#!/bin/bash
#name:find_duplicate_files.sh


find /usr/share/doc -type f -printf "%-25s%p\n" | sort -nr | uniq -D -w25 |awk 'BEGIN{
getline;size=$1;name1=$2;}
{name2=$2;
if(size==$1){
("md5sum "name1)|getline; csum1=$1;
("md5sum "name2)|getline; csum2=$1;
if(csum1==csum2){
{print name1;print name2}
}
};
size=$1;name1=name2}'
