%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                   AbstractsCRM.cls                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is a class (.cls) file for LaTeX2e.
%%
%% Author:      Lluís Alsedà
%%              Departament de Matemàtiques
%%              Universitat Autònoma de Barcelona
%%              08193-Cerdanyola del Vallès
%%              Barcelona, SPAIN
%%
%%              alseda@mat.uab.cat
%%
%% Feel free to copy, modify, and distribute.
%% I am interested in all changes you make.
%% Send relevant changes to alseda@mat.uab.cat
%%
%% My purpose in writing this .cls is create a style for
%% meetings abstracts that allows to extract information from
%% LaTeX file and, at the same time, it allows to process the
%% abstracts as a standalone document and as abstracts book
%% (with the help of the subordinated package AbstractsBook)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ToDo: Implementar els controls que hi ha a
%% MakeAbstractsbook. Això s'hauria de fer a nivell de latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\def\classname{AbstractsCRM}
\ProvidesClass{\classname}[AbstractsCRM]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass[a4paper,12pt,twoside]{article}

%%%%%%%%%%%%%%%%%%%%
% Default Packages %
%%%%%%%%%%%%%%%%%%%%
\RequirePackage{amsmath,amssymb,amsthm,enumerate}
\RequirePackage[mathscr]{eucal}
\RequirePackage[utf8]{inputenc}
\RequirePackage{url}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Margins, textwidths, indentations etc %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setlength\textwidth {150mm}
\setlength\textheight{200mm}
\setlength{\topmargin}{0pt}
\setlength{\headheight}{0pt}
\setlength{\parindent}{0pt}
\setlength{\parskip}{5pt plus 2pt minus 1 pt}
%
\setlength\oddsidemargin  {\paperwidth}
\addtolength\oddsidemargin{-\textwidth}
\divide\oddsidemargin by 2
\addtolength\oddsidemargin{-1in}
\addtolength\oddsidemargin{-\hoffset}
\setlength\evensidemargin {\oddsidemargin}

%%%%%%%%%%%%%%%%%%%%
%  Class  Commands %
%%%%%%%%%%%%%%%%%%%%
\def\ThisClassError#1{\ClassError{\classname}{#1}{}}

%%%%%%%%%%%%%%%%%%%%%
% Basic environment %
%%%%%%%%%%%%%%%%%%%%%
\renewenvironment{abstract}{\document%
	\ifnum\c@author@number>1%
		\ifx\@speaker@name\relax%
			\ThisClassError{There are more than one authors and no \noexpand\speaker has been given}
		\fi
	\fi%
	\maketitle\thispagestyle{empty}\setlength{\parskip}{4mm plus 2pt minus 1 pt}}{\@acknowledgments\enddocument}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title, authors, address et al. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\renewcommand{\title}[2][\empty]{\gdef\@title{#2}\def\@dummy{#1}\ifx#1\empty\gdef\@running@title{#2}\else\gdef\@running@title{#1}\fi}
\def\speaker#1#2{\def\@speaker@name{#1 #2}\@author@base@command[\underline]{#1}{#2}}
\def\author#1#2{\@author@base@command[\relax]{#1}{#2}}
\def\@collaborators{}
\def\collaborators#1{\ifx\@collaborators\empty\gdef\@collaborators{\par\par\smallskip\par\par{(in collaboration with #1)}}\fi}

\def\@acknowledgments{}
\def\acknowledgments#1{\ifx\@acknowledgments\empty\gdef\@acknowledgments{\paragraph{Acknowledgments:}#1}\fi}

\newcounter{author@number}
\let\@speaker@name\relax
\def\@author@base@command[#1]#2#3{
	\def\@dummy{#2}\ifx\@dummy\empty\ThisClassError{Missing given name in \noexpand\author command}\fi
	\def\@dummy{#3}\ifx\@dummy\empty\ThisClassError{Missing family name in \noexpand\author command}\fi
	\ifcase\c@author@number\def\@author{#1{#2 #3}}
            \or\xdef\@author{\@author$^{\arabic{author@number}}$}
	\fi
	\addtocounter{author@number}{1}
	\expandafter\gdef\csname @full@address\romannumeral\the\c@author@number\endcsname{\ThisClassError{No \noexpand\address given}}
	\expandafter\gdef\csname @email\romannumeral\the\c@author@number\endcsname{}
	\expandafter\gdef\csname @urladdr\romannumeral\the\c@author@number\endcsname{}
	\ifnum\c@author@number>1
		\g@addto@macro\@author{, \mbox{#1{#2 #3}}}\xdef\@author{\@author$^{\arabic{author@number}}$}
	\fi
}

\def\address#1#2{%
	\def\@dummy{#1}\ifx\@dummy\empty\ThisClassError{No institution given in \noexpand\address}\fi%
	\def\@dummy{#2}\ifx\@dummy\empty\ThisClassError{No direction given in \noexpand\address}\fi%
	\expandafter\gdef\csname @full@address\romannumeral\the\c@author@number\endcsname{#1, #2}%
	\expandafter\gdef\csname @institution@address\romannumeral\the\c@author@number\endcsname{#1}%
}
\def\email#1{\expandafter\gdef\csname @email\romannumeral\the\c@author@number\endcsname{E-mail address: {\upshape \url{#1}}}}
\def\urladdr#1{\expandafter\gdef\csname @urladdr\romannumeral\the\c@author@number\endcsname{URL: {\upshape \url{http://#1}}}}

\def\@write@url@line#1{\vskip -1ex\par\par{\small#1}\par\par}
\def\@maketitle{\begin{center}
	\let \footnote \thanks
	{\Large \textbf{\@title}\par}
	\vskip 1.5em
	{\large \textsc{\@author}\@collaborators}
	\end{center}\par\par
	\begingroup\itshape
		\ifnum\c@author@number>1
			\bigskip\par\par
			\count@\@ne
            \loop $^{\the\count@}$ \csname @full@address\romannumeral\the\count@\endcsname.
			\par\par
			\expandafter\ifx\csname @email\romannumeral\the\count@\endcsname\empty
				\expandafter\ifx\csname @urladdr\romannumeral\the\count@\endcsname\empty
				\else
				\@write@url@line{\csname @urladdr\romannumeral\the\count@\endcsname}
			\fi
		\else
			\setbox\z@\hbox{{\small\csname @email\romannumeral\the\count@\endcsname\quad\csname @urladdr\romannumeral\the\count@\endcsname}}
			\ifdim\wd\z@>\textwidth
				\def\@url@sep{\newline}
			\else
				\def\@url@sep{\quad}
			\fi
			\@write@url@line{\csname @email\romannumeral\the\count@\endcsname\@url@sep\csname @urladdr\romannumeral\the\count@\endcsname}
		\fi
		\ifnum\count@<\c@author@number
			\advance\count@ by 1\repeat
		\else
			\setbox\z@\hbox{\itshape\@emaili}\setlength\@tempdima{\wd\z@}%
			\setbox\z@\hbox{\itshape\@urladdri}\ifdim\wd\z@>\@tempdima\setlength\@tempdima{\wd\z@}\fi
			\begin{center} % eliminar això per no centrar els autors
				\@full@addressi\par\par\parbox{\@tempdima}{\raggedright \ifx\@emaili\empty\else \@emaili\\ \fi \@urladdri}
			\end{center} % eliminar això per no centrar els autors
		\fi
	\endgroup
}

%
% Bibliography
\renewenvironment{thebibliography}[1]
{\@acknowledgments\global\let\@acknowledgments\empty
\section*{\refname}%
	\list{\@biblabel{\@arabic\c@enumiv}}%
	{\settowidth\labelwidth{\@biblabel{#1}}%
		\leftmargin\labelwidth
		\itemsep0pt
		\advance\leftmargin\labelsep
		\@openbib@code
		\usecounter{enumiv}%
		\let\p@enumiv\@empty
		\renewcommand\theenumiv{\@arabic\c@enumiv}}%
	\sloppy
	\clubpenalty4000
	\@clubpenalty \clubpenalty
	\widowpenalty4000%
	\sfcode`\.\@m}
{\def\@noitemerr
	{\@latex@warning{Empty `thebibliography' environment}}%
	\endlist}
% We want to supress the optional parameter of \bibitem
\def\@lbibitem[#1]#2{\@bibitem{#2}}
\def\@newl@bel#1#2#3{%
	\def\@dummy{#2}\ifx\@dummy\empty\ThisClassError{\noexpand\bibitem cannot be empty}\fi%
	{\@ifundefined{#1@#2}%
		\relax
		{\gdef \@multiplelabels {%
				\ThisClassError{There were multiply-defined labels}}%
			\ThisClassError{Label `#2' multiply defined}}%
		\global\@namedef{#1@#2}{#3}}}
%%%%%%%%%%%%%%%%%%%%%%%%
% Initial declarations %
%%%%%%%%%%%%%%%%%%%%%%%%
\sloppy
\flushbottom
\frenchspacing
\endinput
