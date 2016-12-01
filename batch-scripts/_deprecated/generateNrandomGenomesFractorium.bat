ECHO OFF
REM DESCRIPTION: invokes EmberGenome.exe n times (by parameter) to create new random genomes.

REM USAGE: run this script with one paramater, being the number of new random fractal flames to make.

SETLOCAL ENABLEDELAYEDEXPANSION

REM Because EmberGenome expects the pallete file to be in the same path its run from:
COPY C:\autobrood\bin\fractorium_openCL_GPU_fractal_flames\flam3-palettes.xml

FOR /L %%I IN (1, 1, %1) DO (
  REM ECHO %%I
	set mydate=!date:~10,4!_!date:~7,2!_!date:~4,2!
	set mytime=!time:~0,2!_!time:~3,2!_!time:~6,2!_!time:~9,2!
	set flameFileName=!mydate!__!mytime!__%%I.flame
	echo creating flameFileName=!mydate!__!mytime!__%%I.flame . . .
	EmberGenome.exe --nick=earthbound --tries=2000 > !flameFileName!
)

DEL flam3-palettes.xml

ENDLOCAL

REM DEVELOPMENT HISTORY
REM 2016-06-21
REM Necessary on systems where for whatever reason .sh scripts in cygwin misbehave (so that the .sh version of this script can be run.) v1 Feature complete.