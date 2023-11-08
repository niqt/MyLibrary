import QtQuick
import Felgo

Item {

    id: item
    property var menuModel: []
    property alias pushBackContent: modal.pushBackContent

    signal menuSelected(int index)

    function open() {
        modal.open()
    }
    function close() {
        modal.close()
    }

    AppModal {
        id: modal
        // Set your main content root item
        pushBackContent: navigationStack
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
                        modal.close()
                    }
                }
            }
        }
    }
}
