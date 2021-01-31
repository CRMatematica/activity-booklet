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
    pdflatex $texFile > /dev/null
    pdflatex $texFile > /dev/null
    
    bookletData $activity
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    bookletCertificates $activity
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    
    rm -dfR $activity/
    rm -df $activity.tar.gz
    mkdir $activity
    datFile="${texFile/.tex/.dat}"
    cat $datFile | while read -r line
    do
        Type=$( echo $line | awk -F  ":" '{print $1}' )
        Param=$( echo $line | awk -F  ":" '{print $2}' | cut -c 2- )
        case $Type in
            "Abstract" ) 
                cp $Param.tex $activity/$Param.tex ;;
            *) ;;
        esac
    done
    cp $texFile $activity/$texFile
    cp $datFile $activity/$datFile
    cp -r ImAgEs/ $activity/ImAgEs/
    tar -zcvf $activity.tar.gz $activity/
    rm -dfR $activity/
    echo "Booklet saved to $activity.tar.gz"
    
    texclean
    mv *.pdf ../
    exit 0
fi

echo "bookletFinal: Run as bookletFinal Activity"
exit 1
