package main

import "github.com/golang-jwt/jwt"
import "go.mongodb.org/mongo-driver/bson/primitive"

type Token struct {
	UserId   primitive.ObjectID
	Username string
	jwt.StandardClaims
}

type User struct {
	ID       primitive.ObjectID `json:"id" bson:"_id,omitempty"`
	Email    string             `json:"email,omitempty"`
	Token    string             `json:"token,omitempty"`
	Password string             `json:"password,omitempty"`
}

type Book struct {
	ID         primitive.ObjectID `json:"id" bson:"_id,omitempty"`
	Authors    string             `json:"authors,omitempty"`
	Title      string             `json:"title"`
	Subtitle   string             `json:"subtitle,omitempty"`
	Position   string             `json:"position,omitempty"`
	Publisher  string             `json:"publisher,omitempty"`
	Categories string             `json:"categories,omitempty"`
	Image      string             `json:"image,omitempty"`
	ISBN13     string             `json:"isbn13,omitempty"`
	ISBN10     string             `json:"isbn10,omitempty"`
	User       string             `json:"user,omitempty"`
}

type Response struct {
	Books    []Book `json:"books"`
	ErrorMsg string `json:"error"`
	Total    int    `json:"total"`
}
