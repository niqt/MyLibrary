import QtQuick
import Felgo
import QtQuick.Layouts

/*
  This elment contain the form for the registration
  */

Item {

    id: item
    // This property is true o false depending on if the fields contain valid value
    property bool allFieldsValid: usernameField.isInputCorrect &&  termsOfServiceCheck.checked && !passwordField.hasError && !repeatPasswordField.hasError

    // this property contains the reference to the Component that opened this modal
    // it needed to know what show when this modal is closed
    property alias pushBackContent: modal.pushBackContent

    // This signal is emitted to comunicate the email and the password
    signal register(string email, string password)

    // show this form
    function open() {
        modal.open()
    }

    // hide this form
    function close() {
        modal.close()
    }

    AppModal {
        id: modal
        // Set your main content root item
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
                    // all the fields have a margin on the left and the right
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
                            // emit the signal passing the credentials
                            register(usernameField.textField.text, passwordField.textField.text)
                        }
                    }
                }
            }
        }
    }
}
