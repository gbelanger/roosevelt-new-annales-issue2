# New Annales Issue 2 - Fall 2019 (Oct 2019)

## Purpose

This is an updated version of what was done for the Roosevelt Club's New Annales Issue 1. The filenames of articles below are from Issue 1.

The purpose of this repository is to store the contents of the Roosevelt Club's New Annales Issue 2. This is a LaTeX project whose main class is `roosevelt.cls` and parent file is `new_annales.tex`. Several scripts are used to automate and facilitate the building of the document. Ideally, one should be able to run the scripts in one shot using `./run_all_scripts.sh`. Here we explain the different steps separately.

Note that the size and placement of the large initial capital at the start of each article is defined in roosevelt.cls, and works for most letters. This default placement was adjusted to make the left and top edges of a capital T align with the edge of the left margin and top of the tall letters (like 'h', 't', 'f', etc) in the first line. A special adjustment was made for a capital "F" and the command was renewed at the start and end of that particular article (the long read Tear Down This Wall).

## How it works

Because the contents of the articles will be published online first, this is where they need to be taken from. The directory `links` must contain text files, one file per part, named after the part and containing the links to the article in the desired order. These are

- long_reads.url
- quick_takes.url
- reviews.url

```
gbelanger$ ll links/*.url

-rw-r--r--  1 gbelanger   224B 25 Jan 21:17 links/long_reads.url
-rw-r--r--  1 gbelanger   178B 25 Jan 21:17 links/quick_takes.url
-rw-r--r--  1 gbelanger   191B 25 Jan 21:17 links/reviews.url
```

And here's what's inside these files

```
gbelanger$ for file in links/*.url ; do echo $file ; cat $file ; echo ; done`

links/long_reads.url
www.rooseveltclub.co.uk/new-annales/the-most-powerful-climate-lie
www.rooseveltclub.co.uk/new-annales/the-moral-responsibility-in-foreign-aid
www.rooseveltclub.co.uk/new-annales/in-defence-of-giving-foreigners-our-tax-money

links/quick_takes.url
www.rooseveltclub.co.uk/quick-takes/designer-babies
www.rooseveltclub.co.uk/quick-takes/the-ethics-of-self-driving-cars
www.rooseveltclub.co.uk/quick-takes/cannabis-legalisation

links/reviews.url
www.rooseveltclub.co.uk/reviews/the-name-of-the-rose
www.rooseveltclub.co.uk/reviews/natural-capital
www.rooseveltclub.co.uk/reviews/spaces-of-aid
www.rooseveltclub.co.uk/reviews/hit-refresh
```

These are the links which are used by the first script, executed by typing  `./grab_text_from_website.sh`, which creates text files from the html and writes them as text files in the `links` directory as follows

```
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
```

# Step 2: Prepare the files for LaTeX

Once the text from the website has been put into text files, it needs to be cleaned up and prepapred for LaTeX compilation. This is done using the script `prepare_files.sh` that does its best to remove the unneeded stuff from the grab, back-slashing special characters, and adding the `\chapter`, `\label`, and `\initial` commands at the top of each file. The files are stored in directories corresponding to each part with the same naming convention. These directories, including the additional intro and closing are

- intro
- long_reads
- quick_takes
- reviews
- closing

The working assumption is that these will always be the same for each issue of the New Annales, and that the intro will always include the same `about-the-roosevelt-club.tex` but a different `letter-from-the-editor.tex` which will be written each time but keep the same name and title. Similarly, the closing will always contain `letter-from-the-president.tex` whose contents will change for each issue. The rest of the files in the parts `long_reads`, `quick_takes`, and `reviews` will be dynamic and defined by the links in `links/long_reads.url`, `links/quick_takes.url`, and `links/reviews.url`. This is what the script does

```
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
```

# Step 3: Print out the include commands 

After having grabbed the text and prepared the LaTeX files, we need to create the file `include_contents.tex` that will be inputted into the main file new_annales.tex using `\input{include_contents}`. This is done by running the script `print_latex_include.sh`. This is what this script looks like

```
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
echo "5) Run the script print_latex_include.sh again, recompile new_annales.tex, check the pdf output, and iterate as necessary."
```

# Step 4: Manual edits and final compilaton

The last step is to do the manual edits to each individual LaTeX file before compiling `new_annales.tex`. Note that you can use the compiler to tell you where required edits (replacement of unrecognised characters) are needed.

It's important to follow the instructions printed out in the previous step. In particular, an edited file should be renamed using, for example, a suffix like _final.tex in order to distinguish it from the default filename in the case that the script grab_text_from_website.sh is run again, because this will overwrite the originallly named .tex files (those without _final).

If you want to keep trace of the previous version of files, you can move the original files to the superseded directory. You can, for example, before strating to edit manually, first copy the original file, and then move it as follows from the command line:

```
cp filename.tex filename_final.tex
mv filename.tex superseded/
```
(Note the slash that indicates you want to move the file inside the directory, and not change the name of file to superseded, which would happen if you didn't put the slash.)

At any time during the editing process, you can regenerate the include_contents.tex file by running print_latex_include.sh to update the contents and recompile new_annales to see what it looks like. The script will construct the contents from all the .tex files in the subdirectories containing the articles (long_reads, quick_takes, etc).

