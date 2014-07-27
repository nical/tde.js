#!/bin/sh

if [ $# -lt "1" ]; then
  echo "Usage: $0 <project name>"
  exit 1
fi

PROJECT=$1
PROJECT_ROOT=./data/$PROJECT
EXPORT_ROOT=./export/$PROJECT

. ./utils.sh

echo " -- preparing..."
rm -rf "$EXPORT_ROOT"
mkdir -p "$EXPORT_ROOT"
mkdir -p tools

echo " -- building shaders"
./BUILD_SHADERS.sh $PROJECT

echo " -- concatenating js files and stripping debug code..."

for f in  ./public/engine/*.js
do
    ./tools/opt.py $f >> $EXPORT_ROOT/demo.js
done

cat $EXPORT_ROOT/shaders/shaders.js >> $EXPORT_ROOT/demo.js

for f in  $PROJECT_ROOT/*.seq
do
    ./tools/opt.py $f >> $EXPORT_ROOT/demo.js
done

for f in  $PROJECT_ROOT/*.song
do
    ./tools/opt.py $f | sed "s/'\\(SND\\.[A-Za-z]*\\)'/\\1/g" >> $EXPORT_ROOT/demo.js
done

echo "onload=main;" >> $EXPORT_ROOT/demo.js

if [ ! -f tools/compiler.jar ]; then
    echo " -- tools/compiler.jar not found, now downloading it..."
    wget -O tools/compiler-latest.zip "http://dl.google.com/closure-compiler/compiler-latest.zip"
    cd tools && unzip compiler-latest.zip
fi

echo " -- running the closure compiler..."
java -jar tools/compiler.jar --js=$EXPORT_ROOT/demo.js --js_output_file=$EXPORT_ROOT/demo.min.js --compilation_level=ADVANCED_OPTIMIZATIONS --externs ./externs/w3c_audio.js

echo " -- packing in a png..."
ruby tools/pnginator.rb $EXPORT_ROOT/demo.min.js $EXPORT_ROOT/demo.png.html

echo " -- done."

wc -c *.js $EXPORT_ROOT/shaders/shaders.js
wc -c $EXPORT_ROOT/demo.js
wc -c $EXPORT_ROOT/demo.min.js
wc -c $EXPORT_ROOT/demo.png.html
