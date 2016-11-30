REM TO DO? Since the only alteration to this script is changing the invoked exe and one parameter, change the original script this is based on to use one or the other exe (and appropriate parameter), depending? UGH--and this has to have the according ~palette.xml here, then, there.

ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST children mkdir children
SET nick=earthbound
SET url=http://earthbound.io

COPY C:\autobrood\bin\flam3-palettes.xml

FOR %%S IN (*.flame, *.flam3) DO	(
SET cross0=%%S
REM TO DO: NO, no no! Renaming that file is a bad idea! I accidentally deleted some genomes which are unrecoverable because I thought the .breeding temp file was a temp, empty text file! It was a genome! REWRITE this to echo to an empty .breeding temp file and to scan for that before rendering. No, forget it. I'll just change that to a copy command, and the user must know to delete these mysterious .breeding extra files after.
CP !cross0! %%~nS.breeding
SET cross0=%%~nS.breeding
SET outname1=%%~nS
SET outname1=!outname1:electricsheep.=!
	FOR %%H in (*.flame, *.flam3) DO	(
		REM cross0 was set just before this FOR .. DO loop.
	SET cross1=%%H
	SET outname2=%%~nH
	SET outname2=!outname2:electricsheep.=!

	REM 	this is to preserve a method environment variable
	REM 	if it is already set to something else
	REM 	(so that the below won't change it against
	REM 	the user's will)
	SET local_method=%3

SET method=union
IF NOT EXIST children\!outname1!_and_!outname2!_!method!.flam3 (
ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO does not exist, BREEDING SHEEP..
EmberGenome > children\!outname1!_and_!outname2!_!method!.flam3
ECHO DONE.
) ELSE ( ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO already exists, SKIPPING..
)
ECHO ================

SET method=alternate
IF NOT EXIST children\!outname1!_and_!outname2!_!method!.flam3 (
ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO does not exist, BREEDING SHEEP..
EmberGenome > children\!outname1!_and_!outname2!_!method!.flam3
ECHO DONE.
) ELSE ( ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO already exists, SKIPPING..
)
ECHO ================

SET method=interpolate
SET tries=100001
IF NOT EXIST children\!outname1!_and_!outname2!_!method!.flam3 (
ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO does not exist, BREEDING SHEEP..
EmberGenome > children\!outname1!_and_!outname2!_!method!.flam3
ECHO DONE.
) ELSE ( ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO already exists, SKIPPING..
)
ECHO ================

	REM restoring method environment variable if it
	REM had been set
	IF DEFINED local_method set method=!local_method!
							)
						)

REM REN *.breeding *.flam3

ENDLOCAL

DEL flam3-palettes.xml