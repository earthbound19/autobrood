# DESCRIPTION
# Installs Windows dependencies for this autobrood repository's
# scripts, if you wish to run them from Cygwin.

# DEPENDENCIES
# wget with https capability (since now everyone in the universe is encrypting all web traffice even if needlessly), which you can get and get in your path via my _ebSuperBin and _ebPathMan repositories. Cygwin.

# NOTES
# For at least the chere -i -t mintty command to work, you may need to run this from a cygwin prompt started as a Windows Administrator.
# If install fails (canna download from mirror), try:
# apt-cyg mirror "mirror site"
# --using a mirror URL from this page's list:
# e.g.:
# apt-cyg mirror "ftp://mirrors.syringanetworks.net/cygwin/"
# re: http://superuser.com/a/941135
# ALSO, mysteriously, installing perl xml_twig via cygwin may solve any errors after this script successfully runs all commands. 
# PREVIOUS DOWNLOAD COMMANDS used: curl -LO <that-web-address>

# TO DO: apt-cyg check (which apt-cyg) and auto-install of perl and ~libxml, wget.

echo This script will attempt to install dependencies needed for the \.sh scripts in autobrood to work under Cygwin. You may need to install wget via the cygwin installer for this to work. If you see \"connection refused\" errors\, try running the Cygwin installer again\, selecting a different mirror\, and reinstalling wget to make that mirror \"stick\" \(I don\'t even know if reinstalling anything is necessary\, though\)\.
echo "!============================================================"
read -p "DO YOU WISH TO CONTINUE running this script? : y/n" CONDITION;
if [ "$CONDITION" == "y" ]; then
		# Re goodies divulged here: http://stackoverflow.com/q/9260014/1397555
		rm ./apt-cyg
		wget http://raw.github.com/transcode-open/apt-cyg/master/apt-cyg
		chmod +x apt-cyg
		# Optional but preferred:
		# ./apt-cyg install chere
		# chere -i -t mintty

		./apt-cyg install make
# IF YOU comment out the next two lines, make sure to install these modules via the Cygwin installer! :
		./apt-cyg install perl
		./apt-cyg install perl-libxml-perl
		./apt-cyg install perl-XML-Parser
		rm ./apt-cyg
		wget https://www.xmltwig.org/xmltwig/XML-Twig-3.52.tar.gz
		tar xz < XML-Twig-3.52.tar.gz
		cd XML-Twig-3.52
		perl Makefile.PL -y
		make
		make test
		make install
		cd ..
		rm -rf XML-Twig-3.52 XML-Twig-3.52.tar.gz XML-Twig-3.52
		xml_grep --pretty_print indented --wrap flames --descr 'name="Flock Hoibimonko"' --cond "flame" *.flame > flames.flame
			# nah: --pretty_print indented -- WAIT actually yes.
				echo "!============================================================"
				echo Done. If all went as planned, there should be a new file named flames.flame which, if you open in a text editor, you will find to be a series of \<flame\> genomes nested in a \<flames\> tag set at the start and end of the file.
	else
		echo D\'oh!; exit;
fi