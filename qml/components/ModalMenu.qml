import QtQuick
import Felgo

/*
  This elment it's used to show a modal menu with a list of options
  */

Item {

    id: item
    // the menu options
    property var menuModel: []

    // this property contains the reference to the Component that opened this modal
    // it needed to know what show when this modal is closed
    property alias pushBackContent: modal.pushBackContent

    // this signal is emitted when an elment is selected
    signal menuSelected(int index)

    // Show di element
    function open() {
        modal.open()
    }

    // Hide this element
    function close() {
        modal.close()
    }

    AppModal {
        id: modal
        // Set your main content root item
        NavigationStack {
            ListPage {
                id: menuList
                title: menuModel
                rightBarItem: TextButtonBarItem {
                    text: qsTr("Close")
                    textItem.font.pixelSize: sp(16)
                    onClicked: modal.close()
                }
                model: menuModel
                delegate: SimpleRow{
                    text: modelData
                    onSelected: index => {
                        menuSelected(index)
                        modal.close() // when element is selected, the item is automatically closed
                    }
                }
            }
        }
    }
}
