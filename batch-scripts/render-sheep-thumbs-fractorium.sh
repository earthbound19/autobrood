		# BUG WORKAROUND; weirder yet is that if I copy the following with a cp command, it copies it in some way that breaks the ability to properly read it in any xml viewer?! So use the cat command instead:
				cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

find -iname \*.flam3 -o -iname \*.flame > all_fractal_flames.txt
sed 's/^\.\/\(.*\)/\1/g' all_fractal_flames.txt > temp.txt
rm all_fractal_flames.txt
mv temp.txt all_fractal_flames.txt
mapfile -t all_fractal_flames < all_fractal_flames.txt
for element in "${all_fractal_flames[@]}"
do
# BUG OBSERVED? : some decimals for ss and qs make it crash; others don't. If it crashes, futz with the decimals, including adding or removing the zero before the decimal.
	EmberRender.exe --in=$element --out=$element.png --format=png --verbose --progress --opencl --ss=.28 --qs=0.6
done

rm all_fractal_flames.txt

		# CLEANUP BUG WORKAROUND:
				rm flam3-palettes.xml