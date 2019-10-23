#!/bin/bash

unset LANG

function increment() {
    sum=$($1 + 1 | bc)
    return $sum
}

dir="links"
cd $dir
title_line=20
url_files=(long_reads.url quick_takes.url reviews.url)
# There are two chapters in the intro labelled 1 and 2
i=3
echo 3 > count
for file in "${url_files[@]}" ; do
    i=$(cat count)
    # Check if file exists and if it's not of zero size
    if [[ -f $file ]] && [[ ! -z $file ]] ; then
	# Remove empty or blank lines 
	sed '/^[[:space:]]*$/d' $file > tmp 
	mv tmp $file
	# Count number of lines
	n=$(wc $file | awk '{print $1}')
	cat $file | while read url ; do
	    # Define filename from url
	    name=$(echo $url | cut -d"/" -f3)
	    tex=${name}.tex
	    echo "Preparing $tex ..."
	    # Drop lines before $title_line
	    title=$(head -$title_line $tex | tail -1)
	    # Construct latex chapter command and paste at top
	    #chapter=$(echo "\mychapter{$i}{$title}")
	    chapter=$(echo "\addchap{$title}")
	    label=$(echo "\label{ch:$name}")
	    let i++
	    # Increment chapter index
	    echo $chapter > tmp
	    echo -e "$label\n" >> tmp
	    echo -e "\initial{T}he first letter is special\n\n" >> tmp
	    # Define the end of the article using words Previous or Next
	    end="Previous"
	    last=$(cat -n $tex | egrep $end | tail -1 | awk '{print $1}')
	    if [ -z $last ] ; then
		end="Next"
		last=$(cat -n $tex | egrep $end | tail -1 | awk '{print $1}')
	    fi
	    # Calculate the number of lines
	    n=$(calc.pl $last - $title_line)
	    # Extract the text between first and last line
	    head -$((last-3)) $tex | tail -$((n-4)) >> tmp
	    # Define the directory (article type) from links file
	    part=$(echo $file | sed s/".url"//g)
	    # Remove line separating text from refs
	    line="__________________________________________________________________"
	    egrep -v $line tmp > tmp2
	    # Add escape character in front of all special characters
	    sed -E 's/([#$%&_])/\\&/g' tmp2 > tmp
	    if [[ -z tmp ]] ; then
		echo "Error: There was a problem with file $file. Probably contains a unrecognised character."
	    fi
	    # Put the contenst of processed file in the right place
	    cat tmp > ../$part/$tex
	    echo $i > count
	done
    fi
done
rm tmp*
rm count
cd ../
