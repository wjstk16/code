package main

import (
  "fmt"
  "net/http"
)

func main() {
  http.HandleFunc("/", hello)
  http.ListenAndServe(":8080", nil)
}

func hello(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "v0.0.2 : Hello, %s", r.URL.Path[1:])
}
