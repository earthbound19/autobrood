# NOTE that ss and qs must be set as explicit parameters for EmberRender.exe --it doesn't import any environment variables by those names. ALSO, if it throws an error about not loading a pallete xml file, temporarily copy the file of that name into the directory for which you run this render script.

# ALSO NOTE: for now (or forever?) it outputs target renders in the same directory as the source flame file.

# Set ss and qs defaults if there are no such variables;
# some options:
				# --ss=.18 --qs=0.7
				# --ss=.25 --qs=0.7
				# --ss=0.815	produces ~640x image from 800x genome
				# --ss=1.6		produces 1280x image from 900x (?) genome
				# --ss=2.4		produces 1920x image from 800x genome
				# --ss=3		. . ?
if [ -z ${ss+x} ]; then echo no value for ss\; setting default value of .18; ss=.18; else echo using environment value of ss=$ss; fi
if [ -z ${qs+x} ]; then echo no value for qs\; setting default value of 1; qs=1; else echo using environment value of qs=$qs; fi

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
		echo target file $element.png does not exist. will render.
		# EmberRender doesn't seem to be able to render the file into another directory, so we're rendering the image into the same directory as the source .flam3 file, then moving it to a subdir.
		echo running command: EmberRender.exe --in=$element --out=$element.png --format=png --progress --ss=$ss --qs=$qs
		EmberRender.exe --in=$element --out=$element.png --format=png --progress --ss=$ss --qs=$qs
		mv $element.png ./render_output/
		# echo Sleeping to allow computer to cool for 7 seconds . . .
		# sleep 7
	fi
done

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml