import Felgo
import QtQuick
import "model"
import "logic"
import "pages"


App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    // app initialization
    Component.onCompleted: {
        // if device has network connection, clear cache at startup
        // you'll probably implement a more intelligent cache cleanup for your app
        // e.g. to only clear the items that aren't required regularly
        if(isOnline) {
            logic.clearCache()
        }
        //userStorage.clearAll()

        if (userStorage.getValue("logged") === true)
            logic.fetchBooks("")
    }

    // business logic
    Logic {
        id: logic
    }

    UserDataModel {
        id: userDataModel
        dispatcher: logic
        onLogged: {
            logic.fetchBooks("")
        }
        onLoginFailed: {
             NativeUtils.displayAlertDialog(qsTr("Login"), qsTr("Check the credentials"), qsTr("OK"))
        }

    }



    // helper functions for view
    ViewHelper {
        id: viewHelper
    }

    // view
    Navigation {
        id: navigation

        // only enable if user is logged in
        // login page below overlays navigation then
        enabled: userDataModel.userLoggedIn

        // first tab
        NavigationItem {
            title: qsTr("MyBook")
            iconType: IconType.list

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: BooksPage { }
            }
        }

        // second tab
        NavigationItem {
            title: qsTr("Profile") // use qsTr for strings you want to translate
            iconType: IconType.circle

            NavigationStack {
                initialPage: ProfilePage {
                    // handle logout
                    onLogoutClicked: {
                        logic.logout()

                        // jump to main page after logout
                        navigation.currentIndex = 0
                        navigation.currentNavigationItem.navigationStack.popAllExceptFirst()
                    }
                }
            }
        }
    }

    // login page lies on top of previous items and overlays if user is not logged in
    LoginPage {
        visible: opacity > 0
        enabled: visible
        opacity: userDataModel.userLoggedIn ? 0 : 1 // hide if user is logged in

        Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
    }

    Storage {
        id: userStorage
        databaseName: "userStorage"
    }

}
