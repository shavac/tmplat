#!/bin/bash
SEARCHPATH=/usr/share/doc
LOGFILE=repeatedfile.log


echo '' > $LOGFILE
ls -alR $SEARCHPATH 2>/dev/null | awk '$1 ~ /^-/ {print $5,$9}' | awk '$1>0' | grep -v '^$' | grep -v '^4096 .$'
| grep -v '^4096 ..$' | sort -nr | uniq -c | awk '$1>1 {print $3}' | while read FILENAME
do
    firstfile=0
    find $SEARCHPATH -name $FILENAME -ls | awk '$3 ~/^-/ {print $11}' | sort -n | while read FULLFILENAME
   do
        if [ $firstfile -eq 0 ]
        then
            MD51=`md5sum $FULLFILENAME | awk '{print $1}'`
            firstfile=1
        else
            MD52=`md5sum $FULLFILENAME | awk '{print $1}'`
            if [ $MD51 = $MD52 ]
            then 
                echo $FILENAME >> $LOGFILE
                break
            fi
        fi
     done
done
