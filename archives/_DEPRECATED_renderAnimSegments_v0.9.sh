# DESCRIPTION:
# Given a sequence of specifically names 7-digit animation images, render lossless .avi and high-quality lossy .mp4 (with AVC) animation segment videos which can later be strung together losslessly via e.g. concatVidFiles.sh. Originally specifically designed for file names/numbering of fractal flame animation image sequences generated via createSheepAnim.sh and render-flames-fractorium.sh.

# USAGE:
# Call this script from a directory full of so rendered and so named animation files. This only renders target avi and mp4 files if they do not already exist, and will re-render target files wherever there is a gap in the target .mp4 files sequence. NOTE: If this script is interrupted and resumed, it attempts to move the image files back up from the ./frames_sort directory into which they were moved--it attempts to move those image files back up to the root of the path from which this script was run (and is run again). ALSO NOTE: it expects frame numbering to start with 1.

# TO DO:
# ?! REDO EVERYTHING FROM THE SCRIPT BEFORE THIS; what makes the .flam3 files and rendered images before this should be grouped into folders by number of frames per loop/transition, to eliminate post guesswork and this ridiculous spaghetti code nightmare. :( that way no files are moved around; only rendered into subdirs of pre-existing subdir groups, then concatenated etc. in place. Boom. Done. 06/28/2016 05:25:18 PM -RAH
# Fix bug: it doesn't move and integrate the last frame of a sequence, so that segments skip a frame.
# Make it not attempt rendering target files?--it seems like it is, but failing, if the target pre-exists, but no source images were copied into the sorting dir?
# make n_frames_per_seq optionally parameterized, with a default.
# explain wt this script does, etc.
# make this work in harmony with render-flames-anim-fractorium.sh ?

# GLOBAL VAR:
n_frames_per_seq=46

# Empty any files in the the frames_sort folder if it exists, else we get video renders with incorrect frames:
if [ -d frames_sort ]; then mv ./frames_sort/* .. ; fi
if [ ! -d frames_sort ]; then mkdir frames_sort; fi
# if [ ! -d frames_rendered ]; then mkdir frames_rendered; fi
if [ ! -d vid ]; then mkdir vid; fi
if [ ! -d vid/src ]; then mkdir vid/src; fi
if [ ! -d vid/dist ]; then mkdir vid/dist; fi

echo Listing image files in current directory . . .
if [ ! -e ./frames_list.txt ]; then ls *.png > frames_list.txt; fi
mapfile -t frames_list < frames_list.txt
# rm frames_list.txt
imgs_iter=0
# Copy (or move, per preference) n_frames_per_seq image files from list into a temp dir, render them into a lossless avi, then a high-quality mp4, and delete the copied/moved image sequence files from the temp dir; repeat this until all image files in the current directory have been copied and rendered to files of n_frames_per_seq each. Move the results into ./vid/src (avis) and /vid/dist (mp4s):
# NO, should be a while loop:

# IN DEVELOPMENT:
# remove first line from a list file; re: http://stackoverflow.com/a/339941/1397555
# tail -n +2 testList.txt > tempt.txt && mv tempt.txt testList.txt
# TO DO: use the list *as* the array, even though it's slower (OR sync the list with array iterations), because this will (more easily and accurately?) reflect the state of things if the process is interrupted and later resumed.

arrSize=${#frames_list[@]}
while [ $imgs_iter -lt $arrSize ]
do
	imgs_iter=$[$imgs_iter + 1]
	# SORT CURRENT FRAME into frames_sort anim. segment render queue folder; this had long been in a lower control block where it caused frame copy skipping in cases that control block wasn't invoked (after each image sequence is moved into a new folder; NO, this file must always copy; only when it is used has other dependencies) ; ACCOUNTS FOR zero-based indexing! :
			# ALSO note that this skips the whole loop if the source file that would be moved is not found.
			if [ -e ./"${frames_list[$(($imgs_iter -1))]}"]
			then
	# mv ./"${frames_list[$(($imgs_iter -1))]}" ./frames_sort
	cp ./"${frames_list[$(($imgs_iter -1))]}" ./frames_sort
			else
				continue
			fi
	targ_end_numPadded=$(printf "%07d\n" $((imgs_iter)))
	if (( $imgs_iter % $n_frames_per_seq == 0 )); then
		if [ -e ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 ]
		then
					echo Target render file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 already exists. Will not clobber, will not render.
		else
					echo Target render file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 does not exist. Will attempt to render.
			# ENCODING COMMANDS:
			cat ./frames_sort/*.png | ffmpeg -y -r 29.97 -f image2 -f image2pipe -i - -vcodec utvideo -r 29.97 ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi
			ffmpeg -y -i ./vid/src/_anim_toEndFR_$targ_end_numPadded.avi -crf 7 ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4
						echo Attempted render of target file ./vid/dist/_anim_toEndFR_$targ_end_numPadded.mp4 complete. Check the above output and/or the target file itself to see if the render was successful.
		fi
						# Reason for moving source images for the anim. segment to their own folder: when you're dealing with tens of thousands of source images, and resume rendering where you left off, it saves time where this script would otherwise list and copy those files;
						# Conditionally make a folder to shuffle all the files into (which will not be rendered, as the target was already made. Yes, theoretically that sequence of image files shouldn't be there and shouldn't have to be moved if the target render file already exists) :
						if [ ! -d vid/src/_anim_toEndFR_$targ_end_numPadded ]; then
							mkdir vid/src/_anim_toEndFR_$targ_end_numPadded
							# mv ./frames_sort/*.png ./vid/src/_anim_toEndFR_$targ_end_numPadded
							cp ./frames_sort/*.png ./vid/src/_anim_toEndFR_$targ_end_numPadded
						fi
	fi
done

echo DONE rendering animation segments by $n_frames_per_seq per segment. Lossless avis are in ./vid/src, and high-quality, lossy mp4s are in ./vid/dist. You may wish to run concatVidFiles.sh over the ./vid/dist files. Also, the animation source images have been *copied* into subfolderes for better navigation. If the renders and image copies were successful, you may wish to delete all images from the source directory in which you ran this script, to conserve space.


# DEVELOPMENT HISTORY
# 06/28/2016 05:43:15 AM First feature complete.
# 06/28/2016 03:37:19 PM Except it needed major code rework for brevity/clarity and a bug fix. Done.