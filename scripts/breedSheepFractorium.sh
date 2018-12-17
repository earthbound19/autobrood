# TO DO:
# Document script
# Parameterize similarly to renderFlamesFractorium.sh

# First time I've ever initalized an array on the bash command line, and not from a file read:
methods=(union alternate interpolate)
# shortRestsInterval=15
# shortRestSeconds=40
shortRestsInterval=2
shortRestSeconds=4

nick=earthbound
url=http://earthbound.io
# tries=100001
# tries=2000
tries=200
openclFlag="--opencl"

    # BUG WORKAROUND:
    # Kludge for dependency file:
    # if [ ! -e flam3-palettes.xml ]; then cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml; fi

if [ ! -d children ]; then mkdir children; fi

# Can the following add \*.$flam3 to the end and work? :

# This convoluted crap trims off leading ./ from file names, and deletes windows newlines in the stream which can muck with the array even being properly created at all:
# SOLVES problem that was too difficult of finding .flame AND/OR .flam3 files:
flamesList=(`gfind . -maxdepth 1 -type f -name "*.flame*" -o -name "*.flam3*" | tr -d '\15\32'`)
# TO DO: printf here (copy it from where I do this elsewhere) that removes leading ./ from that; then toast the next two lines that use gsed.

renderCount=0
for cross0 in ${flamesList[@]}
do
  # trim any ./ off the start:
  cross0=`echo $cross0 | gsed 's/^\.\/\(.*\)/\1/g' | tr -d '\15\32'`
  outer_imageFileNameNoExt=${cross0%.*}
  for cross1 in ${flamesList[@]}
  do
  # trim any ./ off the start:
  cross1=`echo $cross1 | gsed 's/^\.\/\(.*\)/\1/g' | tr -d '\15\32'`
  inner_imageFileNameNoExt=${cross1%.*}
    for method in ${methods[@]}
    do
      # Don't breed a genome with itself! Skip this inner loop if $cross0 has the same value as $cross1; here logically implemented as "proceed if they are different:"
	  if ! [ $cross0 == $cross1 ]
	  then
		  targetGenomeFileName=./children/"$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".flame
			 echo target render file name is $targetGenomeFileName
		  renderingNoticeStubFile=./children/"$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".breeding
		  # If the check file does _not_ exist (!) then create it and render. Otherwise do nothing (skip render):
		  if ! [ -f $renderingNoticeStubFile ]
			then
			   echo "This file denotes procedural breeding of the genomes in this file name. Processes that check for this file will therefore avoid duplicate work." > $renderingNoticeStubFile
	#            echo crossbreed method is $method.
	#            echo Rendering target genome $targetGenomeFileName . . .
			renderCount=$((renderCount + 1))
			moduloCheck=`echo $(($renderCount % $shortRestsInterval))`
				echo moduloCheck is $moduloCheck
			  if [ $moduloCheck == "0" ]; then echo cooling down . . .; sleep $shortRestSeconds; fi
				echo will render . . .
	       embergenome --cross0=$cross0 --cross1=$cross1 --method=$method --nick=$nick --url=$url --tries=$tries $openclFlag > $targetGenomeFileName
			rm $renderingNoticeStubFile
		  else
			  echo ------ SKIP target $targetGenomeFileName because it exists or is rendering ------
		  fi
	  fi
    done
  done
done

    # END BUG WORKAROUND:
    # rm command here