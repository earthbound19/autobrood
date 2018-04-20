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

	REM the following pulls the status of sheep GENERATION 243 from the sheep server to a text file.
	wget --tries=1 --timeout=2 --output-document=gen-243-fetched-status.txt http://v2d7b.sheepserver.net/gen/fresh_sheep.html
		REM wget saves an empty file if the server doesn't respond.  This check deletes the empty file
		REM to cue other parts of the script to set dependent variables to defaults.
	FOR /F "delims=" %%S in (gen-243-fetched-status.txt) DO	(
	SET testContent=%%S
											)
	IF NOT DEFINED testContent DEL gen-243-fetched-status.txt

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

	REM the following loop finds the highest sheep ID in the status.cgi file pulled
	REM from the sheep server for GENERATION 243.
IF EXIST gen-243-fetched-status.txt	(
FOR /F "usebackq tokens=3 delims==>" %%S in (`FINDSTR /R /I /C:node.cgi?id=[0-9]* gen-243-fetched-status.txt`) DO	(
				SET /a comp243found=%%S
REM				ECHO comp243found is !comp243found!
				IF !comp243found! GTR !gen243found! SET /a gen243found=!comp243found!
REM				ECHO gen243found ID is !gen243found!
			)
						)

ECHO ===========================================================================
IF NOT EXIST gen-202-fetched-status.txt (
ECHO Unable to fetch newest generation 202 sheep ID from server - 
ECHO arbitrarily setting to 138174, the newest sheep found at about
ECHO the time this script was finalized, May 09'
SET gen202found=134709
							) ELSE (
DEL gen-202-fetched-status.txt
ECHO Highest or newest found sheep ID for generation 202 is !gen202found! -
								)
ECHO Highest or newest sheep ID for dead generation 242 is 3595 -
IF NOT EXIST gen-243-fetched-status.txt (
ECHO Unable to fetch newest generation 243 sheep ID from server - 
ECHO arbitrarily setting to 15390, the newest sheep found at about
ECHO the time this script was finalized, May 09'
SET gen243found=13742
							) ELSE (
DEL gen-243-fetched-status.txt
ECHO Highest or newest found sheep ID for generation 243 is !gen243found! -
								)

ECHO ===========================================================================

REM ============================================================================
REM ====SETUP FOR HOW MANY RANDOM SHEEP FROM EACH GENERATION WILL BE SELECTED===
REM 
REM This dandy little mess sets how many sheep from each flock will be randomly
REM chosen.
REM ============================================================================

IF NOT DEFINED numRandomSheep SET /A numRandomSheep=13

wget --tries=1 --output-document=total-generation-202-sheep.txt http://www.random.org/cgi-bin/randnum?num=1^&min=1^&max=!numRandomSheep!^&col=1^&base=10^&format=plain^&rnd=new
	FOR /F "delims=" %%N IN (total-generation-202-sheep.txt) DO SET /A subtractNum=%%N
	DEL total-generation-202-sheep.txt
	SET num202Sheep=!subtractNum!
REM		ECHO num202Sheep is !num202Sheep!
REM		ECHO numRandomSheep before subtraction is !numRandomSheep!
	SET /A numRandomSheep=numRandomSheep-!subtractNum!
REM		ECHO numRandomSheep after subtraction is !numRandomSheep!
		ECHO =========================================================================
		ECHO Number of generation 202 randomly drawn sheep will be !num202Sheep!
		ECHO =========================================================================
IF !numRandomSheep! GTR 0	(
wget --tries=1 --output-document=total-generation-242-sheep.txt http://www.random.org/cgi-bin/randnum?num=1^&min=1^&max=!numRandomSheep!^&col=1^&base=10^&format=plain^&rnd=new
		FOR /F "delims=" %%N IN (total-generation-242-sheep.txt) DO SET /A subtractNum=%%N
		DEL total-generation-242-sheep.txt
		SET num242Sheep=!subtractNum!
REM		ECHO num242Sheep is !num242Sheep!
REM			ECHO numRandomSheep before subtraction is !numRandomSheep!
		SET /A numRandomSheep=numRandomSheep-!subtractNum!
REM			ECHO numRandomSheep after subtraction is !numRandomSheep!
			ECHO =========================================================================
			ECHO Number of generation 242 randomly drawn sheep will be !num242Sheep!
			ECHO =========================================================================		
					)
	IF !numRandomSheep! GTR 0	(
				SET num243Sheep=!numRandomSheep!
REM				ECHO num243Sheep is !num243Sheep!
				ECHO =========================================================================
				ECHO Number of generation 243 randomly drawn sheep will be !num243Sheep!
				ECHO =========================================================================
						)

REM To keep a log of randomly chosen numbers.
IF NOT EXIST random-sheep-log.txt	(
ECHO OFF > random-sheep-log.txt
					) ELSE (
					REM Do nothing
						)


REM  ===========================================================================
REM  =============SHEEP GENERATION 202 RANDOM FETCHING SECTION==================
REM  ===========================================================================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 202.
	REM 	The base format for this is: http://www.random.org/integers/?num=6&min=1&max=134344&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

IF !num202Sheep! NEQ 0	(
ECHO ===========================================================================
ECHO Fetching !num202Sheep! purely random sheep IDs from flock 202 in range 1 to !gen202found!..
ECHO ===========================================================================

wget --tries=1 --output-document=random.org-sheep-gen-202-IDs.txt http://www.random.org/cgi-bin/randnum?num=!num202Sheep!^&min=1^&max=!gen202found!^&col=!num202Sheep!^&base=10^&format=plain^&rnd=new

	REM The following downloads sheep IDs correlating to the previous generation 202 random ID list downloaded.

FOR /F "delims=" %%S in (random.org-sheep-gen-202-IDs.txt) DO	(
SET sheepID=%%S
	ECHO Random number is !sheepID!.
	ECHO 202.!sheepID! >> random-sheep-log.txt
	ECHO fetching sheep 202.!sheepID! from http://sheepserver.net/v2d6/gen/202/!sheepID!/spex
wget --tries=1 --output-document=electricsheep.202.!sheepID!.flam3 http://sheepserver.net/v2d6/gen/202/!sheepID!/spex
											)
				)

REM  ===========================================================================
REM  =============SHEEP GENERATION 242 RANDOM FETCHING SECTION==================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 242.
	REM 	The base format for this is: http://www.random.org/integers/?num=6&min=1&max=3595&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

IF !num242Sheep! NEQ 0	(
ECHO ===========================================================================
ECHO Fetching !num242Sheep! purely random sheep IDs from dead flock 242 in range 1 to 3595..
ECHO ===========================================================================

wget --tries=1 --output-document=random.org-sheep-gen-242-IDs.txt http://www.random.org/cgi-bin/randnum?num=!num242Sheep!^&min=1^&max=3595^&col=!num242Sheep!^&base=10^&format=plain^&rnd=new

	REM The following downloads sheep IDs correlating to the previous generation 242 random ID list downloaded.

FOR /F "delims=" %%S in (random.org-sheep-gen-242-IDs.txt) DO	(
SET sheepID=%%S
	ECHO Random number is !sheepID!.
	ECHO 242.!sheepID! >> random-sheep-log.txt
	ECHO fetching sheep 242.!sheepID! from http://electricsheep.org/archive/generation-242/!sheepID!/spex
wget --tries=1 --output-document=electricsheep.242.!sheepID!.flam3 http://electricsheep.org/archive/generation-242/!sheepID!/spex
											)
				)

REM  ===========================================================================
REM  =============SHEEP GENERATION 243 RANDOM FETCHING SECTION==================
REM  ===========================================================================

	REM	The following pulls new, true random numbers from random.org within the ID number range of the
	REM	sheep flock for GENERATION 243.
	REM 	The base format for this is: http://www.random.org/integers/?num=!gen243found!&min=1&max=!gen243found!&col=6&base=10&format=plain&rnd=new
	REM 	Note that in the version below there is a carat ^ before each ampersand &.  This is because
	REM 	in a batch file the ampersand & is a command; we want it to be interpreted as part of the longer
	REM 	string and not a command, so it is "escaped" by placing the carat ^ before it.

IF !num243Sheep! NEQ 0	(
ECHO ===========================================================================
ECHO Fetching !num243Sheep! purely random sheep IDs from flock 243 in range 1 to !gen243found!..
ECHO ===========================================================================

wget --tries=1 --output-document=random.org-sheep-gen-243-IDs.txt http://www.random.org/cgi-bin/randnum?num=!num243Sheep!^&min=1^&max=!gen243found!^&col=!num243Sheep!^&base=10^&format=plain^&rnd=new

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
	ECHO fetching sheep 243.!sheepID! from http://v2d7b.sheepserver.net/gen/243/!sheepID!/electricsheep.243.!sheepFileID!.flam3
wget --tries=1 --timeout=2 --output-document=electricsheep.243.!sheepFileID!.flam3 http://v2d7b.sheepserver.net/gen/243/!sheepID!/electricsheep.243.!sheepFileID!.flam3

		SET sheepID=!nothing!
REM		ECHO emptied sheepID is !sheepID!
												)
				)


DEL random.org-sheep-gen-202-IDs.txt
DEL random.org-sheep-gen-242-IDs.txt
DEL random.org-sheep-gen-243-IDs.txt

ECHO OFF

ENDLOCAL