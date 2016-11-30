# NOTE: the below comment. You must copy the mentioned .xml file to the dir from which you run this script; it won't even see the file if its in the embergenome directory (I think).
# TO DO: make a path-independent workaround for the problem that (at this writing) EmberGenome doesn't scan paths fro flam3-palettes.xml.

		# BUG WORKAROUND:
				# cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

tries=20000
# tries=100001

for a in $( seq $1 )
do
	timestamp=`date +"%Y%m%d_%H%M%S_%N"`
		# I can't see that this switch actually uses the GPU to create genomes: --opencl 
	EmberGenome --nick=earthbound --tries=$tries > $timestamp.flame
done

		# CLEANUP BUG WORKAROUND:
				# rm flam3-palettes.xml

# Optional:
createSheepAnim.sh