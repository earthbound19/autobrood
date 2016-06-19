# NOTE that ss and qs must be set as explicit parameters--it doesn't import any environment variables by those names. ALSO, if it throws an error about not loading a pallete xml file, temporarily copy the file of that name into the directory for which you run this render script.

# whaaat? It seems the following if block doesn't work as expected:
if [ ! -d render_output ]; then mkdir render_output; fi

find . -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
mapfile -t fractal_flames_list < fractal_flames_list.txt
rm fractal_flames_list.txt

for element in "${fractal_flames_list[@]}"
do
	if [ ! -a $element.png ]
# NOTES: for 800 x 592 or whatever flame, ss=2.4 offers high def (1080p) image area. ss=
		then
		EmberRender.exe --in=$element --out=./render_output/$element.png --format=png --progress --opencl --ss=2.4 --qs=3.7
	fi
# done
