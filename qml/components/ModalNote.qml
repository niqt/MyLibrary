import QtQuick
import Felgo

/*
  This element used to show a textedit in full-screen
  */

Item {
    id: item
    // This property contains the text
    property alias text: appTextEdit.text

    // this property contains the reference to the Component that opened this modal
    // it needed to know what show when this modal is closed
    property alias pushBackContent: modal.pushBackContent

    // this property store the information about the chnage in the textfield
    property bool textChanged: false

    // Show this element with a text - empty or not
    function open(note) {
        text = note
        modal.open()
    }

    // hide this element
    function close() {
        modal.close()
    }

    // this signal is emitted to comunicate the the inserted texted has to be saved
    signal save(string text)

    AppModal {
        id: modal
        NavigationStack {
            AppPage {
                title: qsTr("Note")
                rightBarItem: TextButtonBarItem { // close action
                    text: qsTr("close")
                    textItem.font.pixelSize: sp(16)
                    onClicked: modal.close()
                }
                leftBarItem: IconButtonBarItem { // save action
                    iconType: IconType.check
                    visible: textChanged // it's visible only if the user modify the text
                    onClicked: {
                        item.save(text)
                        textChanged = false // set to false to avoid multi save of the same thing
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
                            placeholderText: qsTr("Write your note")
                            text: ""
                            onTextChanged: text => {
                                               item.textChanged = true // the text is changed
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
