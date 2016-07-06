EmberRender.exe --in=testfail.flame --out=test.png --format=png --progress --ss=.06 --qs=.4
errorLevel=$?

if ! (( $var_nframes )); then var_nframes=12; fi

echo ~-~-
if ! [ "$errorLevel" == 0 ]
	then
		echo error encountered executing command: $errorLevel
	else
		echo no error encountered in executing command
fi
echo ~-~-

EmberRender.exe --in=test.flame --out=test.png --format=png --progress --ss=.06 --qs=.4
errorLevel=$?

if ! (( $var_nframes )); then var_nframes=12; fi

echo ~-~-
if ! [ "$errorLevel" == 0 ]
	then
		echo error encountered executing command: $errorLevel
	else
		echo no error encountered in executing command
fi
echo ~-~-