# First time I've ever initalized an array on the bash command line, and not from a file read:
methods=(union alternate interpolate)
shortRestsInterval=15
shortRestSeconds=40
# shortRestsInterval=2
# shortRestSeconds=4

nick=earthbound
url=http://earthbound.io
# tries=100001
tries=2000

    # BUG WORKAROUND:
    # Kludge for dependency file:
    # if [ ! -e flam3-palettes.xml ]; then cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml; fi

if [ ! -d children ]; then mkdir children; fi

# Can the following add \*.$flam3 to the end and work? :

# This convoluted crap trims off leading ./ from file names, and deletes windows newlines in the stream which can muck with the array even being properly created at all:
# SOLVES problem that was too difficult of finding .flame AND/OR .flam3 files:
flamesList=(`gfind . -maxdepth 1 -type f -name "*.flame*" -o -name "*.flam3*" | tr -d '\15\32'`)

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
      # TO DO: AVOID self-sex! That is wrong! (Skip this inner loop if $cross0 has the same value as $cross1 -- IF that is an operation that produces an insubstantially different fractal (check)!
      targetGenomeFileName=./children/"$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".flame
#          echo targetGenomeFileName is $targetGenomeFileName
      renderingNoticeStubFile=./children/"$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".breeding
      # If the check file does _not_ exist (!) then create it and render. Otherwise do nothing (skip render):
      if ! [ -f $renderingNoticeStubFile ]
        then
#            echo "This notice affixes you with actual knowledge that two fractal flames were either intending to engage in SEX or that they ARE\, AT THIS MOMENT\, ACTUALLY DOING THE NASTY." > $renderingNoticeStubFile
#            echo crossbreed method is $method.
#            echo Rendering target genome $targetGenomeFileName . . .
        renderCount=$((renderCount + 1))
        moduloCheck=`echo $(($renderCount % $shortRestsInterval))`
            echo moduloCheck is $moduloCheck
          if [ $moduloCheck == "0" ]; then echo cooling down . . .; sleep $shortRestSeconds; fi
            echo will render . . .
            echo COMMAND IS\:
        echo "embergenome --cross0=$cross0 --cross1=$cross1 --method=$method --nick=$nick --url=$url --tries=$tries > $targetGenomeFileName"
        rm $renderingNoticeStubFile
      else
          echo ------ SKIP target $targetGenomeFileName because it exists or is rendering ------
      fi
    done
  done
done

    # END BUG WORKAROUND:
    # rm command here