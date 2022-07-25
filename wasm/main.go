//go:build js && wasm

package main

import (
	"fmt"
	"syscall/js"
)

func main() {
	message := "Hello, World!"
	fmt.Println(message)

	document := js.Global().Get("document")
	h2 := document.Call("createElement", "h2")
	h2.Set("innerHTML", message)
	document.Get("body").Call("appendChild", h2)

	// Prevent the function from returning, which is required by wasm module.
	<-make(chan bool)
}
