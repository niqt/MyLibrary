package main

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"io"
	"net/http"
)

func GetBooksEndpoint(w http.ResponseWriter, req *http.Request) {
	v := req.URL.Query()

	search := v.Get("search")

	json.NewEncoder(w).Encode(GetBooks(search))
}

func GetBookByIdEndpoint(w http.ResponseWriter, req *http.Request) {
	params := mux.Vars(req)
	id := params["id"]

	json.NewEncoder(w).Encode(GetBookById(id))
}

func SaveBookEndpoint(w http.ResponseWriter, req *http.Request) {
	var book Book
	//err := json.NewDecoder(req.Body).Decode(&bb)

	var bodyBytes []byte
	if req.Body != nil {
		bodyBytes, _ = io.ReadAll(req.Body)
	}
	err := json.Unmarshal(bodyBytes, &book)

	if err != nil {
		//util.Log.Error().Msg("Error: " + err.Error())
	}

	result := SaveBook(book)

	json.NewEncoder(w).Encode(result)
}

func CreateUserEndpoint(w http.ResponseWriter, req *http.Request) {
	var user User
	//err := json.NewDecoder(req.Body).Decode(&bb)

	var bodyBytes []byte
	if req.Body != nil {
		bodyBytes, _ = io.ReadAll(req.Body)
	}
	err := json.Unmarshal(bodyBytes, &user)

	if err != nil {
		//util.Log.Error().Msg("Error: " + err.Error())
	}

	result, err := CreateUser(user)

	if err != nil {
		w.WriteHeader(500)
	}

	json.NewEncoder(w).Encode(result)
}

func AuthenticateUserEndpoint(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	account := &User{}

	err := json.NewDecoder(req.Body).Decode(account) //decode the request body into struct and failed if any error occur
	if err != nil {
		w.WriteHeader(500)
		return
	}

	resp, err := Login(account.Email, account.Password)
	if err != nil {
		w.WriteHeader(500)
		return
	}
	json.NewEncoder(w).Encode(resp)
}
