#!/bin/bash

if [ -z "$1" ]; then
    echo "usage $0 <kernel build dir>"
    exit 1
fi

BASE="$1"
ZIMAGE="$1/arch/arm/boot/zImage"
CWD="$(pwd)"

if [ ! -f "$ZIMAGE" ]; then
    echo "I'm not that smart dude, build your kernel"
    exit 1
fi

rm -rf "$CWD/tmp"
mkdir "$CWD/tmp"
cp -r "$CWD/META-INF" "$CWD/kernel" "$CWD/system" "$CWD/tmp"
cp "$ZIMAGE" "$CWD/tmp/kernel/zImage"

pushd "$BASE"
find . -iname \*.ko > modules
while read module; do
    cp "$module" "$CWD/tmp/system/lib/modules"
done < modules
rm modules
popd

pushd "$CWD/tmp"
zip -r "$CWD/mykernel-$(date +%Y%m%d).zip" .
popd

