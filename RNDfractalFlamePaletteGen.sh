# DESCRIPTION
# Generates a random fractal flame hex color palette, in a randomly named new palette xml file.

# USAGE
# Invoke the script to create a fractal flame hex color palette of 256 random colors. To generate more than one, pass it one parameter, being the number desired.

# PREP BEGIN
# PARAMATER CHECKS and resulting variable initialization.
if [ -z ${1+x} ]
	then
	howMany=1
	else
	howMany=$1
fi
		echo how many is $howMany

for a in $( seq $howMany )
do
	# print beginning xml to randomly named new palette file.
	paletteName=`cat /dev/urandom | tr -dc 'a-hj-km-np-zA-HJ-KM-NP-Z2-9' | head -c 34`
	printf "<palettes>
	<palette number=\"0\" name=\"$paletteName\" data=\"" > RND_palette_"$paletteName".xml

	# generate palette hex. 256 colors per palette; broken down into 32 lines of 48 hex characters (before 00 padding between hex colors, which brings it to 64).
	supaHexBlock=`cat /dev/urandom | tr -dc 'a-f0-9' | head -c $((32 * 48))`
			# echo ---
			# echo supaHexBlock val before is\: $supaHexBlock
	supaHexBlock=`echo $supaHexBlock | sed 's/\([a-z0-9]\{6\}\)/00\1/g'`
			# echo ---
			# echo supaHexBlock val after is\: $supaHexBlock
	# append random palette hex to xml, formatted with newlines per 64 hex chars:
	# re genius breath (someday I'll just power learn sed?) : http://stackoverflow.com/a/1187225
	echo $supaHexBlock | sed -e 's/.\{64\}/&\n/g' >> RND_palette_"$paletteName".xml

	# trim resultant redundant blank lines at end of file; re genius breath at: http://stackoverflow.com/q/16414410
	sed -i '/^$/d' RND_palette_"$paletteName".xml

	# append closing xml to file.
	printf "\"/>
	</palettes>" >> RND_palette_"$paletteName".xml

	# Convert to windows line endings which emberrender expects (else fails!) :
	unix2dos RND_palette_"$paletteName".xml
done