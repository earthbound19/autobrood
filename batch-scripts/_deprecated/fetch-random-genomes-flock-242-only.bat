REM Set the global values which follow per need/want either from the command prompt before running this batch, or set them in this script (change the following defaults) :
ECHO OFF

REM KNOWN ISSUES: there are a lot of gaps in sheep numbers in flock 243; they are not contiguous, and you therefore may not get so many randomly selected genes. TO DO: script this to only use legit filenames, and not numbers pulled from random.org :/ which I do *not* want to script in batch. I may just break with DOS and require Cygwin 'nix /.sh here.

SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT DEFINED numRandomSheep SET /A numRandomSheep=17
IF NOT DEFINED gen242flockDir SET gen242flockDir=_resources\gen242
IF NOT DEFINED sheepFlameFilePrefix SET sheepFlameFilePrefix=electricsheep_242

REM  ===========================================================================
REM  =============SHEEP GENERATION 242 RANDOM FETCHING SECTION==================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 242.
	REM 	The base format for this is: http://www.random.org/integers/?num=!gen242found!&min=1&max=!gen242found!&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

IF !numRandomSheep! NEQ 0	(
ECHO ===========================================================================
ECHO Fetching !numRandomSheep! purely random sheep IDs from flock 242 in range 1 to !gen242found!..
ECHO ===========================================================================

	REM reference command:
	REM wget --tries=1 --output-document=random.org-sheep-gen-242-IDs.txt http://www.random.org/cgi-bin/randnum?num=!numRandomSheep!^&min=1^&max=!gen242found!^&col=!numRandomSheep!^&base=10^&format=plain^&rnd=new
wget --tries=1 --output-document=random.org-sheep-gen-242-IDs.txt https://www.random.org/integers/?num=!numRandomSheep!^&min=0^&max=1158^&col=1^&base=10^&format=plain^&rnd=new

	REM The following copies sheep IDs (from a local repository of them), correlating to the previous generation 242 random ID list downloaded.

	REM Before that, though, make a directory for which us to brood in, based on the date; date formatting re http://stackoverflow.com/a/14826483/1397555 :
	set mydate=!date:~10,4!_!date:~7,2!_!date:~4,2!
	set mytime=!time:~0,2!_!time:~3,2!_!time:~6,2!_!time:~9,2!
	set broodDir=brood_!mydate!__!mytime!
	echo broodDir val is !broodDir!
	REM Not that I really expect this directory to ever exist . . .
	IF NOT EXIST !broodDir! (
	MKDIR !broodDir!
	)
	
FOR /F "delims=" %%S in (random.org-sheep-gen-242-IDs.txt) DO		(
SET sheepID=%%S
	REM echo sheepID val is !sheepID!
REM Pad the number with zeros, re http://stackoverflow.com/a/13401158/1397555 . . .
set "sheepID=0000!sheepID!"
	REM echo sheepID val is !sheepID!
REM Then trim it to four columns (as there are four digits in the highest numbered electric sheep for generation 242) :
set "sheepID=!sheepID:~-4!"
	REM echo zero-padded sheep id is !sheepID!.
	copy !gen242flockDir!\!sheepFlameFilePrefix!.!sheepID!.flam3 !broodDir!
												)
				)

REM DEL random.org-sheep-gen-242-IDs.txt

ENDLOCAL & set broodDir=%broodDir%

ECHO OFF