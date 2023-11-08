import QtQuick
import Felgo
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtMultimedia
import bardecoder

Item {

    id: item
    signal isbnCaptured(string barcode)

    Camera
    {
        id:camera
        active: true
        focusMode: Camera.FocusModeAuto
    }

    CaptureSession {
        camera: camera
        videoOutput: videoOutput
    }

    VideoOutput
    {
        id: videoOutput
        anchors.fill: parent

        property double captureRectStartFactorX: 0.25
        property double captureRectStartFactorY: 0.25
        property double captureRectFactorWidth: 0.5
        property double captureRectFactorHeight: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                camera.customFocusPoint = Qt.point(mouseX / width,  mouseY / height);
                camera.focusMode = Camera.FocusModeManual;
            }
        }

        Rectangle {
            id: captureZone
            color: "red"
            opacity: 0.2
            width: parent.width * parent.captureRectFactorWidth
            height: parent.height * parent.captureRectFactorHeight
            x: parent.width * parent.captureRectStartFactorX
            y: parent.height * parent.captureRectStartFactorY

        }

        Component.onCompleted: { camera.active = true; }
    }

    Bardecoder {
        id: decoder
        videoSink: videoOutput.videoSink
        run: true
        onDecoded: code => {
                       console.log("QR " + code)
                       run = false
                       isbnCaptured(code)

                   }

    }

}
