# DESCRIPTION
# Installs Windows dependencies for this autobrood repository's scripts,
# if you wish to run them from MSYS2.

MSYS2_packages=" \
perl \
perl-XML-LibXML \
tar \
perl-XML-Parser"

for element in ${MSYS2_packages[@]}
do
	# UNINSTALL option:
	# pacman -R --noconfirm $element
	pacman -S --noconfirm $element
done

wget https://www.xmltwig.org/xmltwig/XML-Twig-3.52.tar.gz
tar xz < XML-Twig-3.52.tar.gz
cd XML-Twig-3.52
perl Makefile.PL -y
make
# But I doubt this helps anything? :
make test
make install
cd ..
rm -rf XML-Twig-3.52 XML-Twig-3.52.tar.gz XML-Twig-3.52
xml_grep --pretty_print indented --wrap flames --descr 'name="Flock Hoibimonko"' --cond "flame" *.flame > flames.flame
# nah: --pretty_print indented -- WAIT actually yes.
echo "!============================================================"
echo Done. If all went as planned, there should be a new file named flames.flame which, if you open in a text editor, you will find to be a series of \<flame\> genomes nested in a \<flames\> tag set at the start and end of the file.