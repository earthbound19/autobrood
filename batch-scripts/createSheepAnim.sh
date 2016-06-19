# DESCRIPTION: assembles all .flam3 fractal flame gemones in a directory (run this from the directory you wish to operate on) into an animation .flame file via EmberGenome.exe, then splits the animation frames out into individual genomes, ready for rendering. Requires xml_split dependency. Creates subdirectories of the animation flame and separated flames.

# NOTE: embergenome.exe must be able to read a copy of flam3-palettes.xml for this script to work, and for what I can't seem to figure out about how to make it seen in the path (). It may be a bug in embergenome.exe where it isn't importing the windows environment variables. And why should it? The only folks who use this extensively probably use 'nix systems :) the lines of code here involving a $wherePalettes variable are a workaround for this. What's worse is that only if invoked from windows cmd does EmberGenome even read said file from the same directory :/

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