import QtQuick
import Felgo
import "../model"
import "../components"

ListPage {
    id: booksPage
    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: dataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }

        // add new book
        IconButtonBarItem {
            iconType: IconType.plus
            showItem: showItemAlways
            onClicked: {

                var title = qsTr("New Book")

                // this logic helper function creates a todo
                modal.open()
            }
        }
    }

    model: libraryDataModel.books

    delegate: BookRow {
        item: modelData
    }

    AppModal {
        id: modal
        // Set your main content root item
        pushBackContent: navigationStack

        NavigationStack {
            ListPage {
                title: qsTr("Add a book")
                rightBarItem: TextButtonBarItem {
                    text: qsTr("Chiudi")
                    textItem.font.pixelSize: sp(16)
                    onClicked: modal.close()
                }
                model: [qsTr("Scan isbn with the camera"), qsTr("Typing the isbn")]
                delegate: SimpleRow{
                    text: modelData
                    onSelected: {
                        modal.close()
                        if ( index == 0) {
                            // TODO scan using the camera
                        } else {
                            NativeDialog.inputText(qsTr("Search"), qsTr("Insert the ISBN-14"), "", "", function(ok, text) {
                                if(ok) {

                                    logic.fetchBookFromGoogle("9780134494166")
                                } else {

                                }

                            })
                        }
                    }

                }
            }
        }
    }

    GoogleBooksDataModel {
        id: googleBooksDataModel
        dispatcher: logic

    }

    LibraryDataModel {
        id: libraryDataModel
        dispatcher: logic

    }

    Connections {
        target: googleBooksDataModel
        enabled: booksPage.visible
        function onGBooksChanged() {
            if (googleBooksDataModel.gBooks.length > 0) {
                navigationStack.push(searchedBookComponent, {books: googleBooksDataModel.gBooks})
            }
        }
    }

    Connections {
        enabled: booksPage.visible
        target: libraryDataModel
    }

    Component {
        id: searchedBookComponent
        BooksSearchResultPage {

        }
    }
}
