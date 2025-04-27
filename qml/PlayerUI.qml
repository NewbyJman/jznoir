import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    color: "#2c2c2c"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Image {
            width: 300; height: 300
            source: AudioEngine.currentCoverArt || "qrc:/logo.png"
        }

        Text {
            text: AudioEngine.currentTitle || "No track playing"
            color: "#d9d9d9"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Slider {
            width: 500
            from: 0
            to: AudioEngine.duration
            value: AudioEngine.position
            onMoved: AudioEngine.seek(value)
        }

        Row {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
            Button { icon.source: "qrc:/icons/prev.svg"; onClicked: AudioEngine.prev() }
            Button { icon.source: AudioEngine.playing ? "qrc:/icons/pause.svg" : "qrc:/icons/play.svg"; onClicked: AudioEngine.togglePlay() }
            Button { icon.source: "qrc:/icons/next.svg"; onClicked: AudioEngine.next() }
        }
    }
}