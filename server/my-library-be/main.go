package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

func main() {
	fmt.Printf("*** Server starting ***\n")
	router := mux.NewRouter()
	router.HandleFunc("/api/v1/books", GetBooksEndpoint).Methods("GET") // ?search=""
	router.HandleFunc("/api/v1/books/{id}", GetBookByIdEndpoint).Methods("GET")
	router.HandleFunc("/api/v1/books/{id}", DeleteBookByIdEndpoint).Methods("DELETE")
	router.HandleFunc("/api/v1/books", SaveBookEndpoint).Methods("POST")
	router.HandleFunc("/api/v1/user", CreateUserEndpoint).Methods("POST")
	router.HandleFunc("/api/v1/user/login", AuthenticateUserEndpoint).Methods("POST")

	router.Use(JwtAuthentication)
	log.Fatal(http.ListenAndServe(":8080", router))
}
