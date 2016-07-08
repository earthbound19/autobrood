render-flames-fractorium.sh floofyFloo

if [ ! -d render_output ]; then mkdir render_output; fi

cd render_output

ffmpeg -y -r 29.97 -f image2 -i _alles_anim-%07d.flam3.png -vcodec utvideo -r 29.97 _alles_anim.avi
	# render size options:
	# -filter:v "crop=1280:720:x:y"
	# -filter:v "crop=1920:1080:x:y"
# ffmpeg -y -i _alles_anim.avi -filter:v "crop=1920:1080:x:y" -crf 10 _alles_anim.mp4
# ffmpeg -y -i _alles_anim.avi -filter:v "crop=1920:1080:x:y" -crf 10 _alles_anim.mp4
ffmpeg -y -i _alles_anim.avi -filter:v "crop=640:350:x:y" -crf 14 _alles_anim.mp4
# ffmpeg -y -i _alles_anim.avi -crf 13 _alles_anim.mp4
# to rescale: -vf resize:<xpixels>:-1:x:y

if [ ! -d vid ]; then mkdir vid; fi
mv ./_alles_anim.avi ./vid/_alles_anim.avi
mv ./_alles_anim.mp4 ./vid/_alles_anim.mp4

cd ..