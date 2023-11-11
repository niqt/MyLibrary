import QtQuick
import Felgo

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // model data properties
    readonly property alias books: _.books

    // action success signals
    signal bookStored(var book)

    // action error signals
    signal fetchBooksFailed(var error)
    signal storeBookFailed(var book, var error)
    signal deleteBookFailed()

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        onFetchBooks: search => {
            // check cached value first
            var cached = cache.getValue("books")
            if(cached)
                _.books = cached

            // load from api server
            api.getBooks(search,
                        function(data) {
                            var objectData = JSON.parse(data) // the data returned are a json string
                            var books = []
                            if (objectData.total > 0) {
                                books = objectData.books
                                // cache data before updating model property
                                cache.setValue("books",books)
                            }
                            _.books = books
                            booksChanged()
                        },
                        function(error) {
                            // action failed if no cached data
                            if(!cached)
                                fetchBooksFailed(error)
                        })
        }

        onStoreBook: book => {
                         // send to the server
                         api.saveBook(book,
                                     function(data) {
                                         var objData = JSON.parse(data)
                                         if (objData.total === 1) { // the answer contains the number of book saved
                                             var book = objData.books[0]
                                             bookStored(data)
                                         }
                                     },
                                     function(error) {
                                         storeBookFailed(book, error)
                                     })
                     }

        onDeleteBook: id => {
                         // delete
                         api.deleteBooksById(id,
                                     function(data) {
                                         // remove in local the book already deleted remotely
                                         // to avoid other fetch to the server
                                        _.books = _.books.filter(book => {
                                                       return book.id !== id
                                                       })
                                        cache.setValue("books", JSON.stringify(_.books))
                                        booksChanged()
                                     },
                                     function(error) {
                                         storeBookFailed(book, error)
                                     })
                     }

        onClearCache: {
            cache.clearAll()
        }
    }

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
    }
}
