CALL set-env

SET numRandomSheep=12
SET getGenomeBatch=fetch-random-genomes-flock-242-only.bat
REM SET getGenomeBatch=fetch-random-genomes.bat
REM NOTE that this script must depend on the preceding batch script to return a value at the last line e.g.:
REM ENDLOCAL & set broodDir=%broodDir%
REM -- and that if no such value is found by this script, it will resort to using a default brood directory of (yep) "brood."

IF "%broodDir%"=="" (
ECHO broodDir is not defined, setting to default value of brood.
SET broodDir=brood
) ELSE (
ECHO broodDir is defined as %broodDir% ; will use that directory.
)

call %getGenomeBatch%

IF NOT EXIST %broodDir% (
mkdir %broodDir%
)
cd %broodDir%
		REM DEPRECATED approach, dependent on batch scripts which at this writing (06/09/2016) I intend to rewrite:
			REM as defined above:
		REM %getGenomeBatch%
		REM IF EXIST (*.jpg, *.png) (
		REM REN *.jpg *.skp1
		REM REN *.png *.skp2
		REM call fetch-image-genomes.bat
		REM REN *.skp1 *.jpg
		REM REN *.skp2 *.png
call render-sheep-thumbs.bat
call breed-sheep.bat
cd children
call render-sheep-thumbs.bat

ECHO random fractal flames have been selected, cross-bred and thumbnails for them rendered in the current directory:
ECHO %CD%
ECHO You may wish to create a new subfolder named select_renders, copy favorite images into it, navigate there (type cd select_renders) at the command prompt, and then call select-renders.bat (to copy the "genomes" for those thumbnails for rendering into that directory, then render-sheep.bat (and perhaps rescale-sheep.sh before that). You will see your favorite selection of the fractals rendered into a subdirectory named image-output.

REM cd ..\..