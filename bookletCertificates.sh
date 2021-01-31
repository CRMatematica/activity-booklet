#!/bin/bash
set -e

if [ $# -eq 1 ]
then
    activity=$1
    texFile="${activity}Booklet.tex"
    datFile="${texFile/.tex/.dat}"
    if [ ! -f $texFile ]
    then
        echo "bookletCertificates: File $texFile does not exist"
        exit 1
    fi
    if [[ $texFile != *Booklet.tex ]]
    then
        echo "bookletCertificates: Expecting a *Booklet.tex file"
        exit 1
    fi
    SpeakerCertificates="${activity}Certificates.tex"
    rm -f $SpeakerCertificates
    touch $SpeakerCertificates
    function printToTeX() {
        echo $1 >> $SpeakerCertificates
        return 0
    }
    printToTeX " %% This file is automatically deleted, generated and compiled in each run"
    printToTeX "\documentclass[12pt, a4paper]{article}"
    printToTeX "\usepackage[utf8]{inputenc}"
    printToTeX "\usepackage{microtype}"
    printToTeX "\usepackage{amsmath,amssymb}"
    printToTeX "\usepackage{wallpaper}"
    printToTeX "\usepackage{graphicx}"
    printToTeX "\usepackage{fancyhdr}"
    printToTeX "\usepackage[margin=2cm, hmargin=3cm]{geometry}"
    printToTeX
    printToTeX "\pagestyle{fancy}"
    printToTeX "\renewcommand{\headrulewidth}{0pt}"
    printToTeX "\fancyhead[L]{\IfFileExists{Logo.png}{\hspace{-1cm}\includegraphics[width=3cm]{Logo.png}}{\empty}}"
    printToTeX "\fancyfoot{\empty}"
    printToTeX
    printToTeX "\setlength{\voffset}{0.5cm}"
    printToTeX "\setlength{\parindent}{0pt}"
    printToTeX "\setlength{\parskip}{1cm}"
    printToTeX "\CenterWallPaper{0.8}{certificatesBackground.pdf}"
    printToTeX
    printToTeX "\def\signatureImage#1#2{%"
    printToTeX "    \includegraphics[angle=#1, width=#2\textwidth]{signature.png}%"
    printToTeX "}"
    printToTeX "\def\chairOfThe{Chair of the Conference}"
    printToTeX "\def\chair{Professor Llu\'is Alsed\\\`a}"
    printToTeX "\def\signatureLocation{Centre de Recerca Matem\\\`atica, Bellaterra}"
    printToTeX "\def\signatureDate{\today}"
    printToTeX
    printToTeX "\def\signature#1#2#3#4{\vspace*{\fill}\hbox{\vspace*{-1.5cm}\hspace*{#4cm}\scalebox{#1}[1]{\signatureImage{#2}{#3}}\hfill}\par\chair\hfill\signatureDate\linebreak\chairOfThe\hfill\signatureLocation}"
    printToTeX "\begin{document}"
    cat $datFile | while read -r line
    do
        Type=$( echo $line | awk -F  ":" '{print $1}' )
        Param=$( echo $line | awk -F  ":" '{print $2}' | cut -c 2- )
        case $Type in
            "BookletTitle" )
                printToTeX "\def\BookletTitle{{\bf $Param} conference}" ;;
            "Location" )
                printToTeX
                printToTeX "\def\Location{the $Param}" ;;
            "Date" )
                printToTeX "\def\Date{$Param}" ;;
            "Abstract" ) 
                printToTeX "% $Param" ;;
            "Abstracts of the" )
                Part=$Param ;;
            "Speaker" )
                printToTeX "\null\vspace*{4cm}"
                printToTeX "\begin{center}"
                printToTeX "{\Large\bf CERTIFICATE OF PRESENTATION}\par"
                printToTeX "I hereby certify that\par"
                printToTeX "{\bf\Large $( echo $Param | awk -F  ", " '{print $2" "$1}' )}\par" ;;
            "Title" )
#                 printToTeX "has participated as one of the"
#                 printToTeX "{\em $Part}"
                case $Part in
                    "Plenary Talks" )
                        printToTeX "has given a {\em Plenary Talk} " ;;
                    "Invited Talks" )
                        printToTeX "has given an {\em Invited Talk} " ;;
                    "Contributed Talks" )
                        printToTeX "has given a {\em Contributed Talk} " ;;
                    "Poster Presentations" )
                        printToTeX "has delivered a {\em Poster Presentation} " ;;
                    *)
                        printToTeX "has participated as one of the {\em $Part} " ;;
                esac
                printToTeX "at the \BookletTitle{}, held at \Location{} from~\Date{} by presenting the work entitled\par" # Posar $Part en minuscules?
                printToTeX "{\bf\Large $Param}\par"
                printToTeX "\signature{$( seq 1.2 0.05 1.5 | shuf | head -n1 | tr "," "." )}{$( seq -8 0.1 8 | shuf | head -n1 | tr "," "." )}{$( seq 0.35 0.01 0.45 | shuf | head -n1 | tr "," "." )}{$( seq -2 0.1 -1 | shuf | head -n1 | tr "," "." )}"
                printToTeX "\end{center}\clearpage"
    #             printToTeX "\vspace*{1cm}"
                printToTeX  ;;
            "Participant" )
                printToTeX "\null\vspace*{4cm}"
                printToTeX "\begin{center}"
                printToTeX "{\Large\bf CERTIFICATE OF ATTENDANCE}\par" # Canviat attendance per assistance
                printToTeX "I hereby certify that\par"
                printToTeX "{\bf\Large $( echo $Param | awk -F  ", " '{print $1}' )}\par"
                printToTeX "has participated in the \BookletTitle{}, held at \Location{} from~\Date{}.\par"
                printToTeX
                printToTeX "\signature{$( seq 0.9 0.05 1.1 | shuf | head -n1 | tr "," "." )}{$( seq -8 0.1 8 | shuf | head -n1 | tr "," "." )}{$( seq 0.35 0.01 0.45 | shuf | head -n1 | tr "," "." )}{$( seq -2 0.1 -1 | shuf | head -n1 | tr "," "." )}"
                printToTeX "\end{center}\clearpage"
                printToTeX  ;;
            *) ;;
        esac
    done
    printToTeX "\end{document}"
    pdflatex -interaction=nonstopmode $SpeakerCertificates > /dev/null
#     texclean
    echo "$SpeakerCertificates generated and compiled"
    exit 0
fi

echo "bookletCertificates: Run as bookletCertificates Activity"
exit 1
