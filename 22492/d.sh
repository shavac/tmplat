#!/bin/bash


serch_dir=/usr/share/doc
store_path=result.txt


find $serch_dir ! -type d -exec md5sum '{}' ';'|sort|uniq -D -w 33 >$store_path
