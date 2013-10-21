#!/bin/sh
echo $LD_LIBRARY_PATH | egrep "<INSTALL_DIR>/common" > /dev/null
if [ $? -ne 0 ] ; then
PATH="<INSTALL_DIR>/java/bin:<INSTALL_DIR>/common/bin:$PATH"
export PATH
LD_LIBRARY_PATH="<INSTALL_DIR>/common/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
fi

##### IMAGEMAGICK ENV #####
MAGICK_HOME="<INSTALL_DIR>/common"
export MAGICK_HOME
MAGICK_CONFIGURE_PATH="<INSTALL_DIR>/common/lib/ImageMagick-6.8.6/config-Q16"
export MAGICK_CONFIGURE_PATH
MAGICK_CODER_MODULE_PATH="<INSTALL_DIR>/common/lib/ImageMagick-6.8.6/modules-Q16/coders"
export MAGICK_CODER_MODULE_PATH

GS_LIB="<INSTALL_DIR>/common/share/ghostscript/fonts"
export GS_LIB

##### JAVA ENV #####
JAVA_HOME=<JAVA_HOME>
export JAVA_HOME

# Enable below to debug:
JPDA_ADDRESS=8000
export JPDA_ADDRESS
JPDA_TRANSPORT=dt_socket
export JPDA_TRANSPORT
DEBUG_OPTS="$JAVA_OPTS -Xdebug -Xrunjdwp:transport=$JPDA_TRANSPORT,address=$JPDA_ADDRESS,server=y,suspend=n"
export DEBUG_OPTS

. <INSTALL_DIR>/scripts/build-setenv.sh