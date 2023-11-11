import QtQuick
import Felgo

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy


    // model data properties
    readonly property alias gBooks: _.gBooks

    // action error signals
    signal fetchGbooksFailed(var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        onFetchBookFromGoogle: isbn => {
            // load from api

            api.getGoogleBooksByISBN(isbn,

                        function(data) {
                            var books = []
                            if (data.totalItems > 0) {
                                for(var i = 0; i < data.items.length; i++) {
                                    // get only the main information
                                    var book = googleBookToBook(data.items[i])
                                    books.push(book)
                                }
                            }
                            _.gBooks = books
                            gBooksChanged()
                        },
                        function(error) {
                            // action failed if no cached data
                            fetchBooksFailed(error)
                        })
        }
    }

    // rest api for data access
    RestAPI {
        id: api
        maxRequestTimeout: 3000 // use max request timeout of 3 sec
    }

    // private
    Item {
        id: _

        // data properties
        property var gBooks: []  // Array
    }

    // Reduce the book information received from google
    // Get title, subtitle, authors, image, categories, number of pages, publisher
    // isbn13 and isbn10
    function googleBookToBook(gBook) {
        var info = gBook.volumeInfo
        var book = ({})
        book.title = info.title
        book.subtitle = info.subtitle
        var authors = ""
        for (var j = 0; j < info.authors.length; j++) {
            authors = info.authors[j] + ","
        }
        // TODO remove , at the end
        book.authors = authors
        book.publisher = info.publisher
        book.pages = info.pageCount
        var categories = ""
        for (var k = 0; k < info.authors.length; k++) {
            categories = info.categories[k] + ","
        }
        // TODO remove , at the end
        for (var l = 0; l < info.industryIdentifiers.length; l++) {
            if (info.industryIdentifiers[l].type === "ISBN_10")
                book.isbn10 = info.industryIdentifiers[l].identifier
            if (info.industryIdentifiers[l].type === "ISBN_13")
                book.isbn13 = info.industryIdentifiers[l].identifier
        }
        book.categories = categories
        if (info.imageLinks.smallThumbnail !== undefined)
            book.image = info.imageLinks.smallThumbnail
        return book
    }
}
