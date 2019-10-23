#!/bin/bash

dir="links"
cd $dir
set i=0
title_line=24
files="long_reads.url quick_takes.url reviews.url"
for file in $files ; do
    if [[ -f $file ]] && [[ ! -z $file ]] ; then
	cat $file | while read url ; do
	    open -a Safari "https://$url"
	done
    fi
done
