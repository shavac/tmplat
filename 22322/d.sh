#!/bin/bash
#########################################################################
# File Name: 1.sh
# Author: ma6174
# mail: ma6174@163.com
# Created Time: Sun 19 Oct 2014 02:33:03 PM CST
#########################################################################
rm -rf output
rm -rf files


find -P  /usr/share/doc -type f > files
cat files | grep -v output | grep -v files > files2
rm -rf files
mv files2 files
for i in $(cat files)
do
flag=0
cat files | grep -v $i > files1
rm -rf files
mv files1 files
for j in $(cat files)
do
file1=$(md5sum $i | awk '{print $1}')
file2=$(md5sum $j | awk '{print $1}')
if [ $file1 = $file2 ];then
flag=1
cat files | grep -v $j > files1
rm -rf files
mv files1 files
size=$(ls -l $j | awk '{print $5}')
echo "$size $j" >> output
fi
done
if [ $flag -eq 1 ];then
size=$(ls -l $i | awk '{print $5}')
echo "$size $i" >> output
fi
done
