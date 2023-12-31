import Felgo
import QtQuick
import QtQuick.Layouts
import "../components"

/*
  The login page
  */

AppPage {
    id: loginPage
    title: qsTr("Login")

    useSafeArea: false // do not consider safe area insets of screen

    BackgroundImage { // background image for the page
        source: Qt.resolvedUrl("../../assets/eugenio.jpg")
    }

    // login form background
    Rectangle {
        id: loginForm
        anchors.centerIn: parent
        color: "black"
        width: content.width + dp(48)
        height: content.height + dp(16)
        radius: dp(4)
        opacity: 0.5
    }

    // login form content
    GridLayout {
        id: content
        anchors.centerIn: loginForm
        columnSpacing: dp(20)
        rowSpacing: dp(10)
        columns: 2
        // headline
        AppText {
            Layout.topMargin: dp(8)
            Layout.bottomMargin: dp(12)
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            text: "Login"
            color: "white"
        }

        // email text and field
        AppText {
            text: qsTr("E-mail")
            font.pixelSize: sp(12)
            color: "white"
        }

        AppTextField {
            id: txtUsername
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
            color: Theme.isAndroid ? "white": "black"
        }

        // password text and field
        AppText {
            text: qsTr("Password")
            font.pixelSize: sp(12)
            color: "white"
        }

        AppTextField {
            id: txtPassword
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
            echoMode: TextInput.Password
            color: Theme.isAndroid ? "white": "black"
        }

        // column for buttons, we use column here to avoid additional spacing between buttons
        Column {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.topMargin: dp(12)

            // buttons
            AppButton {
                text: qsTr("Login")
                flat: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    loginPage.forceActiveFocus() // move focus away from text fields
                    logic.login(txtUsername.text.toLowerCase(), txtPassword.text) // login
                }
            }

            AppButton {
                text: qsTr("No account yet? Register now")
                flat: true
                anchors.horizontalCenter: parent.horizontalCenter
                textColor: "white"
                onClicked: {
                    loginPage.forceActiveFocus() // move focus away from text fields
                    modalRegistration.open() // open the registration modal
                }
            }
        }
    }
    ModalRegistration {
        id: modalRegistration
        onRegister: function(email, password) {
            logic.registration(email, password) // send the signal to create the user
        }
    }

    Connections {
        target: userDataModel
        enabled: loginPage.visible
        onRegistration: {
            NativeUtils.displayMessageBox(qsTr("Registration"), qsTr("Congratulations, Registered! Don't forget the password"))
            modalRegistration.close()
        }
        onRegistrationFailed: {
            NativeUtils.displayAlertDialog(qsTr("Registration"), qsTr("NOT Registered! Please retry later"))
        }
    }
}
