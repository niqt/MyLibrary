import QtQuick

Item {

    // actions

    // to get the books from the server - if search is empty get all the books
    signal fetchBooks(string search)

    // to create or update the book on the server
    signal storeBook(var book)

    // to delete the book on the server
    signal deleteBook(string id)

    // to clear the cache of the books
    signal clearCache()

    // to search a book using the google api
    signal fetchBookFromGoogle(string isbn)

    // to login
    signal login(string email, string password)

    // to register
    signal registration(string email, string password)

    // to logout
    signal logout()

}
