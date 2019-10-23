\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{roosevelt}[2019/01/09 LaTeX class for the New Annales]
 
\newcommand{\headlinecolor}{\normalcolor}
\LoadClass[twocolumn,parskip=full,12pt,twoside,final,a4paper]{scrreprt}
\RequirePackage{xcolor}
\RequirePackage{ragged2e}
\RequirePackage[left=3.5cm,right=2.5cm,top=3.5cm,bottom=3.5cm,columnsep=1cm]{geometry}
\setlength{\parindent}{0pt}
\RequirePackage[english]{babel}							% English language/hyphenation
\RequirePackage[pdftex]{graphicx}							% Enable pdflatex
\RequirePackage{fix-cm}						% needed for lettrine
\RequirePackage{setspace}					% needed for lettrine
\RequirePackage{lettrine}						% for making large first capital

%%%  Define fonts
\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath,amsfonts,amsthm}					% Math packages
\RequirePackage{mathptmx}								% Times Roman font
\RequirePackage{librebaskerville}
\RequirePackage[T1]{fontenc}
\RequirePackage{montserrat}
\newcommand{\yuge}{\fontsize{30}{36}\usefont{T1}{librebaskerville}{bfseries}{n}\color{rooseveltblue}\selectfont}
\RequirePackage{float}
\RequirePackage[protrusion=true,expansion=true]{microtype}		% Better typography

%%% TOC
\RequirePackage{tocloft}
\PassOptionsToPackage{titles}{tocloft}
\renewcommand{\cfttoctitlefont}{\yuge}
%\setcounter{secnumdepth}{3} 
% Table of contents max depth listed:
% 1 = section, 2 = subsection, 3 = subsubsection
\setcounter{tocdepth}{0} 

% Dots
\renewcommand{\cftpartleader}{\cftdotfill{\cftdotsep}} % for parts
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % for chapters
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}

% Space between entries
\renewcommand\cftpartafterpnum{\vskip6pt}
\renewcommand\cftchapafterpnum{\vskip-4pt}
%\renewcommand\cftsecafterpnum{\vskip6pt}
%\renewcommand\cftsubsecafterpnum{\vskip6pt}

% Fonts for sectional unit title fonts in ToC
\renewcommand{\cftpartfont}{\sffamily\large}
\renewcommand{\cftchapfont}{\rmfamily}
\renewcommand{\cftsecfont}{\rmfamily}
\renewcommand{\cftsubsecfont}{\rmfamily}

% Fonts for page numbers
\renewcommand{\cftpartpagefont}{\sffamily\large}
\renewcommand{\cftchappagefont}{\rmfamily}
\renewcommand{\cftsecpagefont}{\rmfamily}
\renewcommand{\cftsubsecpagefont}{\rmfamily}

% Define  mychapter to avoid numbering them in the TOC
%\newcommand{\mychapter}[2]{
%    \setcounter{chapter}{#1}
%    \setcounter{section}{0}
%    \chapter*{#2}
%    \addcontentsline{toc}{chapter}{#2}
%    \renewcommand{\chapterheadstartvskip}{\vspace{-.2\baselineskip}}
%	\setkomafont{chapter}{\large{\usefont{T1}{qhv}{m}{n}{\color{rooseveltblue}\selectfont}}}
%	\setkomafont{chapterprefix}{\large}
%	\RedeclareSectionCommand[beforeskip=-1sp,afterskip=2\baselineskip]{chapter}
%}
%\renewcommand{\part}[1]{\addcontentsline{toc}{part}{#1}}

% Define custom colours
\definecolor{rooseveltblue}{RGB}{1,18,94}
\definecolor{rooseveltgrey}{RGB}{103,103,103}
\DeclareOption{blue}{\renewcommand{\headlinecolor}{\color{rooseveltblue}}}
\DeclareOption{grey}{\renewcommand{\headlinecolor}{\color{rooseveltgrey}}}

% Pass options to the mother class KOMA-script scrreprt
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreprt}}
\ProcessOptions\relax

% Define custom large coloured font
\newcommand{\massiveblue}[1]{\fontsize{85}{102}{\usefont{T1}{librebaskerville}{bfseries}{n}{\color{rooseveltblue}{#1}}}\selectfont}
\newcommand{\hugegreycapitals}[1]{\fontsize{30}{36}{\usefont{T1}{qhv}{m}{n}{\color{rooseveltgrey}{\MakeUppercase{#1}}}}\selectfont}
\newcommand{\largegreycapitals}[1]{\large{\usefont{T1}{qhv}{m}{n}{\color{rooseveltgrey}{\MakeUppercase{#1}}}}\selectfont}
\newcommand{\largebluecapitals}[1]{\large{\usefont{T1}{qhv}{m}{n}{\color{rooseveltblue}{\MakeUppercase{#1}}}}\selectfont}
  
% Define various kinds of spacings
\def\ssp{\def\baselinestretch{1.0}\large\normalsize}
\def\qsp{\def\baselinestretch{1.05}\large\normalsize} % quarter spacing
\def\hsp{\def\baselinestretch{1.37}\large\normalsize} % half spacing
\def\dsp{\def\baselinestretch{1.8}\large\normalsize}
% \smallssp is used to produce tabular environments in the small font.
% This is required because single-spacing requires a change in font size.
% \scriptsizessp is a still smaller version of the same thing.
\def\smallssp{\def\baselinestretch{1.0}\large\small}
\def\scriptsizessp{\def\baselinestretch{1.0}\large\scriptsize}
 
% Define custom fields to be used in the credits page
\def\volumenumber#1{\gdef\@volumenumber{#1}}
\def\issuenumber#1{\gdef\@issuenumber{#1}}
\def\semester#1{\gdef\@semester{#1}}
\def\issnprint#1{\gdef\@issnprint{#1}}
\def\issnweb#1{\gdef\@issnweb{#1}}
\def\editor#1{\gdef\@editor{#1}}
\def\publishing#1{\gdef\@publishing{#1}}
\def\layout#1{\gdef\@layout{#1}}

% Use to restart page numbering
\newenvironment{startarabicpagination}
{
	\setcounter{page}{1}
	\pagenumbering{arabic}
}
{}

%%% Creating an initial of the very first character of the content
\newcommand{\initial}[1]{%
     \lettrine[lines=3,lraise=0.12,lhang=0.35,findent=2pt,nindent=0em]{
     				\color{rooseveltblue}
     				{\textsf{#1}}}{}}

% Horizontal thick blue line
\newcommand{\blueline}{\noindent\makebox[\textwidth]{\color{rooseveltblue}\rule{1.8\paperwidth}{2pt}}}


% Define maketitle to create the title and credits pages
\def\maketitle
{	
{	
\pagenumbering{roman}

%%% THIS IS THE FIRST PAGE
\thispagestyle{empty}

%\blueline
%\flushright
\flushleft

\vspace*{2\baselineskip}

\massiveblue{New \\ Annales}

\vfill %\vspace*{0.6\baselineskip}

\indent\hugegreycapitals{ISSUE \@issuenumber} \\
\indent\hugegreycapitals{\@semester}

\vfill

\flushleft
\begin{minipage}{0.3\textwidth}
\begin{figure}[H]
\includegraphics[height=8\baselineskip,keepaspectratio]{logo.png}
\end{figure}
\end{minipage}
\vfill

\blueline

%%%  THIS IS THE SECOND PAGE
\newpage
\flushleft
\thispagestyle{empty}
\normalfont
\hsp

{\Large\color{rooseveltblue}New Annales} \\

\bigskip

Volume \@volumenumber \\
Issue \@issuenumber \\
\@semester \\

\vfill

ISSN: \@issnprint \, [print] \\
ISSN: \@issnweb \, [web] \\

\vfill

\largebluecapitals{EDITOR-IN-CHIEF}

\smallskip
\@editor \\

\vfill

\largebluecapitals{PUBLISHING DIRECTOR}

\smallskip
\@publishing \\

\vfill

\largebluecapitals{COPY \& LAYOUT EDITORS}

\smallskip
\@layout \\

\vfill

\vspace{15mm}
\begin{minipage}{0.6\linewidth}
\justify
\ssp
\noindent New Annales is the semesterly publication of the Roosevelt Club. \href{www.rooseveltclub.co.uk}{www.rooseveltclub.co.uk} \\

\smallskip
\noindent This publication contains the collective views of an international group of students and does not necessarily represent the views, decisions, or the stated policy of the Roosevelt Club. \\

\smallskip
\noindent Printed in the United Kingdom.
\end{minipage}
}
\cleardoubleoddemptypage
}
 
%%% Define header and footer using the package scrlayer
\RequirePackage{scrlayer-scrpage} 
\clearpairofpagestyles
%\pagestyle{scrheadings}
\addtokomafont{pagenumber}{\sffamily}
\addtokomafont{pagenumber}{\bfseries\color{white}}

% Footer
\setlength{\footheight}{24.0pt}
\ofoot{}
\rofoot*{\largegreycapitals{\@semester}\makebox[0pt][l]{\hspace*{1em}\colorbox{rooseveltblue}{\strut\makebox[\textwidth][l]{\enskip\strut\pagemark}}}}
\lefoot*{\makebox[0pt][r]{\colorbox{rooseveltblue}{\makebox[\textwidth][r]{\pagemark\strut\enskip}}\hspace*{1em}}\largegreycapitals{rooseveltclub.co.uk  \;\;---\;\;  new annales}}

% Header

%\ohead{}
%\rohead{\parttitle}% clear the outer head
%\rohead*{\makebox[0pt][l]{\hspace*{1em}\colorbox{rooseveltblue}{\strut\makebox[\textwidth][l]{\enskip\strut\partname\;\thepart}}}}
%\lehead*{\makebox[0pt][r]{\colorbox{rooseveltblue}{\makebox[\textwidth][r]{\partname\;\thepart\strut\enskip}}\hspace*{1em}}}

% Specify the bibliography style (not used now)
\bibliographystyle{abbrv}

