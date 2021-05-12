#!/bin/bash
set -e

if [ $# -eq 1 ]
then
    activity=$1
    texFile="${activity}Booklet.tex"
    if [ -s "$texFile" ]
    then
        echo "The file $texFile already exists and is not empty"
        exit 0
    fi
    touch $texFile
    
    echo "\documentclass{AbstractsCRM}
\usepackage[nodata, final, forwebpdf]{AbstractsBook}
\MeetingGeneralData[Acronym]{Name of the meeting}{Venue}{Date}
\date{production date} % optional
\editors{editors of the abstracts book} % optional

\begin{document}
\begin{organizers}
  \committee{Organizing Committee}

\end{organizers}
\bookletAcknowledgments{Acknowledgments}

\tableofcontents

\begin{schedule}%[1.1]
  \day{}
  \event{}{}
  \talk{}{}
\end{schedule}

\mainmatter

\AbstractsOfThe{Invited Talks}" >> $texFile

    for file in $activity*.tex
    do
        echo "\abstractfile{${file%.*}}" >> $texFile
    done
    
echo "
\begin{listofparticipants}%[0.8]
  
\end{listofparticipants}
\end{document}" >> $texFile
    
    exit 0
fi

echo "bookletInitiate: Run as bookletInitiate Activity "
exit 1
