# DESCRIPTION:
# Given a sequence of specifically named 7-digit animation images, render lossless .avi and high-quality lossy .mp4 (with AVC) animation segment videos which can later be strung together losslessly via e.g. concatVidFiles.sh. Originally specifically designed for file names/numbering of fractal flame animation image sequences generated via createSheepAnim.sh and render-flames-fractorium.sh.

# USAGE:
# Call this script from a directory full of so rendered and so named animation files. This only renders target avi and mp4 files if they do not already exist, and will re-render target files wherever there is a gap in the target .mp4 files sequence. NOTE: If this script is interrupted and resumed, it attempts to move the image files back up from the ./frames_sort directory into which they were moved--it attempts to move those image files back up to the root of the path from which this script was run (and is run again). ALSO NOTE: it expects frame numbering to start with 1.

# TO DO:
# make n_frames_per_seq optionally parameterized, with a default.
# explain wt this script does, etc.
# make this work in harmony with render-flames-anim-fractorium.sh ?
# make video render settings paramaterized and/or invoke another batch with a parameter.
# make this conditionally copy/move frames into/out of sorting folders (for renders).
# this might not wipe files from the sort dir if the target archive image dir exists; or things might not continue on resuming batch as expected--make it work thus.

# GLOBAL VAR:
# n_frames_per_seq=46
n_frames_per_seq=310

if [ ! -d vid ]; then mkdir vid; fi
if [ ! -d vid/src ]; then mkdir vid/src; fi
if [ ! -d vid/dist ]; then mkdir vid/dist; fi
if [ ! -e ./frames_sort ]; then	mkdir frames_sort; fi
		# NOTTODO: make the following skip only if the last file name in that text file matches . . . no . . . no way around it; there has to be a directory listing on each run of this script :( unless I can somehow list only the last sorted item in a list that would result from ls or find :/ until then . . .
echo Listing image files in current directory . . .
ls *.png > frames_list.txt
mapfile -t frames_list < frames_list.txt

# IN DEVELOPMENT:
# remove first line from a list file; re: http://stackoverflow.com/a/339941/1397555
# tail -n +2 testList.txt > tempt.txt && mv tempt.txt testList.txt
# TO DO: use the list *as* the array, even though it's slower (OR sync the list with array iterations), because this will (more easily and accurately?) reflect the state of things if the process is interrupted and later resumed.


imgs_iter=0
target_end_frame=0
frame_seq_rendered=0
arrSize=${#frames_list[@]}
while [ $imgs_iter -lt $arrSize ]
do
	imgs_iter=$[imgs_iter + 1]
	# if we just rendered a target animation sequence (and set the following bool to 1), iterate to the next end target frame number and set the bool to 0:
	if (( frame_seq_rendered == 1 )); then target_end_frame=$[target_end_frame + n_frames_per_seq]; frame_seq_rendered=0; echo new target_end_frame value is $target_end_frame; fi

			if [ -e ./"${frames_list[$(($imgs_iter -1))]}" ]
			then
	cp ./"${frames_list[$(($imgs_iter -1))]}" ./frames_sort
			else
				continue
			fi
	targ_end_numPadded=`printf "%07d\n" $((imgs_iter))`
	if (( $imgs_iter % $n_frames_per_seq == 0 )); then
				# ENCODING COMMANDS:
		# IF TARGET avi file does not exist, render. Otherwise skip (do not clobber).
		if [ -e ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi ]
		then
					echo Target render file ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi already exists. Will not clobber, will not render.
		else
					echo Target render file ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi does not exist. Will attempt to render.
			cat ./frames_sort/*.png | ffmpeg -y -f image2 -f image2pipe -i - -vcodec utvideo -r 29.97 ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi
		fi
		# IF TARGET mp4 file does not exist, render. Otherwise skip (do not clobber).
		if [ -e ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 ]
		then
					echo Target render file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 already exists. Will not clobber, will not render.
		else
					echo Target render file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 does not exist. Will attempt to render.
			ffmpeg -y -i ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi -crf 17 -filter:v "crop=1280:720:x:y" ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4
						echo Attempted render of target file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 complete. Check the above output and/or the target file itself to see if the render was successful.
		fi


						if [ ! -d vid/src/_anim_toEndFR_$targ_end_numPadded ]; then
							mkdir vid/src/_anim_toEndFR_$targ_end_numPadded
							mv ./frames_sort/*.png ./vid/src/_anim_toEndFR_$targ_end_numPadded
									# cp ./frames_sort/*.png ./vid/src/_anim_toEndFR_$targ_end_numPadded
						fi
	fi
done

echo DONE rendering animation segments by $n_frames_per_seq per segment. Lossless avis are in ./vid/src, and high-quality, lossy mp4s are in ./vid/dist. You may wish to run concatVidFiles.sh over the ./vid/dist files. Also, the animation source images have been *copied* into subfolderes for better navigation. If the renders and image copies were successful, you may wish to delete all images from the source directory in which you ran this script, to conserve space.


# DEVELOPMENT HISTORY
# 06/29/2016 06:00:09 PM Began rework from scratch over badly approached, failed attempt.