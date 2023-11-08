import QtQuick
import Felgo
import "../components"
import "../model"

// Foto di <a href="https://unsplash.com/it/@benwhitephotography?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Ben White</a> su <a href="https://unsplash.com/it/foto/garcon-portant-un-gilet-gris-et-une-chemise-rose-tenant-un-livre-qDY9ahp0Mto?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>

AppPage {
    id: searchingPage
    title: qsTr("Search Books")
    property var books: []
    property string isbn: ""
    visible: false

    onVisibleChanged: {
        if (visible)
            logic.fetchBookFromGoogle(isbn)
    }

    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: googleBooksDataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }
        IconButtonBarItem {
            iconType: IconType.plus
            showItem: showItemAlways
            visible: notFoundText.visible
            onClicked: {
                var book = ({})
                book.position = ""
                book.note = ""
                navigationStack.push(bookComponent, {book: book})
            }
        }
    }

    AppImage {
        source: Qt.resolvedUrl("../../assets/ben.jpg")
        width: parent.width
        fillMode: Image.PreserveAspectFit
        visible: notFoundText.visible
    }

    AppText {
        id: notFoundText
        text: qsTr("Book not found. You can insert it manually. Tap on +")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        visible: !googleBooksDataModel.isBusy && googleBooksDataModel.gBooks.length === 0
    }

    AppListView {
        model: googleBooksDataModel.gBooks
        delegate: BookRow {
            item: modelData
            onSelected: {
                var book = modelData
                book.position = ""
                book.note = ""
                navigationStack.push(bookComponent, {book: book})
            }
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
