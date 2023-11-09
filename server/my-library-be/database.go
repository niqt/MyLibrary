package main

import (
	"fmt"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"golang.org/x/net/context"
)

var booksDb *mongo.Database

type key string

var ctx context.Context

const (
	hostKey         = key("hostKey")
	BooksCollection = "books"
	UserCollection  = "users"
	DBName          = "library"
)

func init() {
	ctx = context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	ctx = context.WithValue(ctx, hostKey, "127.0.0.1")

	booksDb, _ = configDB(ctx)
}

func configDB(ctx context.Context) (*mongo.Database, error) {
	uri := fmt.Sprintf(`mongodb://%s`,
		ctx.Value(hostKey),
	)
	client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		return nil, fmt.Errorf("todo: couldn't connect to mongo: %v", err)
	}

	db := client.Database(DBName)
	return db, nil
}

func GetDB() *mongo.Database {
	return booksDb
}

func GetCtx() context.Context {
	return ctx
}
