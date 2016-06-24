# NOTE: it seems that embergenome is useless for creating new random genomes from scratch. Or maybe there's an error I'm unaware of in the way I'm doing this.

		# BUG WORKAROUND:
		if [ ! -e flam3-palettes.xml ]; then cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml; fi

for a in $( seq $1 )
do
	timestamp=`date +"%Y_%m_%d__%H_%M_%S__%N"`
		# I can't see that this switch actually uses the GPU to create genomes: --opencl 
	EmberGenome.exe --nick=earthbound --tries=4250 > $timestamp.flame
done

		# CLEANUP BUG WORKAROUND:
				rm flam3-palettes.xml

render-flames-thumbs-fractorium.sh