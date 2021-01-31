#!/bin/bash
set -e

if [ $# -eq 1 ]
then
    activity=$1
    texFile="${activity}Booklet.tex"
    datFile="${texFile/.tex/.dat}"
    if [ ! -f $datFile ]
    then
        echo "bookletData: The file $datFile does not exist"
        exit 1
    fi
    echo "Number of Abstracts:" >> $datFile
    cat $datFile | grep "^ Abstract: " | wc -l >> $datFile
    echo "Numer of Authors:" >> $datFile
    { cat $datFile | grep "^  Speaker: " && cat $datFile | grep "^  Author: "; } | sort | wc -l >> $datFile
    echo "Organizers:" >> $datFile
    cat $texFile | sed -e 's/%.*$//' -e '/^$/d' | sed -n '/begin{organizers}/,/end{organizers}/p;/end{organizers}/q' | sed '$d' | sed '1d' | sed "s:\\\\\\\\::" | tr "\t" " " >> $datFile
    echo "Schedule:" >> $datFile
    cat $texFile | sed -e 's/%.*$//' -e '/^$/d' | sed -n '/begin{schedule}/,/end{schedule}/p;/end{schedule}/q' | sed '$d' | sed '1d' | tr "\t" " " >> $datFile
    echo "List of Participants: " >> $datFile
    cat $texFile | sed -e 's/%.*$//' -e '/^$/d' | sed -n '/begin{listofparticipants}/,/end{listofparticipants}/p;/end{listofparticipants}/q' | sed '$d' | sed '1d' | sed "s: \&:,:" | sed "s:\\\\\\\\::" | awk -F  "\\\\" '{print " Participant: "$1}' | tr "\t" " " >> $datFile
    echo "Number of Participants:" >> $datFile
    cat $texFile | sed -e 's/%.*$//' -e '/^$/d' | sed -n '/begin{listofparticipants}/,/end{listofparticipants}/p;/end{listofparticipants}/q' | sed '$d' | sed '1d' | wc -l >> $datFile
    echo "Parsed $texFile"
    exit 0
fi

echo "bookletData: Run as bookletData Activity"
exit 1
