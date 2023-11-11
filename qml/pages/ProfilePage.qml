import Felgo

/*
  profile page
  */

AppPage {
    title: qsTr("Profile")

    signal logoutClicked

    AppButton { // only logout button
        anchors.centerIn: parent
        text: qsTr("Logout user:") + userStorage.getValue("email")
        onClicked: logic.logout()
    }
}
