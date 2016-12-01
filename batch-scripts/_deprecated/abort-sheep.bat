ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

ECHO NOTE: This batch is intended to be run from a "children" directory
ECHO in which so many genomes have been interbred.
ECHO WARNING: RUNNING THIS BATCH WILL TERMINATE ANY AND ALL .flam3 files
ECHO which have not been rendered to an image in the same directory with
ECHO the exact same name.  For example, for a flam3 file named
ECHO 202.105330_and_202.91652_alternate.flam3 for which there has not been
ECHO rendered an image named 202.105330_and_202.91652_alternate.jpg, THE
ECHO flam3 FILE WILL BE DELETED.
ECHO (This also checks for a matching .png image before deleting - and
ECHO does not delete the .flam3 file if there is a matching .png file.)

ECHO IF YOU INTEND TO DO THIS, press any key.
ECHO IF YOU DO NOT INTEND TO DO THIS, CLOSE THIS BOX.
PAUSE

IF EXIST *.jpg SET scanSheep=true
IF EXIST *.png SET scanSheep=true

IF DEFINED scanSheep					(
	SET /a scan=1
ECHO One or more jpg or png image found, parsing..
FOR /F "tokens=1 delims=" %%I in ('dir *.flam3, *.flame /b') do	(
SET sheepFileName=%%I
REM ECHO sheepFileName is %%I
REM ECHO sheepImageFile would be %%~nI.jpg ..
IF NOT EXIST %%~nI.jpg	(
	IF NOT EXIST %%~nI.png	(
ECHO no matching image file for %%I -
ECHO ABORTING SHEEP! ..
DEL %%I
				)
			)
								)
							) ELSE	(
								ECHO No images found; terminating batch.
								EXIT
								)

ECHO NOW THAT undesired children have been aborted, this batch is
ECHO ready to also abort their undesired parents.  If you wish to
ECHO do this, press any key.
ECHO IF YOU DO NOT INTEND TO DO THIS, CLOSE THIS BOX.
PAUSE

ECHO moving to parent directory..
cd..

ECHO scanning local directory for .flam3 or .flame files in format electricsheep.gen.ID..

	REM note that if either a .flam3 or .flame file exists, scanSheep will be set to
	REM true; this is effectively an OR logical operator.

IF EXIST *.flam3 SET scanFlameFiles=true
IF EXIST *.flame SET scanFlameFiles=true

IF DEFINED scanFlameFiles					(
	SET /a scan=1
ECHO One or more flam3 or flame files found, parsing..
FOR /F "tokens=2,3 delims=." %%I in ('dir *.flam3, *.flame /b') do	(
SET generation=%%I
SET sheepID=%%J
	ECHO flame file #!scan! generation is !generation!, sheepID is !sheepID!
	SET /a scan=!scan!+1
SET flameFileID=!generation!.!sheepID!
ECHO flameFileID is !flameFileID!
CD children
ECHO Searching for children bearing that genetic marker..
DIR *!flamefileID!* /b /O: A
IF !errorlevel! == 1	(
	ECHO a file with the generation and ID !flamefileID!
	ECHO was not found in the children directory; TERMINATING
	ECHO GENETICALLY WEAK PARENT.  Aaauuuugghh^^! ..
	cd ..
	DEL *!flamefileID!*
			) ELSE (
	ECHO One or more children bearing the generation and ID !flamefileID!
	ECHO was found; at least one of their parents will survive and prosper.
	cd ..
				)
									)

								) ELSE	(
								ECHO No flame files found; terminating batch.
										)


ENDLOCAL