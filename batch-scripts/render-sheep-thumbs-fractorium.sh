		# BUG WORKAROUND; weirder yet is that if I copy the following with a cp command, it copies it in some way that breaks the ability to properly read it in any xml viewer?! So use the cat command instead:
				# cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

find -iname \*.flam3 -o -iname \*.flame > all_fractal_flames.txt
sed 's/^\.\/\(.*\)/\1/g' all_fractal_flames.txt > temp.txt
rm all_fractal_flames.txt
mv temp.txt all_fractal_flames.txt
mapfile -t all_fractal_flames < all_fractal_flames.txt
for element in "${all_fractal_flames[@]}"
do
	echo EmberRender.exe --in=$element --out=$element.png --format=png --opencl --ss=1 --qs=1
done

# rm all_fractal_flames.txt

		# CLEANUP BUG WORKAROUND:
				# rm flam3-palettes.xml