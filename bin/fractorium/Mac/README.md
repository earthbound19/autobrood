# DESCRIPTION
These are tools for fractal flame generation, cross-breeding, animating and rendering, compiled from source for MacOS, where at this writing ;) the fractoium web site says a Mac download is available, but I couldn't find it. Source available at: https://github.com/gh2k/fractorium

Renders I've done with this tool (either from Windows or MacOS) are searchable at: http://earthbound.io/q/search.php?query=fractal+flame&search=1

## NOTES
This was compiled for MacOS Sierra 10.12.2. You may need to run the following command (after installing brew) for these to run:

brew install qt5 tbb glm dbus jpeg libpng glib libxml2

The only tested and verified working executable is emberrender. Boy does it render images from genomes fast, depending on your hardware!

## KNOWN ISSUES
embergenome throws an error about parsing flam3-palettes.xml; it's possible it needs to be recompiled with a specific version and/or flavor of libxml2 and/or perl-libxml2 or sumpin'--where I only initially got any of these to compile without error by *not* installing those (via brew? npm?) on a Mac.
