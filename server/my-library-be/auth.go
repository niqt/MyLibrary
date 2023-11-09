package main

import (
	"context"
	jwt "github.com/golang-jwt/jwt"
	"net/http"
	"os"
	"strings"
)

var JwtAuthentication = func(next http.Handler) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		notAuth := []string{"/api/v1/user", "/api/v1/users/login"} //List of endpoints that doesn't require auth

		requestPath := r.URL.Path //current request path
		/*
			if requestPath == "/" {
				next.ServeHTTP(w, r)
				return
			}*/

		/* start commentare per corretto funzionamento */
		/*
			next.ServeHTTP(w, r)
			return
		*/
		/* end commentare per corretto funzionamento */

		//check if request does not need authentication, serve the request if it doesn't need it
		for _, value := range notAuth {
			if strings.HasPrefix(requestPath, value) {
				next.ServeHTTP(w, r)
				return
			}
		}

		//response := make(map[string]interface{})
		tokenHeader := r.Header.Get("Authorization") //Grab the token from the header

		if tokenHeader == "" { //Token is missing, returns with error code 403 Unauthorized
			/*response = u.Message(false, "Missing auth token", u.MissingAuthToken)
			w.WriteHeader(http.StatusForbidden)
			w.Header().Add("Content-Type", "application/json")
			u.Respond(w, response)*/
			w.WriteHeader(http.StatusForbidden)
			return
		}

		splitted := strings.Split(tokenHeader, " ") //The token normally comes in format `Bearer {token-body}`, we check if the retrieved token matched this requirement
		if len(splitted) != 2 {
			/*response = u.Message(false, "Invalid/Malformed auth token", u.InvalidToken)
			w.WriteHeader(http.StatusForbidden)
			w.Header().Add("Content-Type", "application/json")
			u.Respond(w, response)*/
			w.WriteHeader(http.StatusForbidden)
			return
		}

		tokenPart := splitted[1] //Grab the token part, what we are truly interested in
		tk := &Token{}

		token, err := jwt.ParseWithClaims(tokenPart, tk, func(token *jwt.Token) (interface{}, error) {
			return []byte(os.Getenv("token_password")), nil
		})

		if err != nil { //Malformed token, returns with http code 403 as usual
			/*response = u.Message(false, "Malformed authentication token", u.MalformedToken)
			w.WriteHeader(http.StatusForbidden)
			w.Header().Add("Content-Type", "application/json")
			u.Respond(w, response)*/
			w.WriteHeader(http.StatusForbidden)
			return
		}

		if !token.Valid { //Token is invalid, maybe not signed on this server
			/*response = u.Message(false, "Token is not valid.", u.InvalidToken)
			w.WriteHeader(http.StatusForbidden)
			w.Header().Add("Content-Type", "application/json")
			u.Respond(w, response)*/
			w.WriteHeader(http.StatusForbidden)
			return
		}

		if UserExists(tk.Username) != nil { //Token is invalid, maybe not signed on this server
			/*u.Log.Error().Msg("\nUsername %s non esiste " + tk.Username)
			response = u.Message(false, "Utente non esiste", u.UserNotFound)
			w.WriteHeader(http.StatusForbidden)
			w.Header().Add("Content-Type", "application/json")
			u.Respond(w, response)*/
			w.WriteHeader(http.StatusForbidden)
			return
		}

		ctx := context.WithValue(r.Context(), "username", tk.Username)
		r = r.WithContext(ctx)
		next.ServeHTTP(w, r) //proceed in the middleware chain!
	})
}
