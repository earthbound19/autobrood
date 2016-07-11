SETLOCAL ENABLEDELAYEDEXPANSION

ECHO OFF

REM This batch is for ease of rendering larger electric sheep images by selection and copy of a few sheep thumbnail images to a subdirectory.

REM USAGE: If you've run render-sheep-thumbs in a directory full of genome files, you'll have a lot of thumbnail preview images that will give you an idea what a full-scale render from a genome might look like. You could run render-sheep to render every genome in the directory to full-scale renders, but considering that you may not love all those genomes (or the thumbnail previews of them), that could be wasteful. Instead, copy the thumbnails for the genomes you love into a sub-directory of your naming ("select-renders" is suggested). Then from the command prompt (with the auto-brood batches properly set up in your PATH--refer to the README.TXT for auto-brood about that), go into that subdirectory and run this batch. It will look, in the directory above, for corresponding genome names for every image name in this directory, and copy those genomes here. You may then render all of those genomes in higher-quality images by calling render-sheep.bat.
REM NOTE that if you run render-sheep.bat in your subdirectory of selected images/genomes, it will create an "image-output" sub-sub-directory--which I suggest you'll want to just copy to the directory above, and then delete the sub-directory of copied, select images and genomes.

FOR %%F IN (*.jpg, *.png) DO	(
SET flamImageFile=%%F
SET flamImageFileName=%%~nF
ECHO Image file is %%F, so genome file name is hopefully either !flamImageFileName!.flam3 or !flamImageFileName!.flame . . .
ECHO Retrieving genome . . .
IF NOT EXIST !flamImageFileName!.flam3 COPY ..\!flamImageFileName!.flam3
IF NOT EXIST !flamImageFileName!.flame COPY ..\!flamImageFileName!.flame
					)

ECHO Don't be alarmed if this script threw a lot of errors about not finding files; it probably attempted to copy many files which do not exist.
					
ENDLOCAL