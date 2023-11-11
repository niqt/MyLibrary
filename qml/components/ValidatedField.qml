import QtQuick 2.0
import Felgo 4.0

Column {
    id: root

    // this property contains the size for the error text message
    property real secondaryTextSize: sp(12)

    // this property define the criteria for the correct input
    property bool isInputCorrect: textInput.acceptableInput && !hasError && textInput.text.length > 0

    // this property is true if the textfield contains a not valid value
    property bool hasError: false

    // The error message
    property string errorMessage: qsTr("Error")

    // the reference to the text label
    property alias label: label.text

    // the reference to the textfield
    property alias textField: textInput

    // the reference to the placeholder of the textfield
    property alias placeholderText: textInput.placeholderText

    // the reference to the validator of the textfield
    property alias validator: textInput.validator

    // the maximum length of the textfield
    property alias maximumLength: textInput.maximumLength

    // the wrap mode for the text field
    property alias wrapMode: textInput.wrapMode

    QtObject {
        id: internal
        // we only display the error message when textfield is not in focus
        property bool displayError: root.hasError && !textInput.activeFocus
        readonly property color errorColor: "red"
        readonly property real borderWidth: dp(1)
    }

    AppText {
        id: label
        x: textInput.x + 10
        color: "darkgray"
        font.bold: true
    }

    AppTextField {
        id: textInput
        anchors { left: parent.left; right: parent.right }

        borderWidth: internal.borderWidth
        backgroundColor: "#ecedf1"
        radius: dp(5)
        onEditingFinished: {
            // close the keyboard
            focus = false
        }

        // here we change borderColor depending on the current textinput state
        states: [
            State {
                when: internal.displayError
                PropertyChanges {
                    target: textInput
                    borderColor: internal.errorColor
                }
            },
            State {
                when: textInput.activeFocus
                PropertyChanges {
                    target: textInput
                    borderColor: Theme.colors.tintColor
                }
            },
            State {
                PropertyChanges {
                    target: textInput
                    borderColor: Theme.colors.dividerColor
                }
            }
        ]

        // display a nice color transition when changing borderColor
        Behavior on borderColor { ColorAnimation { } }
    }

    AppText {
        id: textError
        text: root.errorMessage
        color: internal.errorColor
        font.pixelSize: secondaryTextSize
        opacity: internal.displayError ? 1.0 : 0.0

        // we display a short fade animation when the error message changes state
        Behavior on opacity { NumberAnimation { } }
    }
}
