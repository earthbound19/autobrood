# TO DO: create parameter set scripts that invoke this with given parameters, instead of changing this script per anim run.
# TO DO ? : Make a script that calls all these in the preferred order, instead of hard-coding these to that end? :
# render-flames-fractorium.sh floofyFloo

# Uh, but the following line isn't necessary if the previous script ran:
# if [ ! -d render_output ]; then mkdir render_output; fi

# . . . and the following line as well is only necessary if run from a directory where the last mentioned directory was created:
# cd render_output

# ffmpeg -y -f image2 -i _alles_anim-%07d.flam3.png -vcodec utvideo -r 29.97 _alles_anim.avi

	# render size options:
	# -filter:v "crop=1280:720:x:y"
	# -filter:v "crop=1920:1080:x:y"
# ffmpeg -y -i _alles_anim.avi -filter:v "crop=1920:1080:x:y" -crf 10 _alles_anim.mp4
# ffmpeg -y -i _alles_anim.avi -filter:v "crop=1280:720:x:y" -crf 10 _alles_anim.mp4
ffmpeg -y -f image2 -i _alles_anim-%07d.flam3.png -vf resize:1280:-1:x:y -filter:v "crop=1280:720:x:y" -crf 16 _alles_anim.mp4
# ffmpeg -y -i _alles_anim.avi -filter:v "crop=640:350:x:y" -crf 14 _alles_anim.mp4
# ffmpeg -y -i _alles_anim.avi -crf 13 _alles_anim.mp4
# to rescale: -vf resize:<xpixels>:-1:x:y

# Wheh? Think I don't need the next line:
# if [ ! -d vid ]; then mkdir vid; fi
mv ./_alles_anim.avi ./vid/_alles_anim.avi
mv ./_alles_anim.mp4 ./vid/_alles_anim.mp4

# cd ..