ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST children mkdir children
SET nick=earthbound
SET url=http://earthbound.io

FOR %%S IN (*.flame, *.flam3) DO	(
SET cross0=%%S
REN !cross0! %%~nS.breeding
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
flam3-genome > children\!outname1!_and_!outname2!_!method!.flam3
ECHO DONE.
) ELSE ( ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO already exists, SKIPPING..
)
ECHO ================

SET method=alternate
IF NOT EXIST children\!outname1!_and_!outname2!_!method!.flam3 (
ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO does not exist, BREEDING SHEEP..
flam3-genome > children\!outname1!_and_!outname2!_!method!.flam3
ECHO DONE.
) ELSE ( ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO already exists, SKIPPING..
)
ECHO ================

SET method=interpolate
IF NOT EXIST children\!outname1!_and_!outname2!_!method!.flam3 (
ECHO children\!outname1!_and_!outname2!_!method!.flam3
ECHO does not exist, BREEDING SHEEP..
flam3-genome > children\!outname1!_and_!outname2!_!method!.flam3
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

REN *.breeding *.flam3

ENDLOCAL