#!/bin/bash

dir="links"
cd $dir
set i=0
title_line=24
files="long_reads.url quick_takes.url reviews.url"
for file in $files ; do
    if [[ -f $file ]] && [[ ! -z $file ]] ; then
	cat $file | while read url ; do
	    echo "Grabbing $url ..."
	    # Define filename from url
	    name=$(echo $url | cut -d"/" -f3)
	    tex=${name}.tex
	    # Get the contents from url
	    /usr/local/Cellar/lynx/2.8.9rel.1_1/bin/lynx -dump $url > $tex
	done
    fi
done
