#!/bin/bash

SLIMERDIR=`dirname $0`
SLIMERDIR=`cd $SLIMERDIR;pwd`
CURRENTDIR=`pwd`

cd $SLIMERDIR

if [ "$1" == "nightly" ]
then
    VERSION="nightly"
else
    VERSION=`grep "^Version=" src/application.ini`
    VERSION=${VERSION:8}
fi

TARGETDIR="$SLIMERDIR/_dist/slimerjs-$VERSION"

if [ -d "$TARGETDIR" ]
then
    rm -rf $TARGETDIR/*
else
    mkdir -p "$TARGETDIR"
fi

# copy files
cd src

cp application.ini $TARGETDIR
cp slimerjs $TARGETDIR
cp slimerjs.bat $TARGETDIR
cp LICENSE $TARGETDIR
cp README.md $TARGETDIR

# zip chrome files into omni.ja
zip -r $TARGETDIR/omni.ja chrome/ components/ defaults/ modules/ chrome.manifest --exclude @package_exclude.lst

# set the build date
cd $TARGETDIR
BUILDDATE=`date +%Y%m%d`
sed -i -e "s/BuildID=.*/BuildID=$BUILDDATE/g" application.ini

# create the final package
cd $SLIMERDIR/_dist
zip -r "slimerjs-$VERSION.zip" "slimerjs-$VERSION"

# the end
cd $CURRENTDIR
echo "The package is in $SLIMERDIR/_dist/slimerjs-$VERSION.zip"
