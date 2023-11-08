import QtQuick
import Felgo
import QtQuick.Layouts 1.12

Item {
    id: cell
    property var item: modelData
    property string title: item && item.title  || ""
    property string image: item && item.image || ""

    // Main cell content inside this item
    width: parent ? parent.width : 0
    // minimum of 48dp for interactable items recommended
    height: Math.max(dp(48), col.height)
    signal selected(var book)

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
        RowLayout {
            id: row
            spacing: dp(5)
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.fillHeight: true
            Rectangle {
                width: dp(140)
                height: dp(180)
                color: "lightgrey"
                Layout.alignment: Qt.AlignVCenter
                radius: dp(5)
                RoundedImage {
                    id: roundedImage
                    fillMode: Image.PreserveAspectFit
                    visible: cell.image.length > 0
                    source: cell.image
                    height: dp(170)
                    width: dp(128)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

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
        Rectangle {
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
