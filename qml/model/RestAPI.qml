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
        property string booksUrl: "https://jsonplaceholder.typicode.com/todos"
        property string googleBooksUrl: "https://www.googleapis.com/books/v1/volumes"
        function fetch(url, success, error) {
            HttpRequest.get(url)
            .timeout(maxRequestTimeout)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function post(url, data, success, error) {
            HttpRequest.post(url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }
    }

    // public rest api functions

    function getBooks(success, error) {
        _.fetch(_.booksUrl, success, error)
    }

    function getBooksById(id, success, error) {
        _.fetch(_.booksUrl+"/"+id, success, error)
    }

    function addBook(todo, success, error) {
        _.post(_.booksUrl, todo, success, error)
    }

    function getGoogleBooksByISBN(isbn, success, error) {
        var url = _.googleBooksUrl + "?q=isbn:" + isbn
        console.log(url)
        _.fetch(url, success, error)
    }
}
