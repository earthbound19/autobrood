# Establish ridiculous bool that tells us whether to copy / later delete a file (see comment near end of script) ; this is ONLY for the case where this script is foolishly executed ;) in the only directory where this master test fractal flame file is kept:
if ! [ -e ./_test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame ]
	then
	echo does not exist. will copy and later delete.
		cat /cygdrive/c/autobrood/batch-scripts/_test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame > _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
		LATER_DELETE__test_wexEheVtcfysXww27E4g8JmeeCHBFVXH_flame_whatAnAwesomeVariableName=1
fi

cat /cygdrive/c/autobrood/bin/fractorium_openCL_GPU_fractal_flames/flam3-palettes.xml > flam3-palettes.xml

EmberRender.exe --in=testfail.flame --out=test.png --format=png --progress --ss=.06 --qs=.4
errorLevel=$?

echo ~-~-
if ! [ "$errorLevel" == 0 ]
	then
		echo error encountered executing command: $errorLevel
	else
		echo no error encountered in executing command
fi
echo ~-~-

EmberRender.exe --in=_test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame --out=test.png --format=png --progress --opencl --ss=.2 --qs=1
errorLevel=$?

echo ~-~-
if ! [ "$errorLevel" == 0 ]
	then
		echo error encountered executing command: $errorLevel
	else
		echo no error encountered in executing command
fi
echo ~-~-

rm flam3-palettes.xml
# Only delete the given ~.flame file if it was not here (according to this AWESOME bool) before we ran this script. Otherwise, leave it there (do not delete it):
if [ "$LATER_DELETE__test_wexEheVtcfysXww27E4g8JmeeCHBFVXH_flame_whatAnAwesomeVariableName" == 1 ]
	then
		echo Since _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH\.flame did not exist in this directory before this script was run\, and I copied it here\, and you don\'t need it here\, and this excessive comment is informing you of this fact\, I WILL delete said file.
		rm _test_wexEheVtcfysXww27E4g8JmeeCHBFVXH.flame
	else
		echo That does not equal one. I will NOT delete. What\? Correct. See comments at end of script.
fi