import QtQuick
import Felgo

Item {

    // loading state
    readonly property bool busy: HttpNetworkActivityIndicator.enabled

    // configure request timeout
    property int maxRequestTimeout: 5000

    // initialization
    Component.onCompleted: {
        // immediately activate loading indicator when a request is started
        HttpNetworkActivityIndicator.setActivationDelay(0)
    }

    // private
    QtObject {
        id: _
        // url to the my-library server
        property string myBookServer: "http://192.168.0.172:8080/api/v1"

        // url for the crud operation
        property string booksUrl: myBookServer + "/books"

        // url to create the user
        property string userCreationUrl: myBookServer + "/user"

        // url to login
        property string userLoginUrl: myBookServer + "/user/login"

        // url to the google api
        property string googleBooksUrl: "https://www.googleapis.com/books/v1/volumes"

        // all the http HttpRequest check the auth parameter to set the jwt token, if it's required

        function fetch(url, auth,success, error) {
            HttpRequest.get(url)
            .set("Authorization", (auth === true)?"Token " + userStorage.getValue("token"): "")
            .timeout(maxRequestTimeout)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function post(url, data, auth, success, error) {
            HttpRequest.post(url)
            .set("Authorization", (auth === true)?"Token " + userStorage.getValue("token"): "")
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function remove(url, auth, success, error) {
            HttpRequest.del(url)
            .set("Authorization", (auth === true)?"Token " + userStorage.getValue("token"): "")
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }
    }

    // public rest api functions

    // Get books from the server
    // if search is empty return all the books, otherwise the research is done
    // by title, author or isbn
    function getBooks(search, success, error) {
        _.fetch(_.booksUrl + "?search=" + search, true, success, error)
    }

    // Create or update a book remotely
    function saveBook(book, success, error) {
        _.post(_.booksUrl, book, true, success, error)
    }

    // Delete a book by id
    function deleteBooksById(id, success, error) {
        _.remove(_.booksUrl+"/"+id, true, success, error)
    }

    // search a book by isbn using the google api
    function getGoogleBooksByISBN(isbn, success, error) {
        var url = _.googleBooksUrl + "?q=isbn:" + isbn
        _.fetch(url, false, success, error)
    }

    // create the user
    function registration(email, password, success, error) {
        _.post(_.userCreationUrl, {"email": email, "password": password}, false, success, error )
    }

    // login
    function login(email, password, success, error) {
        _.post(_.userLoginUrl, {"email": email, "password": password}, false, success, error )
    }
}
