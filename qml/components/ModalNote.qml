import QtQuick
import Felgo

Item {
    id: item
    property alias text: appTextEdit.text
    property alias pushBackContent: modal.pushBackContent
    property bool textChanged: false

    function open(note) {
        text = note
        modal.open()
    }

    function close() {
        modal.close()
    }

    signal save(string text)

    AppModal {
        id: modal
        // Set your main content root item
        pushBackContent: navigationStack

        NavigationStack {
            AppPage {
                title: qsTr("Note")
                rightBarItem: TextButtonBarItem {
                    text: qsTr("close")
                    textItem.font.pixelSize: sp(16)
                    onClicked: modal.close()
                }
                leftBarItem: IconButtonBarItem {
                    iconType: IconType.check
                    visible: textChanged
                    onClicked: {
                        item.save(text)
                        textChanged = false
                    }
                }
                backgroundColor: Theme.secondaryBackgroundColor

                // Container for the text field
                Item {
                    width: parent.width
                    height: parent.height

                    // Flickable for scrolling, with text field inside
                    AppFlickable {
                        id: flick
                        anchors.fill: parent
                        contentWidth: width
                        contentHeight: appTextEdit.height
                        anchors.margins: dp(5)

                        AppTextEdit {
                            id: appTextEdit
                            width: parent.width
                            height: Math.max(appTextEdit.contentHeight, flick.height)
                            verticalAlignment: TextEdit.AlignTop
                            // This enables the text field to automatically scroll if cursor moves outside while typing
                            cursorInView: true
                            cursorInViewBottomPadding: dp(25)
                            cursorInViewTopPadding: dp(25)
                            flickable: flick

                            text: ""
                            onTextChanged: text => {
                                               item.textChanged = true
                                           }
                        }
                    }
                    AppScrollIndicator {
                        flickable: flick
                    }
                }
            }
        }
    }
}
