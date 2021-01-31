#!/bin/bash
set -e

if [ $# -eq 1 ]
then
    activity=$1
    texFile="${activity}Booklet.tex"
    if [ ! -f $texFile ]
    then
        echo "bookletAssemble: The file $texFile does not exist"
        exit 1
    fi
    echo "Assembling booklet for the activity $activity"
    compileAllTeX > /dev/null
    compileAllTeX > /dev/null
    makeindex -q "${texFile%.*}".idx
    pdflatex -halt-on-error $texFile > /dev/null
    pdflatex -halt-on-error $texFile > /dev/null
    pdflatex -halt-on-error $texFile > /dev/null
    texclean
    mv *.pdf ../
    exit 0
fi

echo "bookletAssemble: Run as bookletAssemble Activity"
exit 1
