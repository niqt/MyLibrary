import QtQuick

Item {

    // actions
    signal fetchBooks()

    signal fetchBookDetails(int id)

    signal fetchDraftBooks()

    signal storeBook(var book)

    signal clearCache()

    signal fetchBookFromGoogle(string isbn)

    signal login(string username, string password)

    signal logout()

}
