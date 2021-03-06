import QtQuick 2.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

SilicaFlickable {
    id: flickable

    property bool itemScaled: scale != 1.0
    property alias source: photo.source
    property alias image: photo
    property alias scale: photo.scale
    property real minimumWidth: width
    property real maximumWidth
    property real minimumHeight: height
    property real maximumHeight
    property real initialImageWidth: width
    property real initialImageHeight: height
    property int imageHeight
    property int imageWidth
    property int status: Image.Null
    property alias brightness: adjustLevels.brightness
    property alias contrast: adjustLevels.contrast

    property real maximumZoom: Math.max(Screen.width, Screen.height) / 200

    property int orientation

    readonly property bool _transpose: (orientation % 180) != 0

    signal clicked

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    implicitWidth: !_transpose ? photo.implicitWidth : photo.implicitHeight
    implicitHeight: !_transpose ? photo.implicitHeight : photo.implicitWidth

    contentWidth: flickable.implicitWidth * photo.scale
    contentHeight: flickable.implicitHeight * photo.scale

    pressDelay: 0

    function resetScale() {
        photo.updateScale()
    }


    PinchArea {
        id: pinchArea

        anchors.fill: parent
        enabled: interactive && photo.status == Image.Ready
        pinch.target: photo
        pinch.minimumScale: Math.max(minimumWidth / flickable.implicitWidth, minimumHeight / flickable.implicitHeight)
        pinch.maximumScale: Math.max(flickable.maximumZoom, pinch.minimumScale)
        pinch.dragAxis: Pinch.XandYAxis
        onPinchFinished: flickable.returnToBounds()
        clip: true

        BrightnessContrast {
            id: adjustLevels

            anchors.fill: photo
            source: photo
            rotation: photo.rotation
            scale: photo.scale
        }

        Image {
            id: photo
            property real prevScale

            function updateScale() {
                if (status != Image.Ready)
                    return

                var fittedScale
                var isImagePortrait = flickable.implicitWidth < flickable.implicitHeight
                var minimumDimension = Math.min(initialImageHeight, initialImageWidth)
                fittedScale = Math.min(minimumDimension / (isImagePortrait ? flickable.implicitWidth : flickable.implicitHeight),
                                       pinchArea.pinch.maximumScale)

                scale = fittedScale
                flickable.contentX = (flickable.implicitWidth * scale - flickable.width) / 2
                flickable.contentY = (flickable.implicitHeight * scale - flickable.height) / 2
            }

            objectName: "zoomableImage"
            cache: false
            smooth: !(flickable.movingVertically || flickable.movingHorizontally)
            fillMode:  Image.PreserveAspectFit
            asynchronous: true
            anchors.centerIn: parent

            // On the Jolla 1, we're experiencing a crash inside the OpenGL
            // driver blob which starts when an FBO is somewhere around 2500+
            // pixels in size. Max texture size and Max renderbuffer size are
            // both 4096, well within, so the actual cause is unknown.
            property bool isJolla1: Screen.width == 540 && Screen.height == 960
            sourceSize {
                width: isJolla1 ? 2048 : 3264
                height: isJolla1 ? 2048 : 3264
            }

            rotation: -orientation

            onStatusChanged: {
                flickable.status = status
                updateScale()
            }

            onScaleChanged: {
                if ((width * scale) > flickable.width) {
                    var xoff = (flickable.width / 2 + flickable.contentX) * scale / prevScale;
                    flickable.contentX = xoff - flickable.width / 2;
                }
                if ((height * scale) > flickable.height) {
                    var yoff = (flickable.height / 2 + flickable.contentY) * scale / prevScale;
                    flickable.contentY = yoff - flickable.height / 2;
                }
                prevScale = scale;
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: !flickable.moving && !pinchArea.pinch.active
            onClicked: flickable.clicked()
        }
    }
}
