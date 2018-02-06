# IN DEVELOPMENT

# DESCRIPTION
# Splits all files of type T (via parameter $1) by count N (via parameter $2) into subfolders named by division and frame. Intended e.g. for splitting rendered fractal flame loop animations from one more lengthy sequence (e.g. from an _alles_anim.flam3 file generated via createSheepAnim.sh) into individual loop anims which can be concatenated via concatVidFiles.sh.

# USAGE
# e.g.:
# thisScript.sh png 126
# NOTE: this looks for a file ../../ANIM_INFO.txt (two directories up) and automatically sets param. 2 from that if no parameter $2 is provided. It also defaults to png if no parameter $1 is provided.

# TO DO: abridge / integrate the following notes from a previous script:
		# Given a sequence of specifically named 7-digit animation images, render lossless .avi and high-quality lossy .mp4 (with AVC) animation segment videos which can later be strung together losslessly via e.g. concatVidFiles.sh. Originally specifically designed for file names/numbering of fractal flame animation image sequences generated via createSheepAnim.sh and render-flames-fractorium.sh.
		# USAGE:
		# Call this script from a directory full of so rendered and so named animation files. This only renders target avi and mp4 files if they do not already exist, and will re-render target files wherever there is a gap in the target .mp4 files sequence. NOTE: If this script is interrupted and resumed, it attempts to move the image files back up from the ./frames_sort directory into which they were moved--it attempts to move those image files back up to the root of the path from which this script was run (and is run again). ALSO NOTE: it expects frame numbering to start with 1.
		# ALSO NOTE: this script assumes it is running in a render output folder two directories down from one ANIM_INFO.txt file, which file gives the number of frames per fractal flame loop animation in a sequence. It assigns a global script variable from that information.

if [ ! -z ${1+x} ]; then axeThisFormat=$1; fi
if [ ! -z ${2+x} ]; then n_frames_per_seq=$2; fi


# a prior method of checking for variable defined-ness and initialization failed here; but this works re: http://stackoverflow.com/a/27110943
if ! [[ ${n_frames_per_seq:+1} ]]
	then
				# echo ist nicht.
		# If variable is not defined or is empty that if check will return true; in that case this block will be executed. Otherwise this block will not be executed (and the already initialized value of n_frames_per_seq will be used).
		# SET GLOBAL VAR:
		if [ -e ../../ANIM_INFO.txt ]; then ANIM_INFO_path=../../ANIM_INFO.txt; fi
		if [ -e ../ANIM_INFO.txt ]; then ANIM_INFO_path=../ANIM_INFO.txt; fi
		if [ -e ./ANIM_INFO.txt ]; then ANIM_INFO_path=./ANIM_INFO.txt; fi
				# echo ANIM_INFO_path value is\:
				# echo $ANIM_INFO_path
		if [ -z ${ANIM_INFO_path:+1} ]; then echo ANIM_INFO.txt not found in this path or the two paths above\; please invoke this script again with one parameter\, being the frame count per anim loop\, or create said file.; exit; fi

		n_frames_per_seq=$(< ../../ANIM_INFO.txt)
		n_frames_per_seq=`echo $n_frames_per_seq | sed 's/.*\: \([0-9]\{1,\}\).*/\1/g'`
		echo Frames per sequence taken from ../../ANIM_INFO.txt is\: $n_frames_per_seq
	else
		echo using frames per anim loop variable of\: $n_frames_per_seq as passed by parameter \$2 . . .
fi

		# echo n_frames_per_seq val is\: $n_frames_per_seq

echo Listing files of format $axeThisFormat in current directory . . .
find *.$axeThisFormat > frames_list.txt
mapfile -t frames_list < frames_list.txt
arraySize=$(wc -l < frames_list.txt)
	rm frames_list.txt
numDigitsOf_arraySize=${#arraySize}
		# echo numDigitsOf_arraySize val is\: $numDigitsOf_arraySize
		# echo countString val is\: $countString


# arrSize=${#frames_list[@]}

multipleCount=0
fileCount=0
multiple=$n_frames_per_seq
for element in ${frames_list[@]}
do
	fileCount=$[fileCount + 1]
			echo fileCount is $fileCount
	moduloResult=`expr $multiple % $n_frames_per_seq`
			echo moduloResult val is\: $moduloResult
	if (( moduloCheck == 0 ))
	then
		multipleCount=$[multipleCount + 1]
				echo multipleCount is $multipleCount
		multiple=`expr $multipleCount * $n_frames_per_seq`
				echo multiple val is\: $multiple
		folderNameDigits=`printf "%0""$numDigitsOf_arraySize""d\n" $multiple`
				echo val of folderNameDigits is\: $folderNameDigits
		if [ ! -d ./_toEndFR_$folderNameDigits ]
		then
				echo Creating dir ./_toEndFR_$folderNameDigits . . .
			mkdir ./_toEndFR_$folderNameDigits
		fi
	fi
	echo Running command\: mv $element ./_toEndFR_$folderNameDigits/
	# mv $element ./_toEndFR_$folderNameDigits/
	toEndFrameCount=$[toEndFrameCount + 1]
done