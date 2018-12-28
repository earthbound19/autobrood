# DESCRIPTION:
# concatenates all .mp4 files in a directory into one output file. Source files must all be encoded with the same codec and settings.

# USAGE:
# Ensure this script is in your $PATH, and invoke it from a directory with .mp4 files that are encoded the same way. The result will appear in _mp4sConcatenated.mp4.

# DEPENDENCIES: ffmpeg and a 'nix system (can be cygwin for Windows).

# TO DO: provide for paramaterized vid file extension. For now default .mp4.

vidExt=mp4

# if [ ! -d vidListOdds ]; then mkdir vidListOdds; fi

ls *.$vidExt > all$vidExt.txt
gsed -i "s/^\(.*\)/file '\1'/g" all$vidExt.txt
printf "" > vidListOdds.txt

mapfile -t allVidFiles < all$vidExt.txt
loop_iter=0
for element in "${allVidFiles[@]}"
do
echo elm is $element
	loop_iter=$((loop_iter + 1))
	# To change to concat. even numbered files, put a ! in front of the expression: ! ((loop_iter % 2 == 0))
	if ((loop_iter % 2 == 0)); then
		echo ============= file number $loop_iter is odd. will add to concat. list.
		echo $element >> vidListOdds.txt
	fi					
done

ffmpeg -y -f concat -i vidListOdds.txt -c copy _vidListOdds.$vidExt
rm all$vidExt.txt vidListOdds.txt

echo DONE. See result file _vidListOdds.mp4 and rename or move it as you may.