# WEBASSAMBY

WebAssembly template project

___

Run project with standard GO SDK compiler:
```
./run.sh
```

or enable TinyGo compiler with (reduces wasm binary size)
```
TINYGO=TRUE ./run.sh
```

`run.sh` installs all required dependencies, compiles WASM GO code and starts localhost server on port 80.


`./static/main.wasm` gets compiled/generated by `compile.sh`.\
`./static/wasm_exec.js` gets added by `deps.sh` (copied from GO SKD).\
`./static/wasm.js` is used as initializer for wasm binary.

`./wasm` directory contains GO code which gets compiled as wasm binary.