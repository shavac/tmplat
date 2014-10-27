#!/bin/bash
date >> "result"
path="/usr/share/doc"
tmp="/tmp/mydir"

mkdir -p $tmp

chksum() {
readlink $@
if [ $? == 1 ];then
_filename=$@
_size=$(stat -c %s "$_filename")
_hash=$(dd if=$1 bs=1M count=1 2>/dev/null | md5sum | awk '{print $1;}')
_log="${tmp}/${_hash:0:2}.$_size.log"
printf "%s:%s:%s\n" $_hash "$_filename" $_size >> $_log
fi
}


export -f chksum
export tmp

find $path -type f | xargs -I{} bash -c 'chksum "{}"'; #put the path to file according to the hash(0:2) and the size

for filelog in `find $tmp -type f -name "*.log" |sort -t "."  -k 2nr`;
do
cat $filelog|sort -k1 -t ":"|awk  ' 
#sort the filename(start with size),then the bigger file will be handled first
#sort the hash in order to compare one by one

  BEGIN{count=1;i=1;j=0;FS=":"}
  #the count is used to hanld the first line
  #i is used to handle the last line is not single file, and these iterate files will be output to result.
  #j is used to mark some iterate file has been handed,and begin to output to result.
  #$1 is hash(md5sum value),as the flag to compare the next line
  #$2 is the filename
  {           
    if (count ==1) #handle the first line
    {
      flag = $1; #keep the first line value
      file=$2;
               
      count ++;
      next;
    }
              
    if(flag == $1 ) #if $1 is same as the prior line, added to hash2[flag]
    {
      hash2[flag]=hash2[flag](hash2[flag]?"\n":flag":"$3":\n")$2;
      i=0;
      j++;
    }
    else   #if $1 not same as the prior line, change the new flag, and output the hash2 to result.
    {
      if(j>1)
      {
        hash2[flag]=hash2[flag]"\n"file;
        print hash2[flag] >> "result";
      }
        flag=$1;
        file=$2;
        i=1;
        j=1;
     }          
   } 

  END {
     if (i==0) #if the last several is the same file, output to result( not handled in previous step)
     {
       hash2[flag]=hash2[flag]"\n"file;
       print hash2[flag] >> "result";
     }
  }'
done
rm -rf ${tmp}/*.log
date >> "result"
