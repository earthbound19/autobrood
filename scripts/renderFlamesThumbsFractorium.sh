# NOTE that ss and qs must be set as explicit parameters for EmberRender.exe --it doesn't import any environment variables by those names. ALSO, if it throws an error about not loading a pallete xml file, temporarily copy the file of that name into the directory for which you run this render script.

# ALSO NOTE: for now (or forever?) it outputs target renders in the same directory as the source flame file.

# TO DO: change this to just a script that sets ss and qs values and passes them via ENDLOCAL & whatever to render-flames-fractorium.bat (or .sh)?

# Fixed? The following if block didn't (doesn't?) work as expected:
if ! [ -d render_output ]; then mkdir render_output; fi

find . -maxdepth 1 -iname \*.flame -o -iname \*.flam3 > fractal_flames_list.txt
    
# Optional specifier of device to use:
# deviceParam="--device 1"

while read element
do
  # filter the ./ off the start of that list (it messes up later file checks if read from a list) :
  element=${element%.*}

  # Only render the frame if the target render file does not exist; NOTE that the find command searches subfolders too (to only search the current folder, pass `-maxdepth 1`) :
	foundCount=`find . -name $element.png | wc -l`
	if [ $foundCount == "0" ]		
	# NOTE for the following command: for 800 x 592 or whatever flame, ss=2.4 offers high def (1080p) image area. ss=1.6 offers HD 720p area.
	then
		echo Target file $element.png does not exist. Will render.
		# EmberRender doesn't seem to be able to render the file into another directory, so we're rendering the image into the same directory as the source .flam3 file, then moving it to a subdir.
		emberrender --in=$element --out=$element.png --format=png --progress --ss=.64 --qs=8 $deviceParam
		mv $element.png ./render_output/$element.png
	else
		echo Target file $element.png already exists\; SKIPPING render.
	fi
done < fractal_flames_list.txt