# DESCRIPTION: assembles all .flam3 fractal flame gemones in a directory (run this from the directory you wish to operate on) into an animation .flame file via EmberGenome.exe, then splits the animation frames out into individual genomes, ready for rendering. Requires xml_split dependency. Creates subdirectories of the animation flame and separated flames.

# NOTE: embergenome.exe must be able to read a copy of flam3-palettes.xml for this script to work, and for what reason I don't know it doesn't work even if said file is in the system %PATH% (or cygwin $PATH). It may be a bug in embergenome.exe where it isn't importing the windows environment variables. And why should it? The only folks who use this extensively probably use 'nix systems :) Double-indented code lines in this script offer a workaround for that problem. Be sure for your uses that the cat command in the given workaround uses the proper path to the pallete file, which you may discover by typing the command:
# cygpath "<C:\TheFullPathTo_flam3-palettes.xml"

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

EmberGenome.exe --noedits --nframes=110 --progress --sp --earlyclip --sequence=_alles.flam3 > _alles_animated.flam3

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml

if [ ! -d multi ]
then
	mkdir multi
fi

mv _alles.flam3 ./multi/_alles.flam3

# because I prefer to have individual .flam3 files for each frame of the render (to set multiple computers batch rendering them, or to isolate a specific frame more easily for renders):
xml_split _alles_animated.flam3
mv ./_alles_animated.flam3 ./multi
# Because the resulting 00 frame .flam3 is always bogus:
rm _alles_animated-00.flam3
cd ..


# DEVELOPMENT HISTORY
# 06/19/2016 12:33:41 -RAH
# PM First feature complete.