# DESCRIPTION: assembles all .flam3 fractal flame gemones in a directory (run this from the directory you wish to operate on) into an animation .flame file via EmberGenome.exe, then splits the animation frames out into individual genomes, ready for rendering, and renders them to a lossless (utVideo) encoded .avi file which it places in a ./avi directory. It then also makes a high-quality (high-def aspect cropped) .mp4 video from that .avi. In the process, it also creates subdirectories of the animation flame and separated flames and creates the associated files therein. Since the utVideo .avi is lossless, you may wish to then delete all the .png image frames to conserve space.

# DEPENDENCIES: xml_split, ffmpeg.

# NOTE: embergenome.exe must be able to read a copy of flam3-palettes.xml for this script to work, and for what reason I don't know it doesn't work even if said file is in the system %PATH% (or cygwin $PATH). It may be a bug in embergenome.exe where it isn't importing the windows environment variables. And why should it? The only folks who use this extensively probably use 'nix systems :) Double-indented code lines in this script offer a workaround for that problem. Be sure for your uses that the cat command in the given workaround uses the proper path to the pallete file, which you may discover by typing the command:
# cygpath "<C:\TheFullPathTo_flam3-palettes.xml"

# ALSO NOTE: this is hard-coded for 8 digits. If you change that you must change the final (cludge) line of the script to match the number of digits.

# KNOWN ISSUES and
# TO DO: fix whatever is consistently wrecking or dropping frames 8 and 9 of the generated sequence as "invalid" (or something like that). If you prune the animation .flam3 file to the 8th and 9th flames, manually export them with xml_split and render them, they are valid. Goofy. ?
# Use flam3-genome instead? It's possible fractorium is skipping frames. :/
# Batch rename anim. frames?
# Bug fix: frame 0 is unsynced. Maybe it's actually the last frame?
# Accept parameters for nframes, qs, and ss values.

# TO DO:
# log either in the file names themselves or a text file how many frames are in a loop (re var_nframes).

# If there is no value set for var_nframes, set a default value:
if ! (( $var_nframes )); then var_nframes=12; fi

echo Number of frames per loop for anim: $var_nframes > ANIM_INFO.txt

if [ ! -d anim_frames ]; then mkdir anim_frames; fi

cat *.flam3 *.flame > ./anim_frames/_alles.flam3
# !~~~~
cd ./anim_frames
# !~~~~
printf "<flames name=\"alles\">" > head.txt
printf "</flames>" > tail.txt

cat head.txt _alles.flam3 tail.txt > temp.txt
rm _alles.flam3 head.txt tail.txt
mv temp.txt _alles.flam3

# !~-~-~-~-~-~-~-~-~-~-
# BEGIN OPTION: USE FLAM3-GENOME--comment out the code under USE EMBER-GENOME (below) if you use (uncomment) this section:
			# BUG WORKAROUND; see comments under USE EMBERGENOME -> BUG WORKAROUND:
					# cat /cygdrive/c/autobrood/bin/flam3-palettes.xml > flam3-palettes.xml
	# echo set noedits=1 > flam3GenomeTempBatch.bat
	# echo set nframes=180 >> flam3GenomeTempBatch.bat
	# echo set progress=1 >> flam3GenomeTempBatch.bat
	# echo set sequence=_alles.flam3 >> flam3GenomeTempBatch.bat
	# echo flam3-genome \> _alles_anim.flam3 >> flam3GenomeTempBatch.bat
	# chmod 777 flam3GenomeTempBatch.bat
	# cygstart flam3GenomeTempBatch.bat
	# mv flam3GenomeTempBatch.bat flam3GenomeTempBatch.bat.txt
	# rm flam3GenomeTempBatch.bat
# END OPTION: USE FLAM3-GENOME
# !~-~-~-~-~-~-~-~-~-~-

# !~-~-~-~-~-~-~-~-~-~-
# BEGIN OPTION: USE EMBERGENOME--comment out the code under USE FLAM3-GENOME (above) if you use (uncomment) this section:
			# BUG WORKAROUND; weirder yet is that if I copy the following with a cp command, it copies it in some way that breaks the ability to properly read it in any xml viewer?! So use the cat command instead:
					cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml
	EmberGenome.exe --noedits --nframes=$var_nframes --progress --sequence=_alles.flam3 > _alles_anim.flam3
	# unused: --earlyclip --sp 
# END OPTION: USE EMBERGENOME
# !~-~-~-~-~-~-~-~-~-~-

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml

if [ ! -d anim_xml ]; then mkdir anim_xml; fi
mv _alles.flam3 ./anim_xml/_alles.flam3

# because I prefer to have individual .flam3 files for each frame of the render (to set multiple computers batch rendering them, or to isolate a specific frame more easily for renders):

# TO DO: learn if there's a way to pad these to begin with on export from xml_split; . . .
# DONE. Option for number of digits to pad output file numbering for xml_split is -n <number> e.g. -n 7.

xml_split -n 7 _alles_anim.flam3
mv ./_alles_anim.flam3 ./anim_xml
# Because the resulting 00 frame .flam3 is always bogus:
rm _alles_anim-0000000.flam3

mv ./anim_xml ..

# cludge for file name problem with 0th frame:
# mv _alles_anim_fr0000000.flam3 _alles_anim_fr-000000.flam3
# -- nah, just delete that first frame until I get this fixed:
rm _alles_anim_fr0000000.flam3

# Optional:
render-flames-anim-fractorium.sh

cd ..


# DEVELOPMENT HISTORY
# 06/19/2016 12:33:41 -RAH
# PM First feature complete.