#!/bin/bash

##  Define directory names (as a string of single strings) 
dirs="intro long_reads quick_takes reviews closing"
##  Define part titles (as an array of strings)
parts=("Introductory Remarks" "Long Reads" "Quick Takes" "Reviews" "Closing Remarks")

basedir=$PWD
out="$basedir/include_contents.tex"
if [[ -f $out ]] ; then
    rm $out ; touch $out
fi

i=0
for dir in $dirs ; do
    cd $dir
    ## The superseded directory is created to keep previous versions of latex files
    mkdir -p superseded
    echo -e "\part{${parts[i]}}" >> $out
    if [[ "${parts[i]}" == "Introductory Remarks" ]] || [[ "${parts[i]}" == "Closing Remarks" ]] ; then
	echo "\onecolumn" >> $out
	echo >> $out
    else
	echo "\twocolumn" >> $out
	echo >> $out
    fi
    #nFiles=$(ls -1 *.tex | cat -n | awk '{print $1}')    
    for file in *.tex ; do
	name=$(echo $file | sed 's/.tex//g')
	echo "\include{$dir/$name}" >> $out
    done
    echo >> $out
    i=$((i+1))
    cd ..
done

echo "File include_contents.tex ready."
echo
echo "Instructions"
echo "1) You can compile the issue using (copy and paste on command line):"
echo "pdflatex new_annales.tex; pdflatex new_annales.tex; pdflatex new_annales.tex"
echo "2) Take note of the references where latex encounters unrecognised characters, but press enter each time to continue."
echo "3) Examine the pdf output, and make modifications needed to every .tex file."
echo "4) Save each edited version with the suffix '_final.tex', and mv the old file to superseded/ in each directory."
echo "5) Run this script again, recompile new_annales.tex, check the pdf output, and iterate as necessary."
