{smcl}
{* *! version 26jul2023}{...}
{hline}
{cmd:loghelp}{right: v1.1}
{hline}

{title:loghelp - Stata utility for creating a log file from a Stata help file}

{pstd}
{opt loghelp} is Stata utility for creating a log file from a Stata help file.
Specifically, {opt loghelp} will:{p_end}

{p 4}1. Echo text that appears in the help file onto the screen and into the log file.{p_end}

{p 4}2. Execute lines that are clickable Stata commands and print the output to the screen and log file.{p_end}

{p 4}3. Optionally create a do file with these clickable Stata commands.{p_end}

{p 4}4. Optionally include in the do file both clickable and non-clickable Stata commands.{p_end}

{pstd}For (2) to work, the Stata commands in the help file need to be clickable,
i.e., clicking on the line in the help file would execute the command.
NB: Within the Stata help file, the clickable line will use
the {help smcl} command {cmd:{c -(}stata} {it:args}[{cmd::}{it:text}]{cmd:{c )-}};
see {help smcl:help smcl}.{p_end}

{pstd}{opt loghelp} is useful for Stata programmers who want to check that
the clickable examples in their help files will run correctly,
or for people (e.g., teachers) who want to confirm that the clickable examples in a help file
will indeed run without error on an installation of Stata.{p_end}

{pstd}{opt loghelp} is also useful for anyone who wants to create
a do file out of the examples in a help file,
whether or not they are clickable.{p_end}

{pstd}{opt loghelp} usage is similar to that of Stata's {help log} command.
The main difference is that you do not need to close the log file;
unless {opt loghelp} terminates early with an error,
this will be done automatically.{p_end}

{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{opt log} {cmd:using} {it:logfilename} {cmd:,}
{opt inputname(filename)}
{bind:[ {cmd:append}}
{opt replace}
{opt text}
{opt smcl}
{opt msg}
{opt makedo(filename[, append|replace])}
{opt allcmd}
{bind:{cmd:vsquish} ]}


{synoptset 20}{...}
{synopthdr:Options}
{synoptline}
{synopt:{opt logfilename}}
is the name of the log file where the screen output is sent.
Naming behavior including the extension is the same as for Stata's {help log} command.
{p_end}
{synopt:{opt inputname(filename)}}
is the name of the Stata help file.
You need to specify the full filename including the ".sthlp" extention.
{p_end}
{synopt:{opt append}}
specifies that results be appended to an existing file (same behavior as for Stata's {help log} command).
{p_end}
{synopt:{opt replace}}
specifies that {it:filename}, if it already exists, be overwritten (same behavior as for Stata's {help log} command).
{p_end}
{synopt:{opt text}}
specifies that the log file is to be in text format (same behavior as for Stata's {help log} command).
{p_end}
{synopt:{opt smcl}}
specifies that the log file is to be in smcl format (same behavior as for Stata's {help log} command).
{p_end}
{synopt:{opt msg}}
requests the usual suppresses the default message displayed at the top and bottom of the log file
({it:opposite} behavior vs Stata's {help log} command).
{p_end}
{synopt:{opt makedo(filename[,append|replace])}}
creates, or appends to, a do file from any clickable Stata command in the help file.
The default is to start a new do file unless it already exists,
in which case {opt loghelp} exits with an error.
The ".do" extension is automatically added to the name of the file.
{p_end}
{synopt:{opt allcmd}}
applies only with {opt makedo(.)} and specifies that
all Stata command lines should be written to the do file,
whether or not they are clickable.
{p_end}
{synopt:{opt vsquish}}
suppresses the usual blank line after a Stata command is executed.
{p_end}
{synoptline}
{p2colreset}{...}
{pstd}


{title:Examples}

{pstd}The example below uses this help file, i.e., loghelp.sthlp.
Note that to prevent recursion errors,
{opt loghelp} will not execute any line in which the {opt loghelp} command itself is used.
Instead, a warning line is printed.
The line will, however, be written to a do file if the {opt makedo(.)} was specified.{p_end}

{phang2}. {stata "sysuse auto, clear"}{p_end}

{pstd}Do something that will appear in the log file:{p_end}

{phang2}. {stata "sum mpg weight"}{p_end}

{pstd}Get the full path of the help file and then use it in the call to {opt loghelp}:{p_end}

{phang2}. {stata "findfile loghelp.sthlp"}{p_end}
{phang2}. {stata "return list"}{p_end}
{phang2}. {stata "loghelp using mylog, inputname(`r(fn)') replace smcl"}{p_end}

{pstd}Do something else that will appear in the log file:{p_end}

{phang2}. {stata "regress mpg weight"}{p_end}

{pstd}The next example will create a log file that has
the displayed contents of Stata's {help regress} help file
along with a do file that has the Stata command lines for all the examples.
At the time of writing Stata's {help regress} help file examples are not clickable,
and so the {opt allcmd} option is needed.{p_end}

{phang2}. {stata "findfile regress.sthlp"}{p_end}
{phang2}. {stata "loghelp using mylog, inputname(`r(fn)') replace smcl makedo(mydo, replace) allcmd"}{p_end}


{marker author}{title:Author}

{pstd}
Mark E Schaffer, Heriot-Watt University, UK {break}
m.e.schaffer@hw.ac.uk
	