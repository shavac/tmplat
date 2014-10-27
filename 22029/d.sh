#!/bin/bash
#删除临时文件
rm -f 1.txt 2.txt 3.txt 4.txt 5.txt
#查找所有文件 并按大到小排序
find /usr/share/doc -size +0b -exec ls -l --time-style='+%Y/%M/%d %H:%m' {} \;|awk '{print $5" "$8 }'|sort -nr >1.txt
#查找大小相同的文件
cat 1.txt|grep "/"|awk 'length($0)>0{a1[$1]++;a2[$1,a1[$1]]=$2}END{for (j in a1) {if (a1[j]>1){i=1; do {print j" "a2[j,i];i++}while (i<=a1[j])} }}'>2.txt
#排除link
cat 2.txt|while read line
do
        readlink $(echo $line|awk '{print $2}') &>/dev/null
        if [ $? -gt 0 ]
        then
                echo $line >>3.txt
        fi
done
#计算md5
cat 3.txt|awk '{print $2}'|while read line
do
	dd if=$line bs=1M count=1 2>/dev/null | md5sum >>4.txt
done
#拼接文件
 paste 3.txt 4.txt -d " "|awk '{print $1":"$3" "$2}'|sort -nr|awk '{print $2" "$1}' >5.txt
#大小相同 md5 相同的文件列出来  
cat 5.txt |awk '{A1[$1" "$3]++;A2[$3" "$1,A1[$1" "$3]]=$2 } END {for (j in A1) {if (A1[j]>1) {i=1;printf j ; do { printf " "A2[j,i];i++}while (i<=A1[j]);print " " }}}'|sort -nr >result.txt
