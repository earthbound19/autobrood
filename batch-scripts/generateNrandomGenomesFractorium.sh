# NOTE: the below comment. You must copy the mentioned .xml file to the dir from which you run this script; it won't even see the file if its in the embergenome directory (I think).
# TO DO: make a path-independent workaround for the problem that (at this writing) EmberGenome doesn't scan paths fro flam3-palettes.xml.


# USAGE
# call this script with one parameter and another optional parameter:
# $1 the number of random genomes to generate
# $2 the color palette xml file to randomly pick a palette from.

# OTHER NOTES
# At this writing, the script assumes that a specified palette file ($2) is in the same path this script is run from. Also, if there are spaces in the path name, it will probably break.

# PREP BEGIN
# PARAMATER CHECKS and resulting variable initialization.
if [ -z ${1+x} ]
	then
	howMany=1
	else
	howMany=$1
fi
		echo how many is $howMany

if [ -z ${2+x} ]
	then
	paletteFile="flam3-palettes.xml"
	else
	paletteFile=$2
fi
		echo palette file is $paletteFile
paletteParam="--flam3_palettes=$paletteFile"
		echo paletteParam value is $paletteParam

# WORK BEGIN
		# BUG WORKAROUND:
				# cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

tries=20000
# tries=100001

for a in $( seq $howMany )
do
	timestamp=`date +"%Y%m%d_%H%M%S_%N"`
	echo rendering $timestamp.flame . . .
	idParam="--id=RND"_"$timestamp"_from_""$paletteFile""
			# echo idParam val is $idParam
# exit
		# I can't see that this switch actually uses the GPU to create genomes: --opencl 
	EmberGenome --nick=earthbound --url=http://earthbound.io $idParam $paletteParam --tries=$tries > $timestamp.flame
done

		# CLEANUP BUG WORKAROUND:
				# rm flam3-palettes.xml

# Optional:
# createSheepAnim.sh