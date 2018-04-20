# DESCRIPTION
# Generates a random fractal flame hex color palette, in a randomly named new palette xml file.

# USAGE
# Invoke the script to create a fractal flame hex color palette of 256 random colors. To generate more than one, pass it one parameter, being the number desired.

# TO DO
# Make this generate palettes in a subdir, and work in that subdir.

# PREP BEGIN
# PARAMATER CHECKS and resulting variable initialization.
if [ -z ${1+x} ]
	then
	howMany=1
	else
	howMany=$1
fi
		echo how many is $howMany

# To force tr to operate on non-text (urandom) output:
export LC_CTYPE=C

count=0
for a in $( seq $howMany )
do
	# print beginning xml to randomly named new palette file.
	paletteName=`cat /dev/urandom | tr -dc 'a-hj-km-np-zA-HJ-KM-NP-Z2-9' | head -c 34`
	printf "<palette number=\"$count\" name=\"$paletteName\" data=\"" > RND_palette_"$paletteName".xml

	# generate palette hex. 256 colors per palette; broken down into 32 lines of 48 hex characters (before 00 padding between hex colors, which brings it to 64).
	# supaHexBlock=`cat /dev/urandom | tr -dc 'a-f0-9' | head -c $((32 * 48))`
		# limit to not-so-dark colors:
		supaHexBlock=`cat /dev/urandom | tr -dc '5-9a-f' | head -c $((32 * 48))`
			# echo ---
			echo supaHexBlock val before is\: $supaHexBlock
	supaHexBlock=`echo $supaHexBlock | sed 's/\([a-z0-9]\{6\}\)/00\1/g'`
			# echo ---
			# echo supaHexBlock val after is\: $supaHexBlock
	# append random palette hex to xml, formatted with newlines per 64 hex chars:
	# re genius breath (someday I'll just power learn sed?) : http://stackoverflow.com/a/1187225
	echo $supaHexBlock | sed -e 's/.\{64\}/&\n/g' >> RND_palette_"$paletteName".xml

	# trim resultant redundant blank lines at end of file; re genius breath at: http://stackoverflow.com/q/16414410
	sed -i '/^$/d' RND_palette_"$paletteName".xml
	# MAC ALTERNATE re: http://www.markhneedham.com/blog/2011/01/14/sed-sed-1-invalid-command-code-r-on-mac-os-x/
	# sed -i "" '/^$/d' RND_palette_"$paletteName".xml

	# append closing xml to file.
	printf "\"/>\n" >> RND_palette_"$paletteName".xml

	# Convert to windows line endings which emberrender expects (else fails!) ; n/a for mac or other natively 'nix environments:
	# unix2dos RND_palette_"$paletteName".xml
	count=$(( $count + 1 ))
done

printf "<palettes>\n" > RNDxmlPaletteGenTempHead.txt
printf "</palettes>" > RNDxmlPaletteGenTempTail.txt
cat RNDxmlPaletteGenTempHead.txt *.xml RNDxmlPaletteGenTempTail.txt > RNDxmlPaletteGenTempCombined.txt
rm RNDxmlPaletteGenTempHead.txt RNDxmlPaletteGenTempTail.txt
mkdir grp0000x
mv *.xml ./grp0000x
mv RNDxmlPaletteGenTempCombined.txt _grp0000x_palettes.xml
