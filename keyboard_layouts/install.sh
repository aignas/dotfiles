#!/bin/sh
#
# A script which downloads the required drivers for Mac OS X in order to have the standard Lithuanian keyboard layout.
#
# Link to layout web site: http://ims.mii.lt/klav/index.html
# Link to the drivers: http://ims.mii.lt/klav/tvarkyk.html
#

if [ ${DOTFILES_OS} == "Darwin" ]
then
    echo "Installing Keyboard Layouts"

    URL="http://ims.mii.lt/klav/MacOS-X.zip"
    echo "Lithuanian Standard: TODO"
    # wget $URL
    # unarchive the download
    # Install to 
    # cp -r <dir> ~/Library/Keyboard\ Layouts/<dir>
fi
