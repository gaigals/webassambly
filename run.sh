#!/bin/bash

handle_errors() {
  if [ "$1" -eq "1" ]; then
    exit "$1"
  fi
}

echo "Checking dependencies ..."
echo "----------------------------"
./deps.sh
handle_errors $?

echo "----------------------------"
echo "Compiling WASM code ..."
echo "----------------------------"
./compile.sh
handle_errors $?

echo "Running localhost server on port 80"
sudo go run ./
