
IF NOT DEFINED numRandomSheep SET /A numRandomSheep=13
ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM  ===========================================================================
REM  =============SHEEP GENERATION 243 RANDOM FETCHING SECTION==================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 243.
	REM 	The base format for this is: http://www.random.org/integers/?num=!gen243found!&min=1&max=!gen243found!&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

IF !numRandomSheep! NEQ 0	(
ECHO ===========================================================================
ECHO Fetching !numRandomSheep! purely random sheep IDs from flock 243 in range 1 to !gen243found!..
ECHO ===========================================================================

REM reference command:
REM wget --tries=1 --output-document=random.org-sheep-gen-243-IDs.txt http://www.random.org/cgi-bin/randnum?num=!numRandomSheep!^&min=1^&max=!gen243found!^&col=!numRandomSheep!^&base=10^&format=plain^&rnd=new
wget --tries=1 --output-document=random.org-sheep-gen-242-IDs.txt https://www.random.org/integers/?num=!numRandomSheep!&min=0&max=1158&col=1&base=10&format=plain&rnd=new

	REM The following downloads sheep IDs correlating to the previous generation 243 random ID list downloaded.

FOR /F "delims=" %%S in (random.org-sheep-gen-243-IDs.txt) DO		(
SET sheepID=%%S
			REM =========THIS SECTION OF CODE IS TO ADJUST THE GENERATION 243 SHEEP ID
			REM =========FOR THE FILENAME PART OF THE URL=============================

REM		ECHO sheepID is !sheepID!
		SET sheepFileID=!sheepID!

			FOR /L %%N IN (1,1,5) DO	(
			SET N=%%N
REM					ECHO sheepFileID is !sheepFileID!
				SET trim=!sheepFileID:~-1!
REM					ECHO 1 trim is !trim!
			        IF NOT DEFINED sheepFileID	(
			        SET trim=0
REM					ECHO 2 trim is !trim!
								)
			IF DEFINED sheepFileID SET sheepFileID=!sheepFileID:~0,-1!
REM					ECHO now sheepFileID is !sheepFileID!
			SET sortNum=!trim!!sortNum!
REM					ECHO sortNum is !sortNum!
			SET trim=!nothing!
REM					ECHO 3 trim is !trim!
					REM PAUSE
REM			ECHO loop count N is !N!
								)
REM					ECHO Loop ended.
		SET sheepFileID=!sortNum!
		SET sortNum=!nothing!

			REM =========URL FILENAME ADJUSTMENT SECTION END==========================
	ECHO Random number is !sheepID!.
	ECHO 243.!sheepID! >> random-sheep-log.txt
	ECHO fetching sheep 243.!sheepID! from http://electricsheep.org/archive/generation-243/!sheepID!/electricsheep.243.!sheepFileID!.flam3
wget --tries=1 --timeout=2 --output-document=electricsheep.243.!sheepFileID!.flam3 http://electricsheep.org/archive/generation-243/!sheepID!/electricsheep.243.!sheepFileID!.flam3

		SET sheepID=!nothing!
REM		ECHO emptied sheepID is !sheepID!
												)
				)

DEL random.org-sheep-gen-243-IDs.txt

ECHO OFF

ENDLOCAL