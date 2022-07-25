#!/bin/bash

PROJECT_DIR=$(pwd)
WASM_DIR=$PROJECT_DIR/wasm
STATIC_DIR=$PROJECT_DIR/static

cd $WASM_DIR
#cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" $STATIC_DIR

if [ "$TINYGO" == "FALSE" ]; then
  GOOS=js GOARCH=wasm go build -o $STATIC_DIR/main.wasm
else
  pwd
  tinygo build -o $STATIC_DIR/main.wasm -target wasm ./main.go
fi

cd $PROJECT_DIR