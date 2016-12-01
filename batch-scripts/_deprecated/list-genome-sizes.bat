ECHO OFF

	SETLOCAL ENABLEDELAYEDEXPANSION

IF EXIST genomeSizesList.txt DEL genomeSizesList.txt

FOR %%F IN (*.flame, *.flam3) DO	(
SET flamFile=%%F
	FOR /F "tokens=* delims=" %%W IN ('grep -P -o size^=^"^"^"[0-9]+.[0-9]+ !flamFile!') DO	(
		SET resVar=%%W
				REM trim off the front part of the string that says size=" 
		SET resVar=!resVar:~6!
		ECHO !resVar! !flamFile! >> genomeSizesList.txt
																							)
									)

	ENDLOCAL