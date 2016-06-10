ECHO OFF
	REM Either call this script with the name of a flame
	REM file - as in:
	REM 
	REM >render-sheep electricsheep.243.06597.flame
	REM 
	REM - or run it without any paramater, from a directory 
	REM with one ore more .flame or .flam3 files, as in:
	REM 
	REM >render-sheep
	REM
	REM You may also, before calling this script, set
	REM environment variables that determine the image size
	REM (ss) and quality (qs), as in:

	REM set ss=4.1015625
	REM set qs=4.3

	REM For many more details and a useful ss resolution table, see:
	REM http://richardalexanderhall.com/wiki/index.php?title=Art_production_notes
	REM For new cross-breeds and renders, see:
	REM http://richardalexanderhall.com/blog/category/art/electric-sheep/

	REM If you produce any cross-breeds you find particularly
	REM beautiful, please email the genome file(s) to:
	REM esc2012@richardalexanderhall.com
	REM for credit.

	REM BATCH SCRIPT BEGIN ==========================
	SETLOCAL ENABLEDELAYEDEXPANSION

	REM GLOBAL OPTIONS AND CODE =====================
	REM =============================================

	REM Defaults for ss and qs; from gen 202 sheep these will make 
	REM size scale 1680x1280 and quality scale 4.3x500 or 21500
IF DEFINED %ss (
REM DO NOTHING
) ELSE (
REM from an 800x592 genome (as the latest generations of sheep c. 2012 are),
REM set ss=1.3125 will make an 1680x1050 image.
REM set ss=2 will make an 2560x1600 image.
REM set ss=3 will make an 3840x2400 image.
REM set ss=3.2 will make an 4096x3072 image.
REM set ss=2
set ss=1
	)


IF DEFINED %qs (
	REM DO NOTHING
) ELSE (
set qs=11
REM set qs=4.3
REM set qs=3.2
	)

	REM alternate .png settings (for very high res masters, I prefer png with
	REM transparency - you can layer and combine it more easily with other
	REM images that way.
	REM
	set transparency=0
	set format=png
	set out=%~n1.png
	set enable_png_comments=1
	REM
IF DEFINED %format (
	REM DO NOTHING
) ELSE (
set format=jpg
set jpeg=100
	)
IF NOT EXIST image-output mkdir image-output
set enable_jpeg_comments=1
set nick=RAH
REM set url=http://richardalexanderhall.com/blog/category/art/electric-sheep/
REM set url=http://earthbound.io/blog/category/art
REM ============================================

SET det_one=%1
IF DEFINED det_one	(
			GOTO RENDER_SINGLE
			) ELSE (
				GOTO RENDER_ALL
				)


:RENDER_SINGLE

SET flamFile=%1
	CALL :SETDIMENSIONS
set out=image-output\%~n1-size!x!x!y!.!format!
	REM The following is to create a file to let other runs of the batch
	REM (say, from other computers rendering to the same directory
	REM over a network) know to *not* render this image; the check for a
	REM temp or image file of the same genome name will return true and they
	REM will skip this render command.
set tempfile=image-output\%~n1-size!x!x!y!.temp
IF NOT EXIST !out! IF NOT EXIST !tempfile! (
ECHO This is a render placeholder.  Delete it if your render is done. > !tempfile!
ECHO File !out! does not exist;
ECHO RENDERING FLAME ..
flam3-render < !flamFile!
DEL !tempfile!
			) ELSE (
			ECHO Image %out%
			ECHO already exists, SKIPPING; if you'd like to re-render it,
			ECHO delete the file and run that command again.
			ECHO =========================
				)

GOTO END


:RENDER_ALL

FOR %%F IN (*.flame, *.flam3) DO	(
SET flamFile=%%F
SET flamFileName=%%~nF
ECHO flame file is %%F
	CALL :SETDIMENSIONS
set out=image-output\!flamFileName!-size!x!x!y!.!format!
set tempfile=image-output\!flamFileName!-size!x!x!y!.temp
IF NOT EXIST !out! IF NOT EXIST !tempfile! (
ECHO This is a render placeholder.  Delete it if your render is done. > !tempfile!
ECHO File !out! does not exist;
ECHO RENDERING FLAME ..
flam3-render < !flamFile!
DEL !tempfile!
					)
	IF ERRORLEVEL 1 (
		SET renderError=true
		ECHO Problem reading flam3 file - can't render that^!
		ECHO Renaming flam3 file to .flam3-err
		REN %%F %%~nF.flam3-err
			) ELSE (ECHO File !out!
			ECHO already exists, SKIPPING; if you'd like to re-render it,
			ECHO delete the file and run this again.
			ECHO =========================
				)
					)

GOTO END


	REM ==== SUBROUTINE TO GET SIZE SETTING FROM FLAME FILE AND CALCULATE SIZE
	REM ==== OF OUTPUT IMAGE BY MULTIPLYING THE X AND Y DIMENSIONS AGAINST ss
	REM=======================================================================
	REM Using GNU grep 2.5.4.3331 as ported to windows;
	REM FROM THE COMMAND, this works: grep -P -o "(?<=size=""")[0-9]+" electricsheep.243.06908.flam3
	REM and so does this: grep -P -o "(?<=size=""")[0-9]+ [0-9]+" electricsheep.243.06908.flam3
	REM but from a batch file, with the command being parsed by a FOR loop, it's a different story -
	REM -those don't work that way, and you have to find the right escape sequences for certain
	REM characters in the command.  And for some reason, if you enclose the entire command in
	REM double-quotes so that it will include the space character I want in that second regexp,
	REM those escape characters don't work any more - and I can't find anything else that does.
	REM Solution: don't surround in quotes, and use . ("any character") to represent the space in
	REM the regexp - and when I do *that*, I can't seem to get the positive lookbehind part,
	REM (?<=size=""" to work, so the whole thing is returned as:
	REM size="800 592
	REM (Or whatever numbers happen to be after size=")
	REM This is clugy-ish, but I can work with that by trimming size=" off the result, then
	REM using space ( ) as a delimiter to parse that result.

			REM This SETDIMENSIONS process relies on the flamFile global variable.
	:SETDIMENSIONS

			REM To recreate this file as empty
	ECHO OFF > genomeSize.txt

	FOR /F "tokens=* delims=" %%W IN ('grep -P -o size^=^"^"^"[0-9]+.[0-9]+ !flamFile!') DO	(
	SET resVar=%%W
												)
			REM trim off the front part of the string that says size=" 
	SET resVar=!resVar:~6!
		ECHO File scan gives genome resolution as !resVar!
	ECHO !resVar! > genomeSize.txt

	FOR /F "tokens=1,2 delims= " %%X IN (genomeSize.txt) DO	(
	SET x=%%X
	SET y=%%Y
		REM ECHO Image size dimension x is !X!
		REM ECHO Image size dimension y is !Y!
								)

REM ECHO about to delete genomeSize.txt...
 	DEL genomeSize.txt

		REM Decimal arithmetic done with free command line tool math.exe (see MATHDOC.TXT for source).
		REM This arimthmetic could be done with the Windows' command line SET command and /a switch, but
		REM that only does integer arithmetic, and we need decimal arithmetic capability.
FOR /F %%N in ('MATH.EXE /n !x!*!ss!') do set x=%%N
	REM ECHO ss is %ss%
	REM ECHO After multiplication by ss, x is !x!
		REM if that turns out to be a decimal number, we need to turn it to an integer with the next command...
		REM note, in the next command, the use of the carat ^ symbol as an "escape" character for the
		REM parenthesis() needed by MATH.EXE's round function. For example you could run "MATH.EXE round(3708.8)"
		REM from the command line to obtain 3708, but this FOR loop's paramaters, in parenthesis, get confused with
		REM the parenthesis in that MATCH.EXE round function--to tell the command line to ignore the inner
		REM parenthesis as having nothing to do with the parenthesis for the FOR loop, the carat ^ escape
		REM symbol is used. See http://en.wikipedia.org/wiki/Escape_character#Windows_Command_Prompt
FOR /F %%N in ('MATH.EXE /n round^(!x!^)') do set x=%%N
	REM ECHO After rounding, x is !x!
	REM ECHO y is !y!
		REM The same comments as just above apply here.
FOR /F %%N in ('MATH.EXE /n !Y!*!ss!') do set Y=%%N
	REM ECHO After multiplication by ss, y is !y!
FOR /F %%N in ('MATH.EXE /n round^(!y!^)') do set y=%%N
	REM ECHO After rounding, y is !y!
	ECHO Output image size times ss scale multiplier (!ss!, with the result rounded if necessary) will be !x!x!y! ...

	IF !x!==0 IF !y!==0	(
	ECHO The size of the image was incorrectly
	ECHO calculated as 0 x 0.  cc.exe may be missing
	ECHO from the bin folder; re-extract auto-brood.zip.
				) ELSE (
	ECHO Size of image times ss will be !x! x !y! ..
					)

	:EXIT


:END

IF DEFINED renderError	(
	REM Do nothing except print..
	ECHO ========================
	ECHO NOTE
	ECHO ========================
	ECHO During rendering one or more .flam3 files wouldn't render
	ECHO via flam3-render.exe, and these have been renamed to
	ECHO .flam3-err files.  
	ECHO ========================
	ECHO ALSO NOTE
	ECHO ========================
	ECHO If the system couldn't find flam3-render.exe, that will have
	ECHO registered a variable with this script which would, mistakenly,
	ECHO FALSELY rename .flam3 files to .flam3-err.
	ECHO If you know the .flam3 files can actually be, rendered,
	ECHO or if you want to keep anyway, run revert-flam3-file.bat, to
	ECHO revert them to their original name.
	ECHO If on the other hand you don't want the flam3-err files,
	ECHO run del-flam3-err.bat to delete them.
	ECHO ========================
			)

ENDLOCAL