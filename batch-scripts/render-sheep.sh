ss=2.4
qs=3.7

find . -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
mapfile -t fractal_flames_list < fractal_flames_list.txt
for element in "${fractal_flames_list[@]}"
do
	# echo elm. is $element
	flam3-render < $element
done

rm fractal_flames_list.txt