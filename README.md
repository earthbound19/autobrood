# autobrood
Scripts to mass crossbreed, select and render fractal flames (many of which are also called "Electric Sheep").

# Dependencies
A cygwin environment on windows; or the scripts may work in a 'nix environment (and some _do_ work in a Mac envrionment) with the necessary programs and dependencies installed.

Some necessary dependencies are included. The dependencies for xml_split you must install manually; install them with `/_setup/_installDependencies.sh`

At this writing, many of the scripts are defunct for various reasons and need reworking, but many of them work, also.

Get the binaries in the `/bin` subfolders appropriate for your platform in your $PATH, or for Mac, install fractorium from the distribution package and add to your path the console apps in that package: `/Applications/Fractorium.app/Contents/MacOS`

# LICENSE
All of my original contributions here (e.g. the batch scripts) I dedicate to the Public Domain.

# TO DO
- Make the looping over file names consistent in all scripts, modeled after renderFlamesFractorium.sh
- Clean up this README.md?
- Manage --opencl flag in render parameters as appropriate
- Process substitution where otherwise I've been using so many temp files? Re:
https://en.wikipedia.org/wiki/Process_substitution
- Expand documentation
- Correct / update this TO DO list
- Rework any defunct scripts
- What to do with hard-coded local dependencies vs. using what's in my `_devtools` repository?
- Port everything to 'nix /.sh scripts?
- See if I can get flam3-render to compile and render on 'nix first--render the newest fractal flame types at this writing, 06/05/2016.
 - And in that port, use render flag temp files that are not the original file, as they can more easily and harmlessly be deleted than renaming so many incorrectly named files.
- Resurrect example scripts in `_archives_old.7z/examples/example-brood-1` or create something like them. Make the example scripts not hard-coded to their particular directory (use POPD / PUSHD or a 'nix equiv. instead) ; relative paths not absolute.
- Update or archive to ./archivesOld.7z all scripts which rely on outdated info (e.g. bad URLs.)
- Correct extracted sheep file names in `./_resources.7z`
- Modify batches to pull from those resources (if the .7z archive is expanded).

## HISTORY (reverse-chronological)

- 2018-04-19 Some scripts updates for portability, binaries reorganize, freshen Mac emberrender etc.
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

### Dev notes
What done the split of all 242.xml.txt into individual .xml (later .flam3) files for every sheep in the flock was this command:

cygwin command:
xml_split all_242.xml

. . . and somehow I installed something on cygwin to get that command. xml twig?

previous, working, far less efficient method, from bash:

RE: http://www.labnol.org/software/wget-command-examples/28750/
wget --execute robots=off --recursive --no-parent --accept flam3,html --no-clobber http://electricsheep.com/archives/generation-242/

----
There are 2,013,183 possible children among all the sheep in generation 242, if you mutate each pair three different ways.

http://www.wolframalpha.com/input/?i=combinations+of+1159+select+2

It is feasible to thus cross-breed them all and render thumbnails for all of them. But it may be an enormous undertaking.