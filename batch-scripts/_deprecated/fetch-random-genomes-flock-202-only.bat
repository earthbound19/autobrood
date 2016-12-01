ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

		REM the following pulls the status of sheep GENERATION 202 from the sheep server to a text file.
	wget --tries=1 --timeout=2 --output-document=gen-202-fetched-status.txt http://sheepserver.net/v2d6/cgi/status.cgi
		REM wget saves an empty file if the server doesn't respond.  This check deletes the empty file
		REM to cue other parts of the script to set dependent variables to defaults.
	FOR /F "delims=" %%S in (gen-202-fetched-status.txt) DO	(
	SET testContent=%%S
											)
	IF NOT DEFINED testContent DEL gen-202-fetched-status.txt

ECHO ===========================================================================

	REM the following loop finds the highest sheep ID in the status.cgi file pulled
	REM from the sheep server for GENERATION 202.
IF EXIST gen-202-fetched-status.txt	(
FOR /F "usebackq tokens=4 delims==>" %%S in (`FINDSTR /R /I /C:node.cgi?id=[0-9]* gen-202-fetched-status.txt`) DO (
IF NOT %%S==node.cgi?id (
				SET /a comp202found=%%S
REM				ECHO comp202found is !comp202found!
				IF !comp202found! GTR !gen202found! SET /a gen202found=!comp202found!
REM				ECHO gen202found ID is !gen202found!
				)
																			)
						)

ECHO ===========================================================================
IF NOT EXIST gen-202-fetched-status.txt (
ECHO Unable to fetch newest generation 202 sheep ID from server - 
ECHO arbitrarily setting to 134709, the newest sheep found at about
ECHO the time this script was finalized, March 09'
SET gen202found=134709
							) ELSE (
DEL gen-202-fetched-status.txt
ECHO Highest or newest found sheep ID for generation 202 is !gen202found! -
								)

IF NOT DEFINED numRandomSheep SET /A numRandomSheep=10

REM To keep a log of randomly chosen numbers.
IF NOT EXIST random-sheep-log.txt	(
ECHO OFF > random-sheep-log.txt
					) ELSE (
					REM Do nothing
						)

REM  ===========================================================================
REM  =============SHEEP GENERATION 202 RANDOM FETCHING SECTION==================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 202.
	REM 	The base format for this is: http://www.random.org/integers/?num=6&min=1&max=134344&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

ECHO ===========================================================================
ECHO Fetching !numRandomSheep! purely random sheep IDs from flock 202 in range 1 to !gen202found!..
ECHO ===========================================================================

wget --tries=1 --output-document=random.org-sheep-gen-202-IDs.txt http://www.random.org/cgi-bin/randnum?num=!numRandomSheep!^&min=1^&max=!gen202found!^&col=!num202Sheep!^&base=10^&format=plain^&rnd=new

	REM The following downloads sheep IDs correlating to the previous generation 202 random ID list downloaded.

FOR /F "delims=" %%S in (random.org-sheep-gen-202-IDs.txt) DO	(
SET sheepID=%%S
	ECHO Random number is !sheepID!.
	ECHO 202.!sheepID! >> random-sheep-log.txt
	ECHO fetching sheep 202.!sheepID! from http://sheepserver.net/v2d6/gen/202/!sheepID!/spex
wget --tries=1 --output-document=electricsheep.202.!sheepID!.flam3 http://sheepserver.net/v2d6/gen/202/!sheepID!/spex
											)

DEL random.org-sheep-gen-202-IDs.txt

ECHO OFF

ENDLOCAL