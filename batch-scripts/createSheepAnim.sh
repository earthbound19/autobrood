# DESCRIPTION: assembles all .flam3 fractal flame gemones in a directory (run this from the directory you wish to operate on) into an animation .flame file via EmberGenome.exe, then splits the animation frames out into individual genomes, ready for rendering, and renders them to a lossless (utVideo) encoded .avi file which it places in a ./avi directory. It then also makes a high-quality (high-def aspect cropped) .mp4 video from that .avi. In the process, it also creates subdirectories of the animation flame and separated flames and creates the associated files therein. Since the utVideo .avi is lossless, you may wish to then delete all the .png image frames to conserve space.

# DEPENDENCIES: xml_split, ffmpeg.

# NOTE: embergenome.exe must be able to read a copy of flam3-palettes.xml for this script to work, and for what reason I don't know it doesn't work even if said file is in the system %PATH% (or cygwin $PATH). It may be a bug in embergenome.exe where it isn't importing the windows environment variables. And why should it? The only folks who use this extensively probably use 'nix systems :) Double-indented code lines in this script offer a workaround for that problem. Be sure for your uses that the cat command in the given workaround uses the proper path to the pallete file, which you may discover by typing the command:
# cygpath "<C:\TheFullPathTo_flam3-palettes.xml"

# ALSO NOTE: this is hard-coded for 8 digits. If you change that you must change the final (cludge) line of the script to match the number of digits.

# TO DO: accept parameters for nframes, qs, and ss values.

# TO DO: bug fix: frame 0 is unsynced. Maybe it's actually the last frame?

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

		# BUG WORKAROUND; weirder yet is that if I copy the following with a cp command, it copies it in some way that breaks the ability to properly read it in any xml viewer?! So use the cat command instead:
		cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

EmberGenome.exe --noedits --nframes=180 --progress --sequence=_alles.flam3 > _alles_anim.flam3
# unused: --earlyclip --sp 

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml

if [ ! -d anim ]; then mkdir anim; fi
mv _alles.flam3 ./anim/_alles.flam3

# because I prefer to have individual .flam3 files for each frame of the render (to set multiple computers batch rendering them, or to isolate a specific frame more easily for renders):
xml_split _alles_anim.flam3
mv ./_alles_anim.flam3 ./anim
# Because the resulting 00 frame .flam3 is always bogus:
rm _alles_anim-00.flam3

mv ./anim ..

# TO DO: learn if there's a way to pad these to begin with on export from xml_split;
# fix up non-zero-padded file names with too many zero pads (just in case, you know. MANY). Thanks to: http://stackoverflow.com/a/3700146/1397555
for file in _alles_anim-[0-9]*.flam3; do
	# strip the prefix ("_alles_anim") off the file name
	postfile=${file#_alles_anim}
	# strip the postfix (".flam3") off the file name
	number=${postfile%.flam3}
	# rename
	mv ${file} ./$(printf _alles_anim_fr%07d.flam3 $number)
done

# cludge for file name problem with 0th frame:
mv _alles_anim_fr0000000.flam3 _alles_anim_fr-000000.flam3

ffmpeg -y -r 29.97 -f image2 -i _alles_anim_fr-%06d.flam3.png -vcodec utvideo -r 29.97 _alles_anim.avi
ffmpeg -y -i _alles_anim.avi -filter:v "crop=1280:720:x:y" -crf 32 _alles_anim.mp4

if [ ! -d vid ]; then mkdir vid; fi
mv _alles_anim.avi ./vid/_alles_anim.avi
mv _alles_anim.mp4 ./vid/_alles_anim.mp4

cd ..


# DEVELOPMENT HISTORY
# 06/19/2016 12:33:41 -RAH
# PM First feature complete.