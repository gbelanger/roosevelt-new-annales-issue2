#!/bin/bash

##  Running this script will always create a new version
##  of the original .tex file, and append '_mod' to the name.
##  Each time it runs, it always deletes previous modified version
##  and starts from the original (file without _mod in its name).

##  This is needed for sed to work correctly
unset LANG

##  Check there are 2 arguments
if [[ $# -ne 2 ]] ; then
    echo "Usage: ./replace_string_everywhere.sh old_string new_string"
    exit
fi
old_string="$1"
new_string="$2"

##  Define all directories where there are .tex files
dirs="intro long_reads quick_takes reviews closing"

##  Delete previous versions
rm */*mod*tex

##  Loop through directory 
for dir in $dirs ; do
    cd $dir    
    ##  Loop through .tex files
    for file in *.tex ; do
	file_prefix=$(echo $file | sed 's/.tex//')
	mod=${file_prefix}_mod.tex
	##  Delete previous version
	if [[ -f $mod ]] ; then rm $mod ; fi
	##  Replace the string
	sed -e "s/$old_string/$new_string/" $file > $mod
    done
    cd ..
done
