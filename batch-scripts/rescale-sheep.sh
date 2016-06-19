# wheh? I don't think the following are needed anywhere:
# ss=.35
# qs=1.7

find . -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
mapfile -t fractal_flames_list < fractal_flames_list.txt
for element in "${fractal_flames_list[@]}"
do
	# echo elm. is $element
	# Because I don't know why it doesn't work with the -i switch, write to a temp file, then delete the original and rename the temp file to the original:
	# sed 's/\(.*\)\(size=\"\)\([0-9 ]\{1,\}\)\(\".*\)/\1\22160 1080\4/g' $element > wut.txt
	sed 's/\(.*\)\(size=\"\)\([0-9 ]\{1,\}\)\(\".*\)/\1\2800 592\4/g' $element > wut.txt
	rm $element
	mv wut.txt $element
done

rm fractal_flames_list.txt