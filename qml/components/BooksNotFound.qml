import QtQuick
import Felgo

/*
  This elment it used to show a fun image and a text to communicate at the user that there are not result loading or searching books
  */

Item {

    id: item
    width: parent.width // use all the horizantale parent space
    height: col.height // It's height image (can chang due the image have to preserve the aspect fit, plus the text height

    // This property it used to customize the text to show
    property alias text: notFoundText.text

    Column {
        id: col
        anchors.fill: parent
        AppImage {
            source: Qt.resolvedUrl("../../assets/ben.jpg")
            width: parent.width
            fillMode: Image.PreserveAspectFit
            AppText {
                id: notFoundText
                anchors.top: parent.top // the text overlay the image on the top
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
                color: "white"
            }
        }
    }
}
