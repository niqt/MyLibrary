import QtQuick
import Felgo

Item {
    id: item
    readonly property bool userLoggedIn: _.userLoggedIn
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // model data properties
    readonly property alias user: _.user


    // action success signals
    signal userStored(var user)
    signal login(var user)
    signal registration()
    signal logged()



    // action error signals
    signal loginFailed(var error)
    signal registrationFailed()
    signal storeUserFailed(var user, var error)


    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        onLogin: function (email, password) {
            api.login(email, password,
                function(data) {
                    var user = JSON.parse(data).user
                    userStorage.setValue("token", user.token)
                    userStorage.setValue("logged", true)
                    userStorage.setValue("email", user.email)
                    _.userLoggedIn = true
                    userLoggedInChanged()
                    logged()
                },
                function(error) {
                    userStorage.setValue("logged", false)
                    loginFailed(error)
                })
        }

        onRegistration: (email, password) => {
            api.registration(email, password,
                        function(data) {
                            var user = JSON.parse(data).user
                            userStorage.setValue("token", user.token)
                            userStorage.setValue("logged", true)
                            userStorage.setValue("email", user.email)
                            registration()
                        },
                        function(error) {

                            userStorage.setValue("logged", false)
                            registrationFailed()
                        })
        }


        onLogout: {
            userStorage.setValue("logged", false)
            userStorage.setValue("email", "")
            userStorage.setValue("token", "")

            _.userLoggedIn = false
        }
    }

    // rest api for data access
    RestAPI {
        id: api
        maxRequestTimeout: 60000 // use max request timeout of 1 min
    }

    // private
    Item {
        id: _
        property var user: ({}) // Map

        // auth:
        property bool userLoggedIn: (userStorage.getValue("logged") === undefined)?false: userStorage.getValue("logged")

    }
}
