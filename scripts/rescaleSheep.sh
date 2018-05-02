# wheh? I don't think the following are needed anywhere:
# ss=.35
# qs=1.7

find . -maxdepth 1 -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
# filter the ./ off the start of that list (it messes up later file checks if read from a list) :
gsed -i 's/^\.\/\(.*\)/\1/g' fractal_flames_list.txt

while read element
do
	# echo elm. is $element
	# Because I don't know why it doesn't work with the -i switch, write to a temp file, then delete the original and rename the temp file to the original:
	# sed 's/\(.*\)\(size=\"\)\([0-9 ]\{1,\}\)\(\".*\)/\1\22160 1080\4/g' $element > wut.txt
	sed 's/\(.*\)\(size=\"\)\([0-9 ]\{1,\}\)\(\".*\)/\1\2800 592\4/g' $element > wut.txt
	rm $element
	mv wut.txt $element
done < fractal_flames_list.txt