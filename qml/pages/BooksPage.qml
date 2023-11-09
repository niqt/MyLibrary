import QtQuick
import Felgo
import "../model"
import "../components"

/*

  profilo
    back-end
  */


ListPage {
    id: booksPage
    //showSearch: true
    property var selectedBook: ({})
    property int selectedIndex: -1;
    listView.visible: true
    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: libraryDataModel.isBusy
            visible: enabled && listView.visible
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }

        // add new book
        IconButtonBarItem {
            iconType: IconType.plus
            showItem: showItemAlways
            visible: listView.visible
            onClicked: {
                modal.open()
            }
        }

        TextButtonBarItem {
            text: qsTr("Close")
            showItem: showItemAlways
            visible: !listView.visible
            onClicked: {
                isbnReader.visible = false
                listView.visible = true
            }
        }
    }

    model: libraryDataModel.books

    delegate: SwipeOptionsContainer {
        id: container
        BookRow {
            id: bookRow
            item: modelData
        }
        leftOption: SwipeButton {           //left options, displayed when swiped list row to the right
            text: "Delete"
            iconType: IconType.trash
            height: bookRow.height
            backgroundColor: "red"
            onClicked: {
                // TODO confirm and delete
                container.hideOptions()         //hide automatically when button clicked
            }
        }
        rightOption: SwipeButton { //right options, displayed when swiped list row to the left
            text: "Note"
            iconType: IconType.comment
            height: bookRow.height
            onClicked: {
                booksPage.selectedBook = modelData
                booksPage.selectedIndex = index
                modalNote.open(modelData.note || "")
                container.hideOptions()         //hide automatically when button clicked
            }
        }
    }
    listView.header: Component {
        SearchBar {
            onEditingFinished: text => {
                logic.fetchBooks(text)
            }
            showDivider: true
            placeHolderText: qsTr("Search by Title, Author, ISBN13")
        }
    }

    ModalMenu {
        id: modal
        pushBackContent: navigationStack
        menuModel: [qsTr("Scan ISBN-13 with the camera"), qsTr("Insert the ISBN-13")]
        onMenuSelected: index => {
                            if ( index === 0) {
                                listView.visible = false
                                isbnReader.visible = true

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
        onSave: text => {
                    selectedBook.note = text
                    libraryDataModel.books[selectedIndex] = selectedBook
                    libraryDataModel.booksChanged()
                    logic.storeBook(selectedBook)
                }
    }

    ISBNReader {
        id: isbnReader
        visible: false
        anchors.fill: parent
        onIsbnCaptured: barcode => {
            visible = false
            listView.visible = true
            navigationStack.push(searchedBookComponent, {isbn: barcode})
        }

    }


    LibraryDataModel {
        id: libraryDataModel
        dispatcher: logic
        onFetchBooksFailed:       error       => NativeUtils.displayMessageBox("Unable to load books", error, 1)
        onFetchBookDetailsFailed: (error) => NativeUtils.displayMessageBox("Unable to load book " + error, 1)
        onStoreBookFailed:      (error) => NativeUtils.displayMessageBox("Failed to store ", 1)
        onBookStored: book => {
                          navigationStack.popAllExceptFirst()
                          logic.fetchBooks("")
                      }
    }

    Component {
        id: searchedBookComponent
        BooksSearchResultPage {

        }
    }
}
