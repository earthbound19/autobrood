ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM This script is a copy of fetch-image-genomes.bat with an echo > %1.gentemp hack
REM and then tempfile delete - to let the same routine work off a temporary file
REM which is named after %1 (because so far as I know, FOR only works on a found
REM filename?)

REM Copy PATH environment variable to temporary local variable
REM so that we can wipe it out with only the path of *this* directory
REM and then restore it to what it was. (Do terminated batches do that
REM anyway?)

ECHO scanning local directory for sheep image files in format electricsheep.gen.ID..

	REM note that if either a .jpg or .png file exists, scanSheep will be set to
	REM true; this is effectively an OR logical operator.

set var=%1
IF DEFINED %var SET scanSheep=true

IF DEFINED scanSheep					(
	SET /a scan=1
	echo > %1.gentemp
ECHO One or more jpg or png image found, parsing..
FOR /F "tokens=1,2 delims=." %%I in ('dir *.gentemp /b') do	(
	del %1.gentemp
SET generation=%%I
SET sheepID=%%J
	ECHO image#!scan! generation is !generation!, sheepID is !sheepID!
	SET /a scan=!scan!+1
SET checkID=!sheepID:~0,1!
IF !checkID! == 0 (
echo leading zero on sheepID !sheepID!, parsing out..
SET sheepID=!sheepID:~1!
echo sheepID trimmed to !sheepID!
			)


	IF !generation!==202	(
	SET genomePath=http://electricsheep.org/archive/generation-202
	SET fullGenomeURL=!genomePath!/!sheepID!/spex

				)
	IF !generation!==242	(
	SET genomePath=http://electricsheep.org/archive/generation-242
	SET fullGenomeURL=!genomePath!/!sheepID!/electricsheep.!generation!.0!sheepID!.flam3
				)
	IF !generation!==243	(
	SET genomePath=http://electricsheep.org/archive/generation-243
	SET fullGenomeURL=!genomePath!/!sheepID!/electricsheep.!generation!.0!sheepID!.flam3
					)

SET sheepfile=electricsheep.!generation!.!sheepID!.flam3
IF EXIST !sheepfile! (
	ECHO matching flame file found: !sheepfile!
	) ELSE (
	ECHO matching flame file not found - fetching !sheepfile! ..
	ECHO genomePath is !genomePath!
	ECHO full genome URL is !fullGenomeURL!
	wget.exe -nc --progress=bar --tries=1 --output-document=!sheepfile! !fullGenomeURL!
		)
											)

								) ELSE	(
								ECHO No sheep paramater passed; terminating batch.
										)

ENDLOCAL