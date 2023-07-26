*! loghelp v1.1
*! last edited: 26 july 2023
*! author: ms

program define loghelp, rclass
    version 16.0
	syntax using, inputname(string) [ smcl text append replace msg vsquish makedo(string) allcmd ]
	
	// default is no log message
	if "`msg'"=="" local nomsg nomsg
	// no newlines between Stata outputs
	local vsquishflag = ("`vsquish'"~="")
	if "`makedo'"~="" {
		tokenize "`makedo'", parse(",")
		// remove option if present
		local makedo `1'.do
		// replace or append?
		if "`3'"=="replace"			local mode w
		else if "`3'"=="append"		local mode a
		else if "`3'"=="" {
			// default is create a new file
			local mode w
			// but exit with error if it already exists
			cap confirm file `makedo'
			if _rc==0 {
				di as err "error - `makedo' already exists; must specify replace or append"
				exit 602
			}
		}
		else {
			di as err "error - unknown makedo option"
			exit 198
		}
	}
	if "`makedo'"~="" & "`allcmd'"~=""		local makedoflag 2
	else if "`makedo'"~=""					local makedoflag 1
	else									local makedoflag 0

	log `using', `smcl' `text' `append' `replace' `nomsg'
	// blank line follwing opening message if requested
	if "`msg'"~="" di
	mata: m_loghelp("`inputname'",`vsquishflag', `makedoflag', "`makedo'", "`mode'")
	log close

end

mata:

void m_loghelp(	string scalar inputname,
				real scalar vsquishflag,
				real scalar makedoflag,			// 0=no do create, 1=clickable only, 2=all
				string scalar makedo,
				string scalar mode)
{
	fh_in  = fopen(inputname, "r")
	if ((makedoflag) & (mode=="w")) {
		// delete existing do file prior to writing
		unlink(makedo)
	}
	if (makedoflag) {
		// open do file for writing or appending
		fh_do = fopen(makedo, mode)
	}
	printf("{txt}")
	while ((line=fget(fh_in))!=J(0,0,"")) {
		if (strmatch(line,"*{stata*")) {
			// line is a clickable stata command
			// remove start of line
			spos = strpos(line,"{stata")
			line = substr(line,spos+6,.)
			// look for " (ascii 34) that starts the string
			spos = strpos(line,char(34))
			// and remove it and any preceding chars (spaces)
			line = substr(line,spos+1,.)
			// look for " (ascii 34) that ends the string
			spos = strrpos(line,char(34))
			// and remove it and any following chars (smcl etc.)
			slen = strlen(line)
			line = substr(line,1,spos-1)
			// echo line and execute it
			printf("{input}. %s\n",line)
			// but only if it's not loghelp (to prevent a recursion error)
			spos = strpos(line,"loghelp ")
			if (spos==0) {
				stata(line)
			}
			else {
				printf("{res}(warning - call to loghelp command not executed)")
			}
			// print blank line unless vsquish specified
			if (vsquishflag==0) {
				printf("{txt}\n")
			}
			else {
				printf("{txt}")
			}
			// write to the do file if requested
			if (makedoflag) {
				fput(fh_do,line)
			}
		}
		else {
			// line is not a clickable stata command
			printf(line)
			printf("\n")
			// write to do file if requested and a non-clickable stata command
			if ((makedoflag==2) & (strmatch(line,"*{cmd:. *"))) {
				// line is a non-clickable stata command
				// remove start of line
				spos = strpos(line,"{cmd:. ")
				line = substr(line,spos+7,.)
				// line may end with a {p_end}; if so, remove it
				line = subinstr(line,"{p_end}","")
				// look for } that ends the smcl {cmd: statement
				spos = strrpos(line,"}")
				// and remove it and any following chars (smcl etc.)
				slen = strlen(line)
				line = substr(line,1,spos-1)
				// write to do file
				fput(fh_do,line)
			}
		}
	}
	// close input file
	fclose(fh_in)
	if (makedoflag) {
		// close do file if created
		fclose(fh_do)
	}
}

end

