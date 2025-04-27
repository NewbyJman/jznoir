import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    color: "#2c2c2c"

    ListView {
        anchors.fill: parent
        model: SearchModel {}
        delegate: ItemDelegate {
            width: parent.width
            height: 50
            Row {
                spacing: 10
                Image {
                    width: 40; height: 40
                    source: model.coverArt || "qrc:/logo.png"
                }
                Text {
                    text: model.name
                    color: "#d9d9d9"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            onClicked: {
                if (model.type === "track") AudioEngine.play(model.filePath);
                else if (model.type === "artist") stackView.push("qrc:/qml/ArtistFocusView.qml", {artist: model.name});
            }
        }
    }
}