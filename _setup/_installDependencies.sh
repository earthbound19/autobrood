# NOTES: if install fails (canna download from mirror), try:
# apt-cyg mirror "mirror site"
# --using a mirror URL from this page's list:
# e.g.:
# apt-cyg mirror "ftp://mirrors.syringanetworks.net/cygwin/"
# re: http://superuser.com/a/941135
# ALSO, mysteriously, installing perl xml_twig via cygwin may solve any errors after this script successfully runs all commands. 

echo This script will attempt to install dependencies needed for the .sh scripts in autobrood to work under Cygwin.
echo "!============================================================"
read -p "DO YOU WISH TO CONTINUE running this script? : y/n" CONDITION;
if [ "$CONDITION" == "y" ]; then
		# save current directory because some later commands move to other directories.
		currDir=`pwd`
				echo Trying some stuff to install dependencies for autobrood using cygwin . . .
				# cat ./my.minttyrc.settings.txt > /home/$username/.minttyrc
		# Re goodies divulged here: http://stackoverflow.com/q/9260014/1397555
		# wget --no-check-certificate raw.github.com/transcode-open/apt-cyg/master/apt-cyg
		wget raw.github.com/transcode-open/apt-cyg/master/apt-cyg
		chmod +x apt-cyg
		mv apt-cyg /usr/local/bin
		cd /usr/local/bin
			# Optional but preferred:
			apt-cyg install chere
			chere -i -t mintty
		apt-cyg install make
		apt-cyg install perl
		apt-cyg install perl-libxml-perl
		# wget --no-check-certificate http://www.xmltwig.org/xmltwig/XML-Twig-3.50.tar.gz
		wget http://www.xmltwig.org/xmltwig/XML-Twig-3.50.tar.gz
		tar xz < XML-Twig-3.50.tar.gz
		cd XML-Twig-3.50
		perl Makefile.PL -y
		make
		make test
		make install
		cd ..
		rm -r -f XML-Twig-3.50 XML-Twig-3.50.tar.gz
		cd $currDir
		xml_grep --pretty_print indented --wrap flames --descr 'name="Flock Hoibimonko"' --cond "flame" *.flame > flames.flame
			# nah: --pretty_print indented -- WAIT actually yes.
				echo "!============================================================"
				echo Done. If all went as planned, there should be a new file named flames.flame which, if you open in a text editor, you will find to be a series of \<flame\> genomes nested in a \<flames\> tag set at the start and end of the file.
	else
		echo D\'oh!; exit;
fi