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
		  # If the render progress stub file does not exist AND the target render file does not already exist, continue and render the target. Otherwise skip render and notify user of skip:
		  if [ ! -f $renderingNoticeStubFile ] && [ ! -f $targetGenomeFileName ]
			then
			   echo "This file was created when an interbreed render (of the genomes in this file name) was started. Processes that check for this file will therefore avoid duplicate work. If no renders are underway, this file was probably leftover from an interrupted render and you may delete it and start renders again so that the desired render target will be created." > $renderingNoticeStubFile
			renderCount=$((renderCount + 1))
			moduloCheck=`echo $(($renderCount % $shortRestsInterval))`
				echo moduloCheck is $moduloCheck
			  if [ $moduloCheck == "0" ]; then echo cooling down . . .; sleep $shortRestSeconds; fi
				echo will render . . .
	       echo crossbreed method is $method.
	       echo "Rendering target genome $targetGenomeFileName (render no. $renderCount of this run) . . ."
sleep 50
	       embergenome --cross0=$cross0 --cross1=$cross1 --method=$method --nick=$nick --url=$url --tries=$tries $openclFlag > $targetGenomeFileName
			rm $renderingNoticeStubFile
		  else
			  echo ------ SKIPPED target $targetGenomeFileName because it exists or the render notification stub file $renderingNoticeStubFile is an indication that it is rendering ------
		  fi
	  fi
    done
  done
done

    # END BUG WORKAROUND:
    # rm command here