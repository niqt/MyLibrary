import QtQuick
import Felgo
import "../components"
import "../model"

// Photo of <a href="https://unsplash.com/it/@benwhitephotography?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Ben White</a> su <a href="https://unsplash.com/it/foto/garcon-portant-un-gilet-gris-et-une-chemise-rose-tenant-un-livre-qDY9ahp0Mto?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>

/*
  This page show the result from the google api
  */
AppPage {
    id: searchingPage
    title: qsTr("Search Books")

    // the books searched
    property var books: []

    // the isbn to search
    property string isbn: ""

    visible: false

    onVisibleChanged: {
        if (visible)
            logic.fetchBookFromGoogle(isbn) // search from google api
    }

    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: googleBooksDataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }
        IconButtonBarItem { // if no result add manually
            iconType: IconType.plus
            showItem: showItemAlways
            visible: booksNotFound.visible
            onClicked: {
                var book = ({})
                book.position = ""
                book.note = ""
                navigationStack.push(bookComponent, {book: book})
            }
        }
    }

    BooksNotFound { // Funny no result
        id: booksNotFound
        visible: !googleBooksDataModel.isBusy && googleBooksDataModel.gBooks.length === 0
        text: qsTr("Book not found. You can insert it manually tapping on +")
    }

    AppListView {
        model: googleBooksDataModel.gBooks
        delegate: BookRow {
            item: modelData
            onSelected: {
                var book = modelData
                book.position = ""
                book.note = ""
                navigationStack.push(bookComponent, {book: book}) // go to the detail page to save
            }
        }
        header: AppText {
            visible: googleBooksDataModel.gBooks.length > 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            text: qsTr("Select the book")
        }
    }
    Component {
        id: bookComponent
        BookPage {

        }
    }
    GoogleBooksDataModel {
        id: googleBooksDataModel
        dispatcher: logic

    }
}
