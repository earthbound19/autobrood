# DESCRIPTION: assembles all .flam3 fractal flame gemones in a directory (run this from the directory you wish to operate on) into an animation .flame file via EmberGenome.exe, then splits the animation frames out into individual genomes, ready for rendering, and renders them to a lossless (utVideo) encoded .avi file which it places in a ./avi directory. It then also makes a high-quality (high-def aspect cropped) .mp4 video from that .avi. In the process, it also creates subdirectories of the animation flame and separated flames and creates the associated files therein. Since the utVideo .avi is lossless, you may wish to then delete all the .png image frames to conserve space.

# DEPENDENCIES: xml_split, ffmpeg.

# ALSO NOTE: this is hard-coded for 8 digits. If you change that you must change the final (kludge) line of the script to match the number of digits.

# KNOWN ISSUES and
# TO DO: fix whatever is consistently wrecking or dropping frames 8 and 9 of the generated sequence as "invalid" (or something like that). If you prune the animation .flam3 file to the 8th and 9th flames, manually export them with xml_split and render them, they are valid. Goofy. ?
# Use flam3-genome instead? It's possible fractorium is skipping frames. :/
# Batch rename anim. frames?
# Bug fix: frame 0 is unsynced. Maybe it's actually the last frame?
# Accept parameters for nframes, qs, and ss values.

# TO DO; DONE:
# * log either in the file names themselves or a text file how many frames are in a loop (re var_nframes).

# OPTIONAL: start this by generating so many fractal flames:
# generateNrandomGenomesFractorium.sh 500

# If there is no value set for var_nframes, set a default value:
# TO DO: update the following to use better error checking re render-flames-fractorium.sh:
# TO DO: figure out why even updating it thus does nothing! Meanwhile, just setting a default, whatever variables you've assigned in the shell.
# if ! (( $var_nframes )); then echo var_nframes not set\; setting to default value 110; $var_nframes=110; else echo var_nframes value of $var_nframes detected\; will use that.; fi
var_nframes=126
# var_nframes=310

echo Number of frames per loop for anim: $var_nframes > ANIM_INFO.txt

if [ ! -d anim_frames ]; then mkdir anim_frames; fi

# ? TO DO, POSSIBLY: use the counterpart to xml_split, xml_join, instead, for the following:
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
					echo running command\:
					echo EmberGenome.exe \-\-noedits \-\-nframes\=$var_nframes \-\-progress \-\-sequence\=_alles.flam3 \> _alles_anim.flam3
					echo . . .
	EmberGenome.exe --noedits --nframes=$var_nframes --progress --sequence=_alles.flam3 > _alles_anim.flam3
	# unused: --earlyclip --sp 
# END OPTION: USE EMBERGENOME
# !~-~-~-~-~-~-~-~-~-~-


if [ ! -d anim_xml ]; then mkdir anim_xml; fi
mv _alles.flam3 ./anim_xml/_alles.flam3

# because I prefer to have individual .flam3 files for each frame of the render (to set multiple computers batch rendering them, or to isolate a specific frame more easily for renders):

# TO DO: learn if there's a way to pad these to begin with on export from xml_split; . . .
# DONE. Option for number of digits to pad output file numbering for xml_split is -n <number> e.g. -n 7.

xml_split -n 7 _alles_anim.flam3
mv ./_alles_anim.flam3 ./anim_xml
# Because the resulting 00 frame .flam3 is always bogus:
rm _alles_anim-0000000.flam3

mv ./anim_xml ./..

# cludge for file name problem with 0th frame:
# mv _alles_anim_fr0000000.flam3 _alles_anim_fr-000000.flam3
# -- nah, just delete that first frame until I get this fixed:
rm _alles_anim_fr0000000.flam3

# Optional:
# FIRST run a command that renders all fractal flames to .png files, then:
# render-flames-anim-fractorium.sh

cd ..

# DEVELOPMENT HISTORY
# 06/19/2016 12:33:41 -RAH
# PM First feature complete.
