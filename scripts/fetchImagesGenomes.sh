# DESCRIPTION
# Moves any image-matched .flame or .flam3 genomes (from one to four directories up or down) into the folder from which this script is run.

# USAGE
# Optional parameter: $1 an image format (e.g. jpg) to scan for. Defaults to png if not present.

# TO DO
# Have this look for filename.ext.what and filename.what? Re-tool this to only search for what results from `fileNameNoExt=${filename%.*}` when I update all scripts to do that?


# CODE
if [ ! -z ${1+x} ]
	then
		imgFormat=$1
		echo Paramater 1 passed\, scanning for image format $imgFormat
	else
		echo No paramater 1 passed\, defaulting to image format png
		imgFormat=png
fi

find . -maxdepth 1 -iname \*.$imgFormat > imgFiles.txt
echo Scanning parent directories \(up to three levels up\) for corresponding sheep genome files\; also any directory down . . .

while read element
do
	# trim any ./ off the start of the file name:
	element=`echo $element | sed "s/\.\/\(.*\)\.$imgFormat/\1/g"`
	echo that is $element
	# search down directories and moving file here if it exists; re a genius breath yon: http://stackoverflow.com/a/37012114
# find ./ -name "$element" -exec mv '{}' './' ';'
# TO DO: fix probs. with that; see comments in fetchGenomesImages.sh

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
done < imgFiles.txt

rm ./imgFiles.txt