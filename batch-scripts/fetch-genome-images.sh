# USAGE:
# Optional parameter: $1 an image format (e.g. jpg) to scan for. Defaults to png if not present.

if [ ! -z ${1+x} ]
	then
		imgFormat=$1
		echo Paramater 1 passed\, scanning for image format $imgFormat
	else
		imgFormat=png
fi


CygwinFind *.flame > allFiles.txt
CygwinFind *.flam3 >> allFiles.txt

mapfile -t seekIMGfiles < allFiles.txt

for element in ${seekIMGfiles[@]}
do
			# echo searching for ../$element.$imgFormat
		if [ -e ../$element.$imgFormat ]
			then
				echo running mv -f ../$element.$imgFormat ./
				mv -f ../$element.$imgFormat ./
		fi
			# echo searching for ../../$element.$imgFormat
		if [ -e ../../$element.$imgFormat ]
			then
				echo running mv -f ../../$element.$imgFormat ./
				mv -f ../../$element.$imgFormat ./
		fi
			# echo searching for ../../../$element.$imgFormat
		if [ -e ../../../$element.$imgFormat ]
			then
				echo running mv -f ../../../$element.$imgFormat ./
				mv -f ../../../$element.$imgFormat ./
		fi
			# echo searching for ../../../../$element.$imgFormat
		if [ -e ../../../../$element.$imgFormat ]
			then
				echo running mv -f ../../../../$element.$imgFormat ./
				mv -f ../../../../$element.$imgFormat ./
		fi		
done


rm allFiles.txt