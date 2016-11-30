# DESCRIPTION
# Moves any image-matched .flame or .flam3 genomes (from one to four directories up or down) into the folder from which this script is run.

# USAGE
# Optional parameter: $1 an image format (e.g. jpg) to scan for. Defaults to png if not present.


if [ ! -z ${1+x} ]
	then
		imgFormat=$1
		echo Paramater 1 passed\, scanning for image format $imgFormat
	else
		echo No paramater 1 passed\, defaulting to image format png
		imgFormat=png
fi


CygwinFind *.$imgFormat > allFilesNoExt.txt

sed -i "s/\(.*\)\.$imgFormat/\1/g" allFilesNoExt.txt

echo Scanning parent directories \(up to three levels up\) for corresponding sheep genome files\; also any directory down . . .

mapfile -t imgFiles < allFilesNoExt.txt

for element in ${imgFiles[@]}
do
	# search down directories and moving file here if it exists; re a genius breath yon: http://stackoverflow.com/a/37012114
	find ./ -name "$element" -exec mv '{}' './' ';'

	# search up directories and move the applicable file here if it exists:
	if [ -e ../$element ]
		then
			echo running mv -f ../$element ./
			mv -f ../$element ./
	fi
	if [ -e ../../$element ]
		then
			echo running mv -f ../../$element ./
			mv -f ../../$element ./
	fi
	if [ -e ../../../$element ]
		then
			echo running mv -f ../../../$element ./
			mv -f ../../../$element ./
	fi
	if [ -e ../../../../$element ]
		then
			echo running mv -f ../../../../$element ./
			mv -f ../../../../$element ./
	fi
done


rm allFilesNoExt.txt