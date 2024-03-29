ss=2.4
qs=3.7

find . -maxdepth 1 -iname \*.flam3 -o -iname \*.flame > fractal_flames_list.txt
# filter the ./ off the start of that list (it messes up later file checks if read from a list) :
sed -i 's/^\.\/\(.*\)/\1/g' fractal_flames_list.txt

while read element
do
	# echo elm. is $element
	flam3-render < $element
done < fractal_flames_list.txt