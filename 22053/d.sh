#!/bin/sh 
path="/usr/share/doc"
K=0


find "$path" -type f -exec md5sum {} + |  
awk -v DEL=$del -v SLT=$silent '
{
if($1 in md5)
{
md5_l[k++]=$2
md5_l[k++]=md5[$1]
}
else
md5[$1] = $2
}
END{
for(key in md5_l)
{
printf("%s %s\n", md5_l[key],key)

}
}'
