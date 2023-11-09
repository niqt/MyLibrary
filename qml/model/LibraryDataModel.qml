import QtQuick
import Felgo

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // whether a user is logged in
    readonly property bool userLoggedIn: _.userLoggedIn

    // model data properties
    readonly property alias books: _.books
    readonly property alias bookDetails: _.bookDetails

    // action success signals
    signal bookStored(var book)

    // action error signals
    signal fetchBooksFailed(var error)
    signal fetchBookDetailsFailed(int id, var error)
    signal storeBookFailed(var book, var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        onFetchBooks: search => {
            // check cached value first
            var cached = cache.getValue("books")
            if(cached)
                _.books = cached

            // load from api
            api.getBooks(search,
                        function(data) {
                            // cache data before updating model property
                            cache.setValue("books",data)
                            var objectData = JSON.parse(data)
                            var books = []
                            if (objectData.total > 0)
                                books = objectData.books
                            _.books = books
                            booksChanged()
                        },
                        function(error) {
                            // action failed if no cached data
                            if(!cached)
                                fetchBooksFailed(error)
                        })
        }

        onFetchBookDetails: id => {
                                var cached = cache.getValue("book_"+id)
                                if(cached) {
                                    _.bookDetails[id] = cached
                                    bookDetailsChanged() // signal change within model to update UI
                                }

                                // load from api
                                api.getBookById(id,
                                                function(data) {
                                                    // cache data first
                                                    cache.setValue("book_"+id, data)
                                                    _.bookDetails[id] = data
                                                    bookDetailsChanged()
                                                },
                                                function(error) {
                                                    // action failed if no cached data
                                                    if(!cached) {
                                                        bookDetailsFailed(id, error)
                                                    }
                                                })
                            }

        onStoreBook: book => {
                         // save remote
                         api.addBook(book,
                                     function(data) {
                                         var objData = JSON.parse(data)
                                         if (objData.total === 1) {
                                             var book = objData.books[0]
                                             bookStored(data)
                                         }
                                     },
                                     function(error) {
                                         storeBookFailed(book, error)
                                     })
                     }

        onClearCache: {
            cache.clearAll()
        }
    }

    // you can place getter functions here that do not modify the data
    // pages trigger write operations through logic signals only

    // rest api for data access
    RestAPI {
        id: api
        maxRequestTimeout: 3000 // use max request timeout of 3 sec
    }

    // storage for caching
    Storage {
        id: cache
    }

    // private
    Item {
        id: _

        // data properties
        property var books: []  // Array
        property var bookDetails: ({}) // Map

        // auth
        property bool userLoggedIn: false

    }
}
