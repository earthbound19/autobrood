# NOTE: you must hack the flock_id variable depending on the flock. ALSO, change the numDigits to match the number of digits in the highest numbered sheep.

flock_ID=242
digits=4

find . -iname \*.flam3 -o -iname \*.flame > all_flames.txt
mapfile -t all_flames < all_flames.txt

for element in "${all_flames[@]}"
do
	# echo element is\:
	# echo $element
	# echo with id\:
	sheep_ID=`sed -n 's/.*sheep id="\([0-9]\{1,\}\).*/\1/p' $element`
	# change sheep_ID value to be padded with zeros if necessary, according to $digits:
	printf -v sheep_ID %0"$digits"d $sheep_ID
	# if the target sheep rename does not exist (is not the same as the source), rename it.
	# echo val of sheep_ID is
	# echo $sheep_ID
	if [ ! -e ./electricsheep_$flock_ID\.$sheep_ID\.flam3 ]
	then
		# meep=mepp
		mv $element ./electricsheep_$flock_ID\.$sheep_ID\.flam3
	fi
done

rm all_flames.txt
