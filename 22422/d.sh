#!/bin/bash
path="/usr/share/doc"
tmp="/tmp/tmpdir"


mkdir -p $tmp
chksum() {
_filename=$@
_size=$(stat -c %s "$_filename")
_hash=$(dd if=$1 bs=1M count=1 2>/dev/null | md5sum | awk '{print $1;}')
_log="${tmp}/$_size.${_hash:0:2}.log"
printf "%s:%s:%sn" $_hash "$_filename" $_size >> $_log
}


export -f chksum
export tmp
find $path -type f | xargs -I{} bash -c 'chksum "{}"';
find $tmp -type f -name "*.log" |sort -r|xargs cat |sort -k1 |awk  ' 

BEGIN{count=1;i=1;j=0;FS=":"}
    {           
        if (count ==1) #handle the first line
    {
          flag = $1; #keep the first line value
          file=$2;


          count ++;
          next;
    }
              
    if(flag == $1) #if $1 is same as the prior line, added to hash2[flag]
    {
          hash2[flag]=hash2[flag](hash2[flag]?"n":flag":"$3":n")$2;
          i=0;
          j++;
    }
        else   
    {
      if(j>1)
      {
            hash2[flag]=hash2[flag]"n"file;
            print hash2[flag] >> "result";
      }
            flag=$1;
            file=$2;
            i=1;
            j=1;
     }          
   }
  END {
     if (i==0) 
     {
           hash2[flag]=hash2[flag]"n"file;
           print hash2[flag] >> "result";
     }
  }

rm -rf "$tmp/*.log"
