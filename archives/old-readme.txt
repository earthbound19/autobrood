Any changes or additions to this help file will be at:

http://openhatch.net/wiki/index.php?title=Auto-brood


=BRIEFLY=

	The scripts in the batch-scripts folder do a variety of jobs, like gathering random genomes from the web, interbreeding collected genomes, or rendering quick image previews.  In the root folder, the script auto-brood.bat does all those together.  There is also a script for higher-resolution renders.

	NOTE: If you keep these in a folder named "Apophysis & Electric Sheep", or if any folder in the tree (or PATH) has non-alphanumeric characters in its name, the scripts won't work.  For this example, naming the folder "Apophysis and Electric Sheep" (no ampersand) will fix it.  That tripped me up at one point :)

=MORE DETAIL=

	On line 1 of auto-brood.bat you can change the total number of genomes to retrieve.  Pure random numbers pulled realtime from random.org are used for every decision (you must be online to use these retrieval scripts - also, some environments - such as a university computer lab or corporate LAN - might firewall any command-line http traffic, and in such cases you won't be able to get any useful data from these batch scripts).  Electric Sheep flock 202 is used by default; optionally you can also use flocks 242 and 243.  To use flocks 242 and 243, remove the REM from line 3 of auto-brood.bat and move it to line 2 (so that fetch-random-genomes.bat is not commented).  If using more than one flock, it is randomly decided how many genomes are used and from which flock, until the total number of genomes you've specified have been retrieved.  All gathered genomes are then interbred without repeating any pair, and quick image thumbnails of all the genetic "children" are rendered.  The result is original images created from purely random selection, whose genomes you can select at your pleasure for higher resolution renders.

	If you copy electric sheep images in the name format electricsheep.243.9978.png into the brood folder before running the batch, it will also gather the genomes for those images and then cross-breed them.

	If run multiple times, the batch will not overwrite existing genomes, re-render existing images, or re-breed existing breeds.  Therefore you may add random new genes to a "pool" to cross-breed with already chosen genes.

	These scripts are released under the newest Creative Commons Share-Alike Attrib license, and credit to the author Richard Alexander Hall is requested for any public use.

	The Fractal Flame generation, manipulation, rendering and animating tools included with this distribution are freely available at flam3.com - and I thank their creators and progammers.


==RUNNING BATCH FILES DIRECTLY==

To quickly create a command line environment with both this directory (from which you've opened this readme file) and the batch-scripts directory in your PATH (so that you can invoke the scripts from any directory), open a command-line (start menu->run cmd on Windows XP, or start->search->command on Windows Vista) and run set-env.bat.

I highly recommend the free Send To Toys 2.5 application, available at the following page -

http://www.gabrieleponti.com/software/

- this application can install a right-click "send to" menu that allows you to right-click any file in a standard Windows Explorer folder view, then open a command line to the current directory and automatically type the file name.  This can save a lot of navigating, typing and fumbling around - moreso if you _permanently_ add the directories of these scripts to your PATH.  To do this in Windows XP, right-click My Computer, or go to System in the Control Panel, then the Advanced tab, Environment Variables button (at the bottom).  In the System Variables list, find and double-click on Path.  Click in the open text box, press the End key to jump to the end, type a semicolon ; and then copy and paste the path to the directory in which this help file is located.  Then type another semicolon ; and paste the same thing again, adding \batch-scripts to the end.  Click OK to save the setting.  Now you can very quickly start rendering from any sheep genome by right-clicking it, sending it to a command prompt, pressing the Home key from the prompt to jump to the start of the file-name, and typing render-sheep, then pressing spacebar.  Bingo - you've got -

render-sheep electricsheep.243.9978.flam3

- on your command-line, so if you press enter it will invoke my script (see the next) to start rendering the genome.


===RENDER-SHEEP.BAT===

The comments in render-sheep.bat explain it in more detail (including how to make it render at various standard resolutions and aspect ratios).  I think it doesn't mention it renders to an image-output subdirectory.


===BREED-SHEEP.BAT===

The breed-sheep batch file expects three paramaters: %1 is the name of a first .flam3 or .flame file, %2 is another such file to crossbreed it with, and %3 (optional, it is set to all_types by default) is the breeding or mutating method.  An example of invoking the script would be:

breed-sheep electricsheep.202.120397.flam3 electricsheep.242.1248.flam3 union

Possible mutation methods are alternate, interpolate, and union.

This script will check for an "all_types" environment variable (without quotes) and if that is defined, it will do all three types automatically.  Also, if a "breed_all" environment variable is set, it will automatically interbreed all .flame and/or .flam3 genomes in the directory, without accounting for paired order, but also without repeating any pair (maximimum number of combinations without repetition, order doesn't matter) - and it will also do all 3 types of breeding for each pair (so it will set all_types automatically).

To get an exact figure for how many children will result from how many sheep (assuming none of the sheep are impotent), use this web site -

http://www.mathsisfun.com/combinatorics/combinations-permutations-calculator.html

- and enter the number of parents under "types to choose from", with "number chosen" set to 2, and the options "Is Order Important?" to no, and "Is Repetition Allowed?" to no.  Then multiply the resulting number by 3 (for the three union types).


===RENDER-SHEEP-THUMBS.BAT===

This will invoke flam3-render repeatedly to output quick thumbnails of every genome in a directory.


===ABORT-SHEEP.BAT===

This is for deleting undesired children and parent sheep after interbreeding.  It won't run willy-nilly if accidentally clicked; you have to press a key again to confirm deleting both children and parents.  How it works: in the brood\children folder, delete the thumbnail of every child who is undesireable (this is easier using a program like IrfanView and pressing the space bar to cycle through images in a directory, then pressing Delete for every unwanted image - or by simply having windows view the directory as thumbnails).  Then, at the command prompt and still from the \children directory, run abort-sheep.bat.  It will delete every genome for which there is not any matching image.  It will then navigate to the parent directory (\brood above \brood\children) and delete every parent which produced no desireable children.

(Informationally, abort-sheep.bat reuses some code from fetch-image-genomes.bat.)


===FETCH-GENOME.BAT===

Call this script thusly:

fetch-genome 202.107792

OR 

fetch-genome 243.09722

OR

fetch-genome 242.2910

- and it will fetch said genome from the internet repository.  By the way, those particular genomes (which I used as examples) are among my favorites.

(Informationally, fetch-genome is a hacked variant of fetch-image-genomes.bat.)


===JReplace.jar===

I didn't write this code, but find it very useful for this: searching through multiple text files and replacing.  I use it to alter the size information in genomes.  It requires a Java run-time environment.

===A note on creating Sheep animations===

To create electric-sheep style *animations* from genomes, find and play with the RenderFlam3 script.


=GRATUITOUS DETAIL ON HOW THE BATCH SCRIPTS WORK=

	Much more detail on this - auto-brood.bat runs other batch files (and passes paramaters to them) that do the following:
	1. Create a directory named brood if it doesn't exist
	2. It calls fetch-random-genomes.bat, which does the following:
	Using the value numRandomSheep set in the first line of auto-brood.bat, it downloads that many genomes from three different flocks (202, 242, and 243).  Say that numRandomSheep is 13; it determines how many sheep genomes to pull from each flock to total 13.  For example it could download 8 genomes from flock 202, 2 from flock 242, and 3 from flock 243, or 8+2+3 genomes = 13 total genomes.  It determines how to divy up the 13 genomes between flocks by pulling pure random numbers from the random.org service.
	About random.org - that web site serves pure or completely unpredictable random numbers by measuring radio decay to form the raw data from which numbers are made.  Following is an example random.org number retrieval link.  I use the wget html utility (ported from Unix to Windows) to pull numbers from such a link -

http://www.random.org/integers/?num=13&min=1&max=134344&col=13&base=10&format=plain&rnd=new

Try copying and pasting that link into a web browser.  Random.org will give you 13 purely random numbers in the range 1 to 134344, in plain text format, separated by tabs.  The above link is exactly the link used by this script if you set numRandomSheep to 13.

	3. Now that it knows how many genomes from each flock it will retrieve, it pulls the status of the Electric Sheep flocks from their web servers (by searching through the retrieved status html files with a regular expression; under the command-line FINDSTR function) to approximate the newest available genome number (or sheep ID) per flock.  For each flock it downloads the randomly determined number of genomes, choosing between 1 and the highest available genome number per flock - again using the random.org pure random number service.  It saves these genomes in the brood folder.
	4. It calls fetch-image-genomes.bat, which scans the brood directory for files in the format electricsheep.gen.ID.png or .jpg - for example electricsheep.202.52858.jpg, or electricsheep.242.3116.png, etc.  The first number separated by periods is the genome's flock, and the second number is the genome number.  It uses that format to get the genome from the right server.  This way you can easily get the genomes for hastily collected favorite sheep images :) or fool it into retrieving whatever you want by renaming a text file to that format.
	5. It calls render-sheep-thumbs.bat to quickly render preview images from all these "parent" genomes.
	6. It calls breed-sheep.bat, which does the following:
	It interbreeds the genomes collected in the brood folder, using flam3-genome.  One sheep is taken and bred with every other available sheep, then set aside, another sheep is taken and interbred with them all, then set aside, and so on, until the maximum number of available combinations without repetition is done.  Since there are three different ways (that I know about anyway) to breed sheep, you get three times that many sheep children.  Impotent sheep are socially stigmatized and abandoned (renamed).  (I think there's a bug serving some genomes from the server?)  All the resulting genomes are saved to a children sub-folder.
	7. It calls render-sheep-thumbs.bat in the children sub-folder, to quickly render previews of all resulting children, which you may peruse at your pleasure.  You may pick out the prettier resulting sheep (of course that's subjective) and render them at higher resolution by passing the genome file name to render-sheep.bat - say for example one of the resulting sheep genomes is 202.120397_and_242.1248_union.flam3 - which, appropriate for this discussion of Electric Sheep breeding, happens to render what looks something like a luminous cyborg sperm penetrating the ovum of the mother Cylon, or whatever.  You would render a larger image of it by typing this on the command line:

render-sheep 202.120397_and_242.1248_union.flam3
