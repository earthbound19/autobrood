nick=earthbound
url=http://earthbound.io
# tries=10001
tries=100

		# BUG WORKAROUND:
		# see createSheepAnim.sh for notes about this cludge:
		# if [ ! -e flam3-palettes.xml ]; then cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml; fi

if [ ! -d children ]; then mkdir children; fi

CygwinFind *.flame > fractal_flames_list.txt
mapfile -t flamesList < fractal_flames_list.txt		# For High School's sake
rm fractal_flames_list.txt

for cross0 in ${flamesList[@]}
do
			# echo cross0 is $cross0
	outer_imageFileNameNoExt=`echo $cross0 | sed 's/\(.*\)\.flame/\1/g'`
			# echo outer_imageFileNameNoExt is $outer_imageFileNameNoExt
	for cross1 in ${flamesList[@]}
	do
				# echo cross1 is $cross1
		inner_imageFileNameNoExt=`echo $cross1 | sed 's/\(.*\)\.flame/\1/g'`
				# echo inner_imageFileNameNoExt is $inner_imageFileNameNoExt
		# First time I've ever initalized an array on the bash command line, and not from a file read:
		methods=(union alternate interpolate)
		for method in ${methods[@]}
			do
			targetGenomeFileName="$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".flame
					# echo targetGenomeFileName is $targetGenomeFileName
			# re genius breath at: http://stackoverflow.com/a/12989651
			# the > /dev/null is to write any errors to nowhere (hide them).
			foundCount=`CygwinFind ./ -name $targetGenomeFileName | wc -l`
					# echo foundCount is $foundCount
			if [ $foundCount == "0" ]
				then
					# then render for this target file name.
								# OODALALLY! . . .
								renderingNoticeStubFile=./children/"$outer_imageFileNameNoExt"_and_"$inner_imageFileNameNoExt"_"$method".breeding
					# Continue and render only if $renderingNoticeStubFile does *not* exist:
					if ! [ -e $renderingNoticeStubFile ]
						then
									echo "This notice affixes you with actual knowledge that two fractal flames were either intending to engage in SEX or that they ARE\, AT THIS MOMENT\, ACTUALLY DOING THE NASTY." > $renderingNoticeStubFile
						# echo crossbreed method is $method.
						echo Rendering target genome ./children/$targetGenomeFileName . . .
						EmberGenome --cross0=$cross0 --cross1=$cross1 --method=$method --nick=$nick --url=$url --tries=$tries > ./children/$targetGenomeFileName
									rm $renderingNoticeStubFile
					fi
				else
					echo ------ SKIP target $targetGenomeFileName exists or is rendering ------
			fi
		done
	done
done

		# END BUG WORKAROUND:
		# rm command here