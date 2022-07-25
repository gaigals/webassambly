#!/bin/bash

if [ "$TINYGO" != "TRUE" ]; then
  TINYGO=FALSE
fi

STATIC_DIR=./static

TINYGO_VERSION=v0.23.0
TINYGO_DEB_NAME=tinygo_0.23.0_amd64.deb
TINY_GO_INSTALL_URL=https://github.com/tinygo-org/tinygo/releases/download/$TINYGO_VERSION/$TINYGO_DEB_NAME

WASM_JS_FILE_NAME=wasm_exec.js

TINYGO_WASM_JS_INSTALL_URL=https://raw.githubusercontent.com/tinygo-org/tinygo/v0.19.0/targets/$WASM_JS_FILE_NAME

has_deb() {
  ls ./ | grep $TINYGO_DEB_NAME -q
  HAS_DEB_FILE=$?

  if [ "$HAS_DEB_FILE" -eq "0" ]; then
    return 1
  fi

  return 0
}

is_tinygo_installed() {
  TINYGO_PAHT=$(which tinygo)

  if [ "$TINYGO_PAHT" == "" ]; then
    return 0
  fi

  return 1
}

install_tinygo() {
  wget -q $TINY_GO_INSTALL_URL

  if [ has_deb == 0 ]; then
    return 0
  fi

  sudo dpkg -i $TINYGO_DEB_NAME
  rm -f $TINYGO_DEB_NAME

  return 1
}

has_wasm_exec() {
  ls $STATIC_DIR | grep $WASM_JS_FILE_NAME -q

  HAS_WASM_FILE=$?

  if [ "$HAS_WASM_FILE" -eq "0" ]; then
    return 1
  fi

  return 0
}

has_wasm_exec_tinygo() {
  cat $STATIC_DIR/$WASM_JS_FILE_NAME 2>/dev/null | grep "TinyGo" -q
  IS_TINYGO_WASM_FILE=$?

  if [ "$IS_TINYGO_WASM_FILE" -eq "0" ]; then
    return 1
  fi

  return 0
}

downlaod_tinygo_wasm_js() {
  wget -q $TINYGO_WASM_JS_INSTALL_URL -O $STATIC_DIR/$WASM_JS_FILE_NAME
  has_wasm_exec
  return $?
}

setup_tinygo() {
  echo "Using tinygo"

  is_tinygo_installed
  IS_INSTALLED=$?

    if [ $IS_INSTALLED == 0 ]; then
      echo "tinygo binary not found"
      printf "Installing tinygo ..."

      install_tinygo
      HAS_FAILURE=$?

      if [ "$HAS_FAILURE" -eq "0" ]; then
        printf "\nFailed to download tinygo, aborting ..."
        exit 1
      fi

      printf "\rInstalling tinygo ... Done"
    fi
}

setup_tinygo_wasm_js() {
  printf "Downloading tinygo wasm_exec.js ..."

  downlaod_tinygo_wasm_js
  HAS_FAILURE=$?

  if [ "$HAS_FAILURE" -eq "0" ]; then
    printf "\nFailed to download tinygo %s, aborting ...\n" "$WASM_JS_FILE_NAME"
    exit 1
  fi

  printf "\rDownloading tinygo wasm_exec.js ... Done\n"

}

######################
# Setup dependencies #
######################

has_wasm_exec
HAS_WASM=$?

has_wasm_exec_tinygo
HAS_WASM_TINYGO=$?


# Setup tinygo if enabled
if [ $TINYGO == TRUE ]; then
  setup_tinygo

  if [ $HAS_WASM == 0 ] || [ $HAS_WASM_TINYGO == 0 ]; then
    printf "Downloading tinygo wasm_exec.js ..."

    downlaod_tinygo_wasm_js
    HAS_FAILURE=$?

    if [ "$HAS_FAILURE" -eq "0" ]; then
      printf "\nFailed to download tinygo %s, aborting ...\n" "$WASM_JS_FILE_NAME"
      exit 1
    fi

    printf "\rDownloading tinygo wasm_exec.js ... Done\n"

    exit 0
  fi
fi

# Install default wasm_exec.js from GO_SDK if TINYGO is not in use.

echo "Using GO SDK default compiler"

if [ $HAS_WASM == 0 ] || [ $HAS_WASM_TINYGO == 1 ]; then
  printf "Copying GO SDK wasm_exec.js ..."
  cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" $STATIC_DIR
  printf "\rCopying GO SDK wasm_exec.js ... Done\n"
fi