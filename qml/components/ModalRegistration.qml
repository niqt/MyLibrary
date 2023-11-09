import QtQuick
import Felgo
import QtQuick.Layouts

Item {

    id: item
    property bool allFieldsValid: usernameField.isInputCorrect &&  termsOfServiceCheck.checked
    signal register(string email, string password)

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
            AppPage {
                title: qsTr("Registration")
                rightBarItem: TextButtonBarItem {
                    text: qsTr("close")
                    textItem.font.pixelSize: sp(16)
                    onClicked: modal.close()
                }
                ColumnLayout {
                    id: col
                    width: parent.width
                    spacing: 5

                    ValidatedField {
                        id: usernameField
                        Layout.fillWidth: true
                        label: qsTr("Username")
                        placeholderText: qsTr("Enter yours email address")
                        Layout.leftMargin: dp(50)
                        Layout.rightMargin: dp(50)
                        textField.text: ""
                        textField.inputMode: textField.inputModeEmail
                        textField.onActiveFocusChanged: {
                            hasError = !textField.activeFocus && !textField.acceptableInput
                        }

                        errorMessage: qsTr("The email address is not valid")
                    }
                    ValidatedField {
                        id: passwordField
                        property bool isPasswordTooShort: textField.text.length > 0 && textField.text.length < 6
                        Layout.fillWidth: true
                        label: qsTr("Password")
                        placeholderText: qsTr("Insert a password")
                        Layout.leftMargin: dp(50)
                        Layout.rightMargin: dp(50)
                        textField.text: ""
                        textField.inputMode: textField.inputModePassword
                        hasError: isPasswordTooShort
                        errorMessage: qsTr("Password is too short")
                    }
                    ValidatedField {
                        id: repeatPasswordField
                        property bool arePasswordsDifferent: passwordField.textField.text !== repeatPasswordField.textField.text
                        Layout.fillWidth: true
                        label: qsTr("Repeat Password")
                        placeholderText: qsTr("Insert a password")
                        Layout.leftMargin: dp(50)
                        Layout.rightMargin: dp(50)
                        textField.text: ""
                        textField.inputMode: textField.inputModePassword
                        hasError: arePasswordsDifferent
                        errorMessage: qsTr("Passwords do not match")
                    }
                    AppCheckBox {
                        id: termsOfServiceCheck
                        width: parent.width
                        text: qsTr("I agree to terms of service")
                        Layout.leftMargin: dp(50)
                    }

                    AppText {
                        text: qsTr("Read our <a href=\"https://www.consilium.europa.eu/en/policies/data-protection/data-protection-regulation//\">privacy policy</a>")
                        onLinkActivated: link => nativeUtils.openUrl(link)
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // the submit button is only enabled if every field is valid and without error.
                    AppButton {
                        text: qsTr("Register")
                        enabled: allFieldsValid
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            register(usernameField.textField.text, passwordField.textField.text)
                        }
                    }
                }
            }
        }
    }
}
