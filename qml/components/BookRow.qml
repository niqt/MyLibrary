import QtQuick
import Felgo
import QtQuick.Layouts 1.12

/*
  This elemen is used to show in a list row the main information of the book
  */

Item {
    id: cell
    //  This property contains the book
    property var item: modelData

    // This property contain the book's title otherwise an empty string
    property string title: item && item.title  || ""

    // This property contain the url of the book image
    property string imageUrl: item && item.image || ""

    // Main cell content inside this item
    width: parent ? parent.width : 0
    // minimum of 48dp for interactable items recommended
    height: Math.max(dp(48), col.height)

    // This signal is emitted when the row is selected and return the selected book
    signal selected(var book)

    // With this layout set a space on the top, in the middle the book information and at the bottom a line separator

    ColumnLayout {
        id: col

        height: dp(220)
        x: dp(10)
        width: parent.width - 2 * x
        Item {
            id: topSpacer
            width: parent.width
            height: dp(6)
        }
        // With this layout set the book's image on the left and information on the right
        RowLayout {
            id: row
            spacing: dp(5)
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.fillHeight: true
            Rectangle { // gray ledge for the book's image
                width: dp(140)
                height: dp(180)
                color: "lightgrey"
                Layout.alignment: Qt.AlignVCenter
                radius: dp(5)
                RoundedImage {
                    id: roundedImage
                    fillMode: Image.PreserveAspectFit
                    visible: cell.imageUrl.length > 0
                    source: cell.imageUrl
                    height: dp(170)
                    width: dp(128)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            // Title and subtitle
            ColumnLayout {
                id: textCol
                Layout.alignment: Qt.AlignVCenter
                AppText {
                    text: title
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
                AppText {
                    text: "of: " + item.authors
                    fontSize: dp(8)
                    color: "darkgrey"
                }
            }
        }
        Item {
            id: bottomSpacer
            width: parent.width
            height: dp(6)
        }
        Rectangle { // line separator
            id: divider
            Layout.fillWidth: true
            color: Theme.dividerColor
            height: px(1)
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            selected(item)
        }
    }
}
