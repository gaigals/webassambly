package main

import (
	"log"
	"net/http"
)

var templateHome *Template

func initializeHandlers() {
	http.HandleFunc("/", handlerHomeGET)
	http.HandleFunc("/static/", handlerStaticGET)
}

func initializeTemplates() error {
	var err error

	templateHome, err = NewTemplate(nil, "templ/home.html")
	if err != nil {
		return err
	}

	return nil
}

func main() {
	initializeHandlers()

	err := initializeTemplates()
	if err != nil {
		log.Fatalln(err)
	}

	server := &http.Server{
		Addr:    ":80",
		Handler: nil,
	}

	if err := server.ListenAndServe(); err != nil {
		log.Fatalln(err)
	}
}
