{smcl}
{* *! version 25jul2023}{...}
{hline}
{cmd:loghelp}{right: v1.0}
{hline}

{title:loghelp - Stata utility for creating a log file from a Stata help file}

{pstd}
{opt loghelp} is Stata utility for creating a log file from a Stata help file.
Specifically, {opt loghelp} will:{p_end}

{p 4}1. Echo text that appears in the help file onto the screen and into the log file.{p_end}

{p 4}2. Execute lines that are Stata commands and print the output to the screen and log file.{p_end}

{pstd}For (2) to work, the Stata commands in the help file need to be clickable,
i.e., clicking on the line in the help file would execute the command.
NB: Within the Stata help file, the clickable line will use
the {help smcl} command {cmd:{c -(}stata} {it:args}[{cmd::}{it:text}]{cmd:{c )-}};
see {help smcl:help smcl}.

{pstd}{opt loghelp} is useful for Stata programmers who want to check that
the clickable examples in their help files will run correctly,
or for people (e.g., teachers) who want to confirm that the clickable examples in a help file
will indeed run without error on an installation of Stata.

{pstd}{opt loghelp} usage is similar to that of Stata's {help log} command.
The main difference is that you do not need to close the log file;
unless {opt loghelp} terminates early with an error,
this will be done automatically.

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
{synopt:{opt vsquish}}
suppresses the usual blank line after a Stata command is executed.
{p_end}
{synoptline}
{p2colreset}{...}
{pstd}


{title:Examples}

{pstd}The example below uses this help file, i.e., loghelp.sthlp.
Note that the line that calls {opt loghelp} is NOT clickable
(to prevent an infinite loop).
To execute the line, you will need to copy and paste it into the Stata command window
after first using {help findfile} to locate the help file.

{phang2}. {stata "sysuse auto, clear"}{p_end}

{pstd}Do something that will appear in the log file:{p_end}

{phang2}. {stata "sum mpg weight"}{p_end}

{pstd}Get the full path of the help file and display it:{p_end}

{phang2}. {stata "findfile loghelp.sthlp"}{p_end}
{phang2}. {stata `"di "`r(fn)'""'}{p_end}

{pstd}Copy the line below into the command window,
inserting the path and filename for loghelp.sthlp:{p_end}

{phang2}{res:. loghelp using mylog, inputname(...insert filename here...) replace smcl}{p_end}

{pstd}Do something else that will appear in the log file:{p_end}

{phang2}. {stata "regress mpg weight"}{p_end}


{marker author}{title:Author}

{pstd}
Mark E Schaffer, Heriot-Watt University, UK {break}
m.e.schaffer@hw.ac.uk
	