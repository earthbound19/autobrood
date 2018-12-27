# USAGE
# To skip the opencl test, pass this script any parameter $1.

# NOTE that ss and qs must be set as explicit parameters for emberrender on the command line (for windows only?) --it doesn't import any environment variables by those names. ALSO, if it throws an error about not loading a pallete xml file, temporarily copy the file of that name into the directory for which you run this render script.

# ALSO NOTE: for now (or forever?) it outputs target renders in the same directory as the source flame file.

# TO DO
# Document possible parameters for this script.


# GLOBAL VALUES:

# Set ss and qs defaults if there are no such variables;
# some options:
		# --ss=.18 --qs=0.7
		# --ss=.25 --qs=0.7
		# --ss=0.815	produces ~640x image from 800x genome
		# --ss=1.6		produces 1280x image from 800x genome
		# --ss=2.4		produces 1920x image from 800x genome
		# --ss=3		. . ?
		# --ss=.667		produces 1280x image (if cropped) from 2160x1080 genome
def_ss=.41
# def_ss=.667
# def_ss=.815
# def_ss=1.6
# def_ss=2.4
# def_ss=2.64
# def_ss=10.66
def_qs=14
# def_qs=20
# def_qs=57
# def_qs=180
# def_qs=512

# The number of seconds between individual and batch renders to rest:
shortRestPeriod=18
mediumRestPeriod=260

# Optional opencl device to use parameter; comment out if you don't want it:
# deviceParam="-device=2"


# TO DO: make the following test portable (import the path from a file given in user root) and test if it works on Mac and Windows) :
	# ===== SET GLOBAL BOOLEAN based on pass/fail of --opencl render test, which we will use to decide whether to pass the --opencl parameter;
	# EXCEPT DON'T EVEN run this test if the script is run with any parameter; the boolean will be set to an empty value or an actual command flag (string) value depending; if it's empty it simply won't have any effect when inserted into the command:
	if [ -z ${1+x} ]
		then
			# Why cat instead of cp? Stupid permissions things that sometimes arise from Windows. Why cat avoids the permissions garbage is a mystery:
			cat /cygdrive/c/autobrood/batch-scripts/_test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame > _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
			echo No parameter passed to script\; will test \-\-opencl render flag with emberrender. To avoid this test\, invoke the script with any parameter\, e.g.\:
			echo \<thisScriptName.sh floofyFloo\>\<enter\>.
				echo RUNNING OPENCL RENDER TEST to determine settings for batch render of fractal flames . . .
			emberrender --in=test.flame --out=test.png --format=png --progress --opencl --ss=.2 --qs=1
			errorLevel=$?
			rm _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
			echo ~-~-
			if ! [ "$errorLevel" == 0 ]
				then
					echo error level encountered executing render command with --opencl flag\: $errorLevel. will not use --opencl flag when invoking emberrender.
					openclFlag=""
				else
					echo No error level encountered executing render command with --opencl flag\: \(result $errorLevel\). Will use --opencl flag when invoking emberrender.
					openclFlag="--opencl "
			fi
			echo ~-~-
		else
			openclFlag="--opencl "
			echo Parameter was passed to script\; will NOT test --opencl render flag with emberrender\, and WILL go ahead and use \-\-opencl flag.
	fi
	# ===== END SET GLOBAL FLAG

if [ -z ${ss+x} ]; then echo no value for ss\; setting default value of $def_ss; ss=$def_ss; else echo using environment value of ss=$ss; fi
if [ -z ${qs+x} ]; then echo no value for qs\; setting default value of $def_qs; qs=$def_qs; else echo using environment value of qs=$qs; fi

if [ ! -d render_output ]; then mkdir render_output; fi

flamesList=(`gfind . -maxdepth 1 -type f -name "*.flame*" -o -name "*.flam3*" | tr -d '\15\32'`)


# To allow rest periods every nth frame:
imgs_iter=1
# Only render the frame if the target render file does not exist:
for element in ${flamesList[@]}
do
	# strip everything up to any leading forward slashes \(from paths\) from the $element\:
	elementNoPath=`echo $element | sed 's/\(.*\/\)\(.*\)/\2/g'`
			# echo element is\: $element
			# formerly checked for ./render_output/$element.png; using wildcards instead now because I don't want it to render if an existing rendered file of the same target name exists in *any* subdirectory. This allows e.g. sorting favorite renders into subfolders without re-rendering them if I run a render batch again (e.g. against new fractal flame genome files).
			# echo val of elementNoPath is\:\n $elementNoPath

		# DEPRECATED, because it failed:
		# if [ ! -e ./*/$elementNoPath.png ] && [ ! -e ./*/$elementNoPath.txt ]
	renderTarget="$element".png
	foundCount=`gfind ./ -name $renderTarget | wc -l`
		if [ $foundCount == "0" ]
		then
			echo target file $renderTarget does not exist in this or any subfolder. will render.
			# emberrender doesn't seem to be able to render the file into another directory, so we're rendering the image into the same directory as the source .flam3 file, then moving it to a subdir.
# TO DO: fix this with an incrementing count var (since I'm not using an array anymore) :
					# echo image $imgs_iter of ${#fractal_flames_list[@]}
					# temporary text file to let any other render client know we're doing this:
					printf "rendering an image for this file name . . ." > ./render_output/$element.txt
					# Optional flag in the following command; WARNING: it will reduce render speed by 10% :
					# --progress
			emberrender --in=$element --out=$element.png --format=png --progress --ss=$ss --qs=$qs $deviceParam $openclFlag
			rm ./render_output/$element.txt
			mv $element.png ./render_output/
					imgs_iter=$((imgs_iter + 1))
			if (( $imgs_iter % 125 == 0 )); then echo I have rendered 125 images\, and I am resting for $mediumRestPeriod seconds to cool down.; sleep $mediumRestPeriod; fi
					# echo ~ mgs_iter val is $imgs_iter ~
			echo Render complete\; sleeping to allow computer to cool for $shortRestPeriod seconds . . .
			echo ~-~-~-~-~-~-~-~-~-~-
			sleep $shortRestPeriod
		else
			echo target file $renderTarget already exists in this or a subfolder. will not render. 
	fi
done


# TEMP, OPTIONAL:
# cd render_output
# render-flames-anim-fractorium.sh

# DEVELOPMENT HISTORY
# Before now:
# Yesh. First feature complete.
# 07/08/2016 07:35:21 PM
# Eliminate ridiculous bool LATER_DELETE__test_wexEheVtcfysXww27E4g8JmeeCHBFVXH_flame_whatAnAwesomeVariableName and instead just copy corresponding test render fractal flame genome to current dir and then delete (*gasps for air*) conditionally--only do all that on condition of even doing a test render.
# 01/10/2017 3:24 PM BUG FIX: existing file check before render was failing. Switched to use cygwinFind command to determine existence (instead of -e).