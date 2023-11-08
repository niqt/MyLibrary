import QtQuick
import Felgo
import "../model"
import "../components"

/*

  ricerca
  profilo
  undo
    back-end
  */


ListPage {
    id: booksPage
    showSearch: true
    property var selecetedBook: ({})
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
                booksPage.selecetedBook = modelData
                booksPage.selectedIndex = index
                modalNote.open(modelData.note)
                container.hideOptions()         //hide automatically when button clicked
            }
        }
    }

    // TODO
    onSearch: term => {

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
                    selecetedBook.note = text
                    libraryDataModel.books[selectedIndex] = selecetedBook
                    libraryDataModel.booksChanged()
                    // TODO SAVE BOOK
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
