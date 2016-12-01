REM NOTE: this batch may be outdated via outdated URLs.

ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM Copy PATH environment variable to temporary local variable
REM so that we can wipe it out with only the path of *this* directory
REM and then restore it to what it was. (Do terminated batches do that
REM anyway?)

ECHO scanning local directory for sheep image files in format electricsheep.gen.ID..

	REM note that if either a .jpg or .png file exists, scanSheep will be set to
	REM true; this is effectively an OR logical operator.

IF EXIST *.jpg SET scanSheep=true
IF EXIST *.png SET scanSheep=true

IF DEFINED scanSheep					(
	SET /a scan=1
ECHO One or more jpg or png image found, parsing..
FOR /F "tokens=2,3 delims=." %%I in ('dir *.jpg, *.png /b') do	(
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
	SET genomePath=http://sheepserver.net/v2d6/gen/202
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
								ECHO No images found; terminating batch.
										)

ENDLOCAL