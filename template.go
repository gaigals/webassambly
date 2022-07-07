package main

import (
	"fmt"
	"html/template"
	"net/http"
)

// Template holds required data for template rendering.
type Template struct {
	Template *template.Template
}

// NewTemplate creates new template from given HTML file/s and adds provide funcMap.
// Returns valid pointer to template or error.
func NewTemplate(funcMap template.FuncMap, htmlPath ...string) (*Template, error) {
	templ := Template{Template: template.New("templ")}
	_ = templ.AddFuncs(funcMap)

	err := templ.AddHTML(htmlPath...)
	if err != nil {
		return nil, err
	}

	return &templ, nil
}

// AddHTML adds HTML content to current template.
func (t *Template) AddHTML(htmlPath ...string) error {
	if t.Template == nil {
		return fmt.Errorf("template field is nil")
	}

	if len(htmlPath) == 0 {
		return nil
	}

	var err error

	t.Template, err = t.Template.ParseFiles(htmlPath...)
	if err != nil {
		return err
	}

	return nil
}

// AddFuncs adds template function map to current template.
func (t *Template) AddFuncs(funcMap template.FuncMap) error {
	if t.Template == nil {
		return fmt.Errorf("template field is nil")
	}

	if len(funcMap) == 0 {
		return nil
	}

	t.Template = t.Template.Funcs(funcMap)
	return nil
}

// Render sets current template Content-Type as HTML and renders it.
func (t *Template) Render(w http.ResponseWriter) error {
	w.Header().Set("Content-Type", "text/html;charset=utf-8")

	err := t.Template.ExecuteTemplate(w, "layout", nil)
	if err != nil {
		return err
	}

	return nil
}
