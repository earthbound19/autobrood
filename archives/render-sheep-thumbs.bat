ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

	REM If ss and qs values are set, back them up into
	REM temporary variables for later restoration
	REM because we are going to change them temporarily.
	IF DEFINED ss SET tempSS=%ss%
	IF DEFINED qs SET tempQS=%qs%

SET ss=.17
SET qs=.17
set format=jpg
set jpeg=60
set enable_jpeg_comments=1
set nick=openhatch
set url=http://openhatch.net

FOR %%S IN (*.flame, *.flam3) DO	(
set out=%%~nS.jpg
IF EXIST !out! (
ECHO Thumbnail or larger render of %%~nS
ECHO already exists;
ECHO SKIPPING..
ECHO ========================
) ELSE	(
ECHO No thumbnail or larger render for %%~nS
ECHO RENDERING SINGLE FLAME..
flam3-render < %%S
IF ERRORLEVEL 1 (
	SET renderError=true
	ECHO Problem reading flam3 file - can't render that^!
	ECHO Renaming flam3 files to .flam3-err
	REN %%S %%~nS.flam3-err
		)

ECHO ========================
	)
					)

IF DEFINED renderError	(
ECHO ========================
ECHO NOTE
ECHO ========================
ECHO During rendering one or more .flam3 files wouldn't render
ECHO via flam3-render.exe, and these have been renamed to
ECHO .flam3-err files.  If you don't like that, copy to here and run
ECHO revert-flam3-file.bat, to revert them to their original name.
ECHO If on the other hand you want don't want the unuseable files,
ECHO copy to here and run del-flam3-err.bat to delete them.
ECHO ========================
			)

	REM If there were ss and qs valueS, restore them.
	IF DEFINED tempSS SET ss=%tempSS%
	IF DEFINED tempQS SET qs=%tempQS%

ENDLOCAL