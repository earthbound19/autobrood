# GLOBALS:
sheepDir=`cygpath -u "C:\_resources\gen242"`
sheepToFetch=18

ls $sheepDir > sheep.txt
mapfile -t sheep < sheep.txt
rm sheep.txt
numSheep=${#sheep[@]}
# get n random numbers in range of number of genome files; re http://stackoverflow.com/a/2567569/1397555
seq 1 $numSheep | sort -R | head -n $sheepToFetch > gen242randomGenomes.txt

mapfile -t randomSheepIndexes < gen242randomGenomes.txt
rm gen242randomGenomes.txt

# create directory named after current date, time and microsecond, to put our randomly collected sheep genomes in:
timeStamp=`date +"%Y_%d_%m__%H_%M_%S__%N"`
broodDir=brood_$timeStamp
mkdir $broodDir
cd $broodDir

for element in "${randomSheepIndexes[@]}"
do
	cp "$sheepDir"/"${sheep[$element]}" .
done

cd ..
# Optional; comment out the above line if used:
# render-flames-fractorium.sh foo