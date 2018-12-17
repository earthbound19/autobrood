# DESCRIPTION
# Extracts all flam3_genome tags (genome information) from all .png renders in a directory as saved via the "Keep rendered frames" Electric Sheep settings, saving them to .flame files named after the source render image. .flame files are saved alongside the original images.

# USAGE
# ./thisScript.sh

# DEPENDENCIES
# A 'nixy environment and exiftool.


# CODE
# NOTES: The flam3_genome tag name was found (in a .png image render saved from the running electric sheep screensaver) via:
# exiftool -s -flam3_genome sheep_247_32990_478.png > hyarf.txt

# Create an array of all png file names in the current directory:
array=(`gfind . -maxdepth 1 -iname \*.png -printf '%f\n' | sort`)
for element in ${array[@]}			# iterate over all items in array
do
	fileNameNoExt=${element%.*}
	# If target genome does not already exist, create it. Otherwise don't overwrite it.
	if [ ! -e $fileNameNoExt.flame ]
	then
		echo "Extracting (hopefully) genome from source file $element and saving to $fileNameNoExt.flame . . ."
		exiftool -b -flam3_genome $element > $fileNameNoExt.flame
	else
		echo "Target genome file $fileNameNoExt.flame already exists; will not overwrite it; SKIPPING . . ."
	fi
done

echo DONE.