# NOTE that ss and qs must be set as explicit parameters for EmberRender.exe --it doesn't import any environment variables by those names. ALSO, if it throws an error about not loading a pallete xml file, temporarily copy the file of that name into the directory for which you run this render script.

# ALSO NOTE: for now (or forever?) it outputs target renders in the same directory as the source flame file.

# TO DO: have this use optional ss and qs (and other?) parameters.
	# - Name output files accordingly?

# whaaat? It seems the following if block doesn't work as expected:
if [ ! -d render_output ]; then mkdir render_output; fi

find . -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
# filter the ./ off the start of that list (it messes up later file checks if read from a list) :
sed 's/^\.\/\(.*\)/\1/g' fractal_flames_list.txt > temp.txt
rm fractal_flames_list.txt
mv temp.txt fractal_flames_list.txt
mapfile -t fractal_flames_list < fractal_flames_list.txt
rm fractal_flames_list.txt

		# BUG WORKAROUND:
		# see createSheepAnim.sh for notes about this cludge:
		cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

# Only render the frame if the target render file does not exist:
for element in "${fractal_flames_list[@]}"
do
	if [ ! -e ./render_output/$element.png ]
	# NOTE for the following command: for 800 x 592 or whatever flame, ss=2.4 offers high def (1080p) image area. ss=1.6 offers HD 720p area.
		then
		echo RENDER. Target file $element.png does not exist. Will render.
		# EmberRender doesn't seem to be able to render the file into another directory, so we're rendering the image into the same directory as the source .flam3 file, then moving it to a subdir.
		# RECENTLY USED for quick and dirty abstract resource anims: --ss=.25 --qs=0.7
		EmberRender.exe --in=$element --out=$element.png --format=png --progress --transparency --opencl --ss=5.315 --qs=2 --nstrips=8
				# some options:
				# --ss=.18 --qs=0.7
				# --ss=.25 --qs=0.7
				# --ss=0.815	produces ~640x image from 800x genome
				# --ss=1.6		produces 1280x image from 900x (?) genome
				# --ss=2.4		produces 1920x image from 800x genome
				# --ss=3		. . ?
		mv $element.png ./render_output/
		echo in cool-down sleep period for a bit . . .
		sleep 40
	else
		echo SKIP. Target file $element.png already exists. Will not re-render.
	fi
done

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml