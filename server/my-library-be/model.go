package main

import (
	"errors"
	"github.com/golang-jwt/jwt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
	"golang.org/x/net/context"
	"log"
	"os"
)

func UserExists(email string) error {
	return nil
}

func SaveBook(book Book) Response {

	if book.ID.IsZero() {
		result, err := GetDB().Collection(BooksCollection).InsertOne(
			context.Background(), book)

		if err != nil {
			return Response{
				Books:    []Book{},
				ErrorMsg: err.Error(),
				Total:    0,
			}
		}

		oid, _ := result.InsertedID.(primitive.ObjectID)
		book.ID = oid
		var books []Book
		books = append(books, book)
		return Response{
			Books:    books,
			ErrorMsg: "",
			Total:    1,
		}
	} else {
		_, err := GetDB().Collection(BooksCollection).ReplaceOne(context.Background(), bson.M{"_id": book.ID}, book)
		if err != nil {
			return Response{
				Books:    []Book{},
				ErrorMsg: err.Error(),
				Total:    0,
			}
		}
		var books []Book
		books = append(books, book)
		return Response{
			Books:    books,
			ErrorMsg: "",
			Total:    1,
		}
	}

}

func GetBooks(query string) Response {
	filter := bson.D{}

	if len(query) > 0 {
		filter = bson.D{{"$or",
			bson.A{
				bson.D{{Key: "title", Value: bson.M{"$regex": ".*" + query + ".*", "$options": "i"}}},
				bson.D{{Key: "isbn13", Value: bson.M{"$regex": ".*" + query + ".*", "$options": "i"}}},
				bson.D{{Key: "authors", Value: bson.M{"$regex": ".*" + query + ".*", "$options": "i"}}},
			}}}
	}
	cur, err := GetDB().Collection(BooksCollection).Find(ctx, filter)

	if err != nil {
		return Response{
			Books:    []Book{},
			ErrorMsg: err.Error(),
			Total:    0,
		}
	} else {
		var books []Book
		for cur.Next(ctx) {
			bookFromMongo := Book{}

			if err = cur.Decode(&bookFromMongo); err != nil {
				continue
			}
			books = append(books, bookFromMongo)
		}
		return Response{
			Books:    books,
			ErrorMsg: "",
			Total:    len(books),
		}
	}
}

func GetBookById(id string) Response {
	var book Book
	if len(id) == 0 {
		return Response{
			Books:    []Book{},
			ErrorMsg: "wrong id",
			Total:    0,
		}
	}
	objID, err := primitive.ObjectIDFromHex(id)

	if err != nil {
		return Response{
			Books:    []Book{},
			ErrorMsg: err.Error(),
			Total:    0,
		}
	}

	err = GetDB().Collection(BooksCollection).FindOne(ctx, bson.M{"_id": objID}).Decode(&book)

	if err != nil {
		return Response{
			Books:    []Book{},
			ErrorMsg: err.Error(),
			Total:    0,
		}
	}

	var books []Book
	books = append(books, book)
	return Response{
		Books:    books,
		ErrorMsg: "",
		Total:    1,
	}
}

func CreateUser(account User) (map[string]User, error) {

	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(account.Password), bcrypt.DefaultCost)
	account.Password = string(hashedPassword)

	result, err := GetDB().Collection(UserCollection).InsertOne(
		context.Background(), account)

	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	oid, _ := result.InsertedID.(primitive.ObjectID)

	account.ID = oid

	if account.ID.IsZero() {
		return nil, errors.New("wrong user id")
	}

	tk := &Token{UserId: account.ID, Username: account.Email}
	token := jwt.NewWithClaims(jwt.GetSigningMethod("HS256"), tk)
	tokenString, _ := token.SignedString([]byte(os.Getenv("token_password")))
	account.Token = tokenString
	account.Password = "" //delete password

	var response = make(map[string]User)
	response["user"] = account

	return response, nil
}

func Login(email, password string) (map[string]interface{}, error) {

	account := &User{}

	err := GetDB().Collection(UserCollection).FindOne(ctx, bson.M{"email": email}).Decode(&account)

	if err != nil {
		return nil, err
	}

	err = bcrypt.CompareHashAndPassword([]byte(account.Password), []byte(password))
	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword { //Password does not match!
		return nil, err
	}

	//Worked! Logged In
	account.Password = ""

	//Create JWT token
	tk := &Token{UserId: account.ID, Username: account.Email}
	token := jwt.NewWithClaims(jwt.GetSigningMethod("HS256"), tk)
	tokenString, _ := token.SignedString([]byte(os.Getenv("token_password")))
	account.Token = tokenString //Store the token in the response

	var response = make(map[string]interface{})
	response["user"] = *account
	return response, nil
}
