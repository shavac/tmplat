#! /bin/bash

TOPDIR=/usr/share/doc

if [ ! -z $1 ]; then
    TOPDIR="$1"
fi

if [ ! -z exclude ]; then
    EXCLUDE=$(cat exclude)
fi

EXLIST="-path '/tmp' -prune"

samelist() {
    awk '
    BEGIN {
	OFS="\t"
    }
    {
	#array[size][inode]=filename
	ftw[$7][$1]=$11
    }
    END {
	for(size in ftw) {
	    if (length(ftw[size]) == 1) {
		continue
	    }
	    for( inode in ftw[size]) {
		md5cmd=sprintf("dd if=%s bs=1M count=1 2>/dev/null |md5sum", 
			    ftw[size][inode])
		md5cmd | getline
		close(md5cmd)
		st[size][$1][inode]=ftw[size][inode]
	    }
	}
	for(size in st) {
	    for (md5 in st[size]) {
		if (length(st[size][md5]) == 1) {
		    continue
		}
		for (inode in st[size][md5])
		    print size,md5,st[size][md5][inode]
	    }
	}
    }
    '
}

for exf in $EXCLUDE
do
    EXLIST="$EXLIST -o -path $exf -prune" 
done

find $TOPDIR $EXLIST -o -type f -ls | sort -nrk 7,7 -k 1,1| samelist
