*! loghelp v1.0
*! last edited: 25 july 2023
*! author: ms

program define loghelp, rclass
    version 16.0
	syntax using, inputname(string) [ smcl text append replace msg vsquish makedo(string) ]
	
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

	log `using', `smcl' `text' `append' `replace' `nomsg'
	// blank line follwing opening message if requested
	if "`msg'"~="" di
	mata: m_loghelp("`inputname'",`vsquishflag', "`makedo'", "`mode'")
	log close

end

mata:

void m_loghelp(	string scalar inputname,
				real scalar vsquishflag,
				string scalar makedo,
				string scalar mode)
{
	makedoflag = (makedo~="")
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
			// line is a stata command
			// remove start of line
			spos = strpos(line,"{stata")
			line = substr(line,spos+6,.)
			// look for " (ascii 34) that starts the string
			spos = strpos(line,char(34))
			// and remove it and any preceding chars (spaces)
			line = substr(line,spos+1,.)
			// look for " (ascii 34) that ends the string
			spos = strrpos(line,char(34))
			// and remove it any any following chars (smcl etc.)
			slen = strlen(line)
			line = substr(line,1,spos-1)
			// echo line and execute it
			printf("{input}. %s\n",line)
			// print blank line unless vsquish specified
			stata(line)
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
			// line is not a stata command
			printf(line)
			printf("\n")
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

