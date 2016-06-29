# DESCRIPTION:
# concatenates all .mp4 files in a directory into one output file. Source files must all be encoded with the same codec and settings.

# USAGE:
# Ensure this script is in your $PATH, and invoke it from a directory with .mp4 files that are encoded the same way. The result will appear in _mp4sConcatenated.mp4.

# DEPENDENCIES: ffmpeg and a 'nix system (can be cygwin for Windows).

# TO DO: provide for paramaterized vid file extension. For now default .mp4.

vidExt=mp4

ls *.$vidExt > all$vidExt.txt
sed -i "s/^\(.*\)/file '\1'/g" all$vidExt.txt
ffmpeg -f concat -i all$vidExt.txt -c copy _"$vidExt"sConcatenated.$vidExt
rm all$vidExt.txt

echo DONE. See result file _"$vidExt"sConcatenated.mp4 and rename/move it as you may.