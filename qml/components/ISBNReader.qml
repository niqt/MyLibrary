import QtQuick
import Felgo
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtMultimedia
import bardecoder

/*
  This element contains the logic and the components for the ISBN reader.
  It use the camera, the CaputureSession to capture the video from the camera and it sent
  to VideoOutput to be shown. The decoder get the video frames using the videoSync from the VideoOutput.
  The signal isbnCaptured is emitted if the decoder found a barcode.
  */

Item {

    id: item

    // This property enable/disable the decoding action
    property alias run: decoder.run

    // This signal is emitted when the barcode is found
    signal isbnCaptured(string barcode)

    Camera // The camera
    {
        id:camera
        active: run
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

        // The follow properties are used to scale the red capture area on the camera video
        property double captureRectStartFactorX: 0.25
        property double captureRectStartFactorY: 0.25
        property double captureRectFactorWidth: 0.5
        property double captureRectFactorHeight: 0.5

        MouseArea { // Clicking remove the autofocus
            anchors.fill: parent
            onClicked: {
                camera.customFocusPoint = Qt.point(mouseX / width,  mouseY / height);
                camera.focusMode = Camera.FocusModeManual;
            }
        }

        Rectangle { // The capture zone
            id: captureZone
            color: "red"
            opacity: 0.2
            width: parent.width * parent.captureRectFactorWidth
            height: parent.height * parent.captureRectFactorHeight
            x: parent.width * parent.captureRectStartFactorX
            y: parent.height * parent.captureRectStartFactorY

        }
    }

    Bardecoder { // The barcode decoder
        id: decoder
        videoSink: videoOutput.videoSink // in this way capture the video frames

        onDecoded: code => {
                       console.log("QR " + code)
                       run = false // stop to decode
                       isbnCaptured(code) // send the value
                   }
    }
}
