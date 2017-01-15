# highest monster resolution (for computer monitors and/or TVs) available anywhere may be 7,680 by 4,320; next under that  may be 3,840 by 2,160, re: https://www.extremetech.com/extreme/174221-no-tv-makers-4k-and-uhd-are-not-the-same-thing -- also see again https://en.wikipedia.org/wiki/Display_resolution

# ss=1.82
ss=2.1875
qs=280
shortRestPeriod=38
restIntervalMultiplier=20
mediumRestPeriod=2650
nthreads=7

# ...

if [ ! -d render_output ]; then mkdir render_output; fi

imgs_iter=1
# TO DO: get an ALL-PLATFORMS working command where now you have cygfind, and/or use brew gnucoreutils install of find without default name; where previously the script had a well-working CygwinFind command instead of this ls command:
ls *.flame  > fractal_flames_list.txt
while IFS= read -r element; do
	echo ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
			renderTarget="$element".png
					echo target file $renderTarget does not exist in this or any subfolder. will render.
# TO DO: detect platform and either prefix ./ or not, depending:
							# echo running command: ./emberrender --in=$element --out=$element.png --format=png --progress $openclFlag --ss=$ss --qs=$qs
							# echo image $imgs_iter of ${#fractal_flames_list[@]}
							echo rendering image number $imgs_iter . . .
							# printf "rendering an image for this file name . . ." > ./render_output/$element.txt
					./emberrender --in=$element --out=$element.png --format=png $openclFlag --ss=$ss --qs=$qs --nthreads=$nthreads
					# rm ./render_output/$element.txt
					mv $element.png ./render_output/
							imgs_iter=$((imgs_iter + 1))
					if (( $imgs_iter % $restIntervalMultiplier == 0 )); then echo I have rendered 125 images\, and I am resting for $mediumRestPeriod seconds to cool down.; sleep $mediumRestPeriod; fi
					echo Render complete\; sleeping to allow computer to cool for $shortRestPeriod seconds . . .
					echo ~-~-~-~-~-~-~-~-~-~-
					sleep $shortRestPeriod
done < fractal_flames_list.txt
