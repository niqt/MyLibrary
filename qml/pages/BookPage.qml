import QtQuick
import Felgo
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../model"

AppPage {
    title: qsTr("New Book")
    property var book: ({})
    property bool fieldsValid: titleField.hasTitle && !isbn13Field.isbn13Incorrect && !isbn10Field.isbn10Incorrect
    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: dataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }

        // save the book
        IconButtonBarItem {
            iconType: IconType.save
            showItem: showItemAlways
            visible: fieldsValid
            onClicked: {
                book.title = titleField.textField.text
                book.subtitle = subtitleField.textField.text
                book.authors = authorsField.textField.text
                book.position = positionField.textField.text
                book.isbn13 = isbn13Field.textField.text
                book.isbn10 = isbn10Field.textField.text
                book.note = noteField.textField.text
                book.pages = pagesField.textField.text
                logic.storeBook(book)
            }
        }
    }
    ScrollView {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        contentWidth: -1
        contentHeight:col.height
        anchors.bottomMargin: dp(60)
        ColumnLayout {
            id: col
            width: scrollView.width
            spacing: 0
            RoundedImage {
                source: book.image || ""
                Layout.alignment: Qt.AlignHCenter
            }
            ValidatedField {
                id: positionField
                Layout.fillWidth: true
                label: qsTr("Position")
                placeholderText: qsTr("Enter yours library label")
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                textField.text: book.position || ""
            }
            ValidatedField {
                id: authorsField
                Layout.fillWidth: true
                label: qsTr("Authors")
                placeholderText: qsTr("Enter authors separated by comma")
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                textField.text: book.authors || ""
            }
            ValidatedField {
                id: titleField
                property bool hasTitle: textField.text.length > 0
                errorMessage: qsTr("Insert a title")
                hasError: !hasTitle
                Layout.fillWidth: true
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                label: qsTr("Title")
                placeholderText: qsTr("Enter book's title")
                textField.text: book.title || ""
            }
            ValidatedField {
                id: subtitleField
                Layout.fillWidth: true
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                label: qsTr("Subtitle")
                placeholderText: qsTr("Enter book's subtitle")
                textField.text: book.subtitle || ""
            }
            ValidatedField {
                id: isbn13Field
                property bool isbn13Incorrect: textField.text.length > 0 && textField.text.length < 13
                errorMessage: qsTr("Insert a number of 13 digits")
                hasError: isbn13Incorrect
                Layout.fillWidth: true
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                label: qsTr("ISBN-13")
                placeholderText: qsTr("Enter isbn-13 code without -")
                maximumLength: 13
                textField.text: book.isbn13 || ""
            }
            ValidatedField {
                id: isbn10Field
                property bool isbn10Incorrect: textField.text.length > 0 && textField.text.length < 10
                errorMessage: qsTr("Insert a number of 10 digits")
                hasError: isbn10Incorrect
                Layout.fillWidth: true
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                label: qsTr("ISBN-10")
                placeholderText: qsTr("Enter isbn-10 code without -")
                maximumLength: 10
                textField.text: book.isbn10 || ""
            }
            ValidatedField {
                id: pagesField
                Layout.fillWidth: true
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                label: qsTr("Pages")
                placeholderText: qsTr("Enter number's of page")
                textField.text: book.pages || ""
            }
            ValidatedField {
                id: noteField
                Layout.fillWidth: true
                label: qsTr("Note")
                Layout.leftMargin: dp(5)
                Layout.rightMargin: dp(5)
                placeholderText: qsTr("Enter yours note")
                textField.text: book.note || ""
            }
        }
    }
    Connections {
        target: libraryDataModel
        onBookStored: book => {
                          navigationStack.popAllExceptFirst()
                      }
    }
}
