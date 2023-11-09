import QtQuick

Item {

    // actions
    signal fetchBooks(string search)

    signal fetchBookDetails(int id)

    signal fetchDraftBooks()

    signal storeBook(var book)

    signal clearCache()

    signal fetchBookFromGoogle(string isbn)

    signal login(string email, string password)

    signal registration(string email, string password)

    signal logout()

}
