import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    color: "#2c2c2c"

    Text {
        text: "2 Songs"
        color: "#d9d9d9"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 40
        model: LibraryModel {}
        delegate: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"

            Row {
                spacing: 20
                anchors.fill: parent

                CheckBox { checked: false }

                Text { 
                    text: model.title 
                    color: "#d9d9d9"
                    width: parent.width * 0.25
                }

                Text { 
                    text: model.artist 
                    color: "#d9d9d9"
                    width: parent.width * 0.2
                }

                Text { 
                    text: model.album 
                    color: "#d9d9d9"
                    width: parent.width * 0.2
                }

                Text { 
                    text: model.duration 
                    color: "#d9d9d9"
                    width: parent.width * 0.1
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: AudioEngine.play(model.filePath)
                onPressAndHold: trackMenu.popup()
            }
        }
    }

    Menu {
        id: trackMenu
        MenuItem { text: "Play" }
        MenuItem { text: "Add to Queue" }
        MenuItem { text: "Go to Album" }
    }
}