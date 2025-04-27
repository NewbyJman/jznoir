import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GridView {
    cellWidth: 200; cellHeight: 240
    model: AlbumModel {}
    delegate: Rectangle {
        width: 180; height: 220
        color: "#2c2c2c"
        radius: 5

        Column {
            spacing: 8
            Image {
                width: 160; height: 160
                source: model.coverArt || "qrc:/logo.png"
            }
            Text {
                text: model.title
                color: "#d9d9d9"
                width: parent.width
                elide: Text.ElideRight
            }
            Text {
                text: model.artist
                color: "#d9d9d9"
                opacity: 0.7
                font.pixelSize: 12
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: stackView.push("qrc:/qml/AlbumDetail.qml", {album: model})
            onPressAndHold: albumMenu.popup()
        }
    }
}