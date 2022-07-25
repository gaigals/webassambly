//go:build js && wasm

package main

import (
	"fmt"
	"syscall/js"
)

func main() {
	message := "Hello, World!"

	// Print message in console. Same as console.log() in JS.
	fmt.Println(message)

	// Some action with DOM.
	document := js.Global().Get("document")
	h2 := document.Call("createElement", "h2")
	h2.Set("innerHTML", message)
	document.Get("body").Call("appendChild", h2)

	// Prevent the function from returning, which is required by wasm module.
	<-make(chan bool)
}
