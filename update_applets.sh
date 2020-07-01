#!/bin/bash

TOP_DIR=$(pwd)
APPLET_DIR="$TOP_DIR/src/plugins/device"
[ -n "$DEVICE" ] && APPLET_DIR="$APPLET_DIR/$DEVICE"
BUILD_DIR="$TOP_DIR/softpack"

pushd $APPLET_DIR
APPLETS=$(find . -type f -name "*-generic_*.bin")
popd

rm -fr $BUILD_DIR 2>/dev/null
cp -r ../softpack $TOP_DIR

REGEXP="^.*applet-\([a-z]\+\)_\([0-9a-z]\+\)-generic_\([a-z]\+\).bin$"
for APPLET in $APPLETS; do
    INSTALL_DIR=$(dirname $APPLET_DIR/$APPLET)
    NAME=$(echo $APPLET | sed -e "s/$REGEXP/\1/")
    TARGET=$(echo $APPLET | sed -e "s/$REGEXP/\2/")-generic
    VARIANT=$(echo $APPLET | sed -e "s/$REGEXP/\3/")
    echo "********** BUILDING $NAME ($APPLET) *************"
    V=1 make -C $BUILD_DIR/samba_applets/$NAME TARGET=$TARGET VARIANT=$VARIANT RELEASE=1 || exit 1
    cp -f $BUILD_DIR/samba_applets/$NAME/build/$TARGET/$VARIANT/applet-${NAME}_${TARGET}_${VARIANT}.bin $INSTALL_DIR/ || exit 1
done

rm -fr $BUILD_DIR

