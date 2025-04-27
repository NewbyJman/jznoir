import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    height: 80
    color: "#2c2c2c"
    border.color: "#7030a0"

    Row {
        anchors.centerIn: parent
        spacing: 30
        Button { icon.source: "icons/prev.svg" }
        Button { icon.source: "icons/play.svg" }
        Button { icon.source: "icons/next.svg" }
    }

    Slider {
        anchors.top: parent.top
        width: parent.width
        from: 0; to: 100
        value: AudioEngine.position
    }
}