#!/bin/sh

rm -rf ./docs/api || true
find ./docs -type f -name "index.bc.js" -delete
find ./docs -type f -path "*example/index.html" -delete
mkdir -p ./docs
sesame-doc build --content-dir=./examples
dune build --profile release @default @doc
cp -r _build/default/_doc/_html ./docs/api

copy_example ()
{
  SECTION=$1
  SRC=./_build/default/examples/1-section
  DST=./docs/tutorial
  mkdir -p $DST/$SECTION/example 
  cp -r $SRC/$SECTION/example/index.bc.js $DST/$SECTION/example/index.bc.js
  cp -r $SRC/$SECTION/example/index.html $DST/$SECTION/example/index.html
}

copy_example counter-closure-component
copy_example hello-world
copy_example request-data-from-the-internet
copy_example todo-stack
copy_example markdown-editor