import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property string text
    property bool active: false

    height: 40
    color: mouseArea.containsMouse ? "#444444" : "#2c2c2c"
    border.color: "#1a1a1a"
    border.width: 1

    Text {
        text: root.text
        color: "#d9d9d9"
        anchors.fill: parent
        anchors.leftMargin: 10
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }

    signal clicked()
}