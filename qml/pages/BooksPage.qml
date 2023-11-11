import QtQuick
import Felgo
import "../model"
import "../components"

// This page contains the books of the library
ListPage {
    id: booksPage
    title: (libraryDataModel.books.length === 0)? qsTr("Books"): libraryDataModel.books.length + qsTr(" Books")

    // the book selected
    property var selectedBook: ({})

    // the index in the list of the book selected
    property int selectedIndex: -1;

    // The list view is hide when the camera it's use to scan the isbn barcode
    // Due a problem on android is not possible have the camera in other page
    // in that case the UI is frozen
    listView.visible: true

    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            id: busyIndicator
            enabled: libraryDataModel.isBusy
            visible: enabled && listView.visible
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }

        // add new book
        IconButtonBarItem { // open the menu to choose how search the book
            iconType: IconType.plus
            showItem: showItemAlways
            visible: listView.visible
            onClicked: {
                modal.open()
            }
        }

        TextButtonBarItem { // close the isbn reader
            text: qsTr("Close")
            showItem: showItemAlways
            visible: !listView.visible
            onClicked: {
                isbnReader.visible = false
                listView.visible = true
                isbnReader.run = false
            }
        }
    }

    model: libraryDataModel.books

    delegate: SwipeOptionsContainer {
        id: container
        BookRow {
            id: bookRow
            item: modelData
            onSelected: book => {
                            navigationStack.push(bookComponent, {book: book}) // go to the book details
                        }
        }
        leftOption: SwipeButton {           //left options, displayed when swiped list row to the right
            text: "Delete"
            iconType: IconType.trash
            height: bookRow.height
            backgroundColor: "red"
            onClicked: {
                container.hideOptions()         //hide automatically when button clicked
                selectedIndex = index
                logic.deleteBook(modelData.id)  // delete the book
            }
        }
        rightOption: SwipeButton { //right options, displayed when swiped list row to the left
            text: "Note"
            iconType: IconType.comment
            height: bookRow.height
            onClicked: {
                booksPage.selectedBook = modelData
                booksPage.selectedIndex = index
                modalNote.open(modelData.note || "") // open the book note
                container.hideOptions()         //hide automatically when button clicked
            }
        }
    }
    listView.header: Component {
        SearchBar {
            onEditingFinished: text => {
                logic.fetchBooks(text) // search books using the text in the search bar
            }
            showDivider: true
            placeHolderText: qsTr("Search by Title, Author, ISBN13")
        }
    }

    BooksNotFound { // Funny message when the library is empty
        visible: !busyIndicator.visible && libraryDataModel.books.length === 0
        text: qsTr("Your library is empty. Add books tapping on +")
    }


    ModalMenu { // Modal menu
        id: modal
        pushBackContent: navigationStack
        menuModel: [qsTr("Scan ISBN-13 with the camera"), qsTr("Insert the ISBN-13")]
        onMenuSelected: index => {
                            if ( index === 0) {
                                listView.visible = false
                                isbnReader.visible = true
                                isbnReader.run = true

                            } else {
                                NativeDialog.inputText(qsTr("Search"), qsTr("Insert the ISBN-13"), "", "", function(ok, text) {
                                    if(ok) {
                                        navigationStack.push(searchedBookComponent, {isbn: text})
                                    }

                                })
                            }
                        }
    }

    ModalNote {
        id: modalNote
        pushBackContent: navigationStack
        onSave: text => { // when the save event for the note is generated
                    selectedBook.note = text
                    libraryDataModel.books[selectedIndex] = selectedBook
                    libraryDataModel.booksChanged()
                    logic.storeBook(selectedBook) //update the book
                }
    }

    ISBNReader {
        id: isbnReader
        visible: false
        run: false
        anchors.fill: parent
        onIsbnCaptured: barcode => {
            visible = false // hide itself
            listView.visible = true // show the list
            run = false // stop to scanning
            navigationStack.push(searchedBookComponent, {isbn: barcode}) // go to the result research page
        }

    }


    LibraryDataModel {
        id: libraryDataModel
        dispatcher: logic
        onFetchBooksFailed:       error       => NativeUtils.displayMessageBox("Unable to load books", error, 1)
        onStoreBookFailed:      (error) => NativeUtils.displayMessageBox("Failed to store ", 1)
        onBookStored: book => {
                          navigationStack.popAllExceptFirst() // hide the bookpage
                          logic.fetchBooks("") // reget the books after the save action
                      }
    }

    Component {
        id: searchedBookComponent
        BooksSearchResultPage {

        }
    }

    Component {
        id: bookComponent
        BookPage {

        }
    }
}
