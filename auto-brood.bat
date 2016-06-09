CALL set-env

SET numRandomSheep=12
SET getGenomeBatch=fetch-random-genomes-flock-242-only.bat
REM SET getGenomeBatch=fetch-random-genomes.bat

IF NOT EXIST brood mkdir brood
cd brood
	REM as defined above:
call %getGenomeBatch%
IF EXIST (*.jpg, *.png) (
REN *.jpg *.skp1
REN *.png *.skp2
call fetch-image-genomes.bat
REN *.skp1 *.jpg
REN *.skp2 *.png
call render-sheep-thumbs.bat
call breed-sheep.bat
cd children
call render-sheep-thumbs.bat
cd ..\..