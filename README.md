# autobrood
Scripts to mass crossbreed, select and render fractal flames (many of which are also called "Electric Sheep").

# Dependencies
A cygwin environment on windows; or the scripts may work in a 'nix environment with the necessary programs and dependencies installed.

Some necessary dependencies are included. The dependencies for xml_split you must install manually; install them with /_setup/_installDependencies.sh

At this writing, many of the scripts are defunct for various reasons and need reworking, but many of them work, also.

At this writing I'm toying with getting the mac CLI emberrender etc tool to work by installing from the downloaded .dmg from [fractorium.com](http://fractorium.com/) -- here is the [package downlaod URL therefrom](https://drive.google.com/file/d/11mu6K7im7KweMmyg8aui-EoAut4kSX1X/view?usp=sharing) and then adding this to the system $PATH: /Applications/Fractorium.app/Contents/MacOS

# LICENSE
All of my original contributions here (e.g. the batch scripts) I dedicate to the Public Domain.

# TO DO
- Expand documentation
- Correct / update this TO DO list
- Rework any defunct scripts
- What to do with hard-coded local dependencies vs. using what's in my _devtools repository?
- Port everything to 'nix /.sh scripts?
- See if I can get flam3-render to compile and render on 'nix first--render the newest fractal flame types at this writing, 06/05/2016.
 - And in that port, use render flag temp files that are not the original file, as they can more easily and harmlessly be deleted than renaming so many incorrectly named files.
- Resurrect example scripts in _archives_old.7z/examples/example-brood-1 or create something like them. Make the example scripts not hard-coded to their particular directory (use POPD / PUSHD or a 'nix equiv. instead) ; relative paths not absolute.
- Update or archive to ./archivesOld.7z all scripts which rely on outdated info (e.g. bad URLs.)
- Correct extracted sheep file names in ./_resources.7z
- Modify batches to pull from those resources (if the .7z archive is expanded).
- Remove this list item which is nothing doing with here, but cool: http://betanews.com/2014/11/25/select-random-files-in-explorer-with-random-selection-tool/

## HISTORY (reverse-chronological)

- 2018-03-27 Some repo reorganizing, consolidate disparate notes in README.md
- 2016-07-05 Added dependency source and instructions to install xml_split on cygwin.
- pre 2012-03-09
 - Updated sheep breed and render batches multi-breed-sheep.bat and multi-render-thumbs.bat which offer rudimentary, brute-force facility to use CPU affinity command line feature of windows 7. Further work on that remains in TODO list. Laid out further work for that with get-cpu-cores.bat.
- Made fix-breed-sheep.bat and fix-render-sheep-thumbs.bat to correct renamed temp files of batch left straggling in incorrect-name state via batch termination.
- 2012-03-09
 - Updated render-sheep.bat to use free MATH.EXE tool from http://www.hyperionics.com/calculator/index.asp, which is compatible with windows XP and 7, where the (evidently ancient--in computer terms) free CC.EXE command-line calculator, whose source I can no longer find, was not compatible with Windows 7.
 - Had first revised it to use SET /a native windows command and switch, but discovered again this only does integer arithmetic, where MATH.EXE will do decimel arithmetic.
 - Batch provides more useful ECHO feedback when run.
 - Made select-renders.bat which eases selection from large pool of interbred genomes for full-scale renders (see notes in batch).
 - Found that running multiple VERY large-scale renders (on multiple cores) will choke a typical machine and flam3-render will repeatedly skip renders in all but one process for inability to allocate needed memory resources to render...depending, I suppose, on what size renders you're trying to make :) But a 4-core 2.9 GHZ machine can run four renders of about 1080x1024 at the same time!
- 2016-06-05 revived and figured out how I had this working. Will probably want to port all scripts to 'nix on account maybe newest flam3 renderer / cross-breeder may only be on 'nix (flam3 windows development apparently forsaken). Posting to public repository . . .