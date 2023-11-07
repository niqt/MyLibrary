import QtQuick
import Felgo
import "../components"

AppPage {

    title: "Libri trovati"
    property var books: []
    AppListView {
        model: books
        delegate: BookRow {
            item: modelData
            //image.source: modelData.image
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
}
