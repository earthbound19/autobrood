# GLOBALS:
sheepDir=`cygpath -u "C:\_resources\gen242"`
sheepToFetch=13

ls $sheepDir > sheep.txt
mapfile -t sheep < sheep.txt
rm sheep.txt
numSheep=${#sheep[@]}
# get n random numbers in range of number of genome files; re http://stackoverflow.com/a/2567569/1397555
seq 1 $numSheep | sort -R | head -n $sheepToFetch > gen242randomGenomes.txt

mapfile -t randomSheepIndexes < gen242randomGenomes.txt
rm gen242randomGenomes.txt

for element in "${randomSheepIndexes[@]}"
do
	cp "$sheepDir"/"${sheep[$element]}" .
done