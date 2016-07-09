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
				# --ss=.667		produces 1280x image (if cropped) from 2160x1080 genome
def_ss=.667
def_qs=8.5


cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

	# ===== SET GLOBAL BOOLEAN based on pass/fail of --opencl render test, which we will use to decide whether to pass the --opencl parameter;
	# EXCEPT DON'T EVEN run this test if the script is run with any parameter; the bollean will be set to an empty value or an actual command flag (string) value depending; if it's empty it simply won't have any effect when insterted into the command:
	if [ -z ${1+x} ]
		then
			# Why cat instead of cp? Stupid permissions things that sometimes arise from Windows. Why cat avoids the permissions garbage is a mystery:
			cat /cygdrive/c/autobrood/batch-scripts/_test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame > _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
			echo No parameter passed to script\; will test \-\-opencl render flag with EmberRender.exe. To avoid this test\, invoke the script with any parameter\, e.g.\:
			echo \<thisScriptName.sh floofyFloo\>\<enter\>.
				echo RUNNING OPENCL RENDER TEST to determine settings for batch render of fractal flames . . .
			EmberRender.exe --in=test.flame --out=test.png --format=png --progress --opencl --ss=.2 --qs=1
			errorLevel=$?
			rm _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
			echo ~-~-
			if ! [ "$errorLevel" == 0 ]
				then
					echo error level encountered executing render command with --opencl flag\: $errorLevel. will not use --opencl flag when invoking EmberRender.exe.
					openclFlag=""
				else
					echo No error level encountered executing render command with --opencl flag\: \(result $errorLevel\). Will use --opencl flag when invoking EmberRender.exe.
					openclFlag="--opencl "
			fi
			echo ~-~-
		else
			openclFlag="--opencl "
			echo Parameter was passed to script\; will NOT test --opencl render flag with EmberRender.exe\, and WILL go ahead and use \-\-opencl flag.
	fi
	# ===== END SET GLOBAL FLAG

if [ -z ${ss+x} ]; then echo no value for ss\; setting default value of $def_ss; ss=$def_ss; else echo using environment value of ss=$ss; fi
if [ -z ${qs+x} ]; then echo no value for qs\; setting default value of $def_qs; qs=$def_qs; else echo using environment value of qs=$qs; fi

if [ ! -d render_output ]; then mkdir render_output; fi

find . -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
# filter the ./ off the start of that list (it messes up later file checks if read from a list) :
sed 's/^\.\/\(.*\)/\1/g' fractal_flames_list.txt > temp.txt
rm fractal_flames_list.txt
mv temp.txt fractal_flames_list.txt
mapfile -t fractal_flames_list < fractal_flames_list.txt
rm fractal_flames_list.txt

		# BUG WORKAROUND:
		# see createSheepAnim.sh for notes about this cludge; yes this is duplicate code only for context (this was copied at the start of this script also); except the following line was copied to the top of this script for other purposes:
		# cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

# Only render the frame if the target render file does not exist:
for element in "${fractal_flames_list[@]}"
do
	if [ ! -e ./render_output/$element.png ] && [ ! -e ./render_output/$element.txt ]
	# NOTE for the following command: for 800 x 592 or whatever flame, ss=2.4 offers high def (1080p) image area. ss=1.6 offers HD 720p area.
		then
		echo target file $element.png does not exist. will render.
		# EmberRender doesn't seem to be able to render the file into another directory, so we're rendering the image into the same directory as the source .flam3 file, then moving it to a subdir.
		echo running command: EmberRender.exe --in=$element --out=$element.png --format=png --progress $openclFlag --ss=$ss --qs=$qs
	# temporary text file to let any other render client know we're doing this:
	printf "rendering an image for this file name . . ." > ./render_output/$element.txt
		EmberRender.exe --in=$element --out=$element.png --format=png --progress $openclFlag --ss=$ss --qs=$qs
	rm ./render_output/$element.txt
		mv $element.png ./render_output/
		echo Sleeping to allow computer to cool for \$n seconds . . .
		sleep 6.2
	fi
done

		# CLEANUP BUG WORKAROUND:
		rm flam3-palettes.xml

# TEMP, OPTIONAL:
cd render_output
render-flames-anim-fractorium.sh

# DEVELOPMENT HISTORY
# Before now:
# Yesh. First feature complete.
# 07/08/2016 07:35:21 PM
# Eliminate ridiculous bool LATER_DELETE__test_wexEheVtcfysXww27E4g8JmeeCHBFVXH_flame_whatAnAwesomeVariableName and instead just copy corresponding test render fractal flame genome to current dir and then delete (*gasps for air*) conditionally--only do all that on condition of even doing a test render.