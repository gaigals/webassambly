package main

import (
	"fmt"
	"net/http"
)

var staticFileServer = http.StripPrefix(
	"/static/",
	http.FileServer(http.Dir("./static")),
)

func handlerStaticGET(w http.ResponseWriter, r *http.Request) {
	staticFileServer.ServeHTTP(w, r)
}

// Render HTML form - login with eID, eMobile or unified login.
func handlerHomeGET(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, http.StatusText(http.StatusMethodNotAllowed), http.StatusMethodNotAllowed)
		return
	}

	err := templateHome.Render(w)
	if err != nil {
		fmt.Println(err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}
