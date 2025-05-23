import QtQuick 2.15
import QtQuick.Controls 2.15

GridView {
    id: artistGrid
    cellWidth: 200; cellHeight: 240
    model: ArtistModel {}
    Keys.onPressed: handleNavigation(event)

    function handleNavigation(event) {
        if (NavigationManager.handleListNavigation(event, artistGrid)) {
            event.accepted = true;
        }
    }

    delegate: Rectangle {
        width: 180; height: 220
        color: color: GridView.isCurrentItem ? "#7048a0" : "#2c2c2c"
        radius: 5

        Column {
            spacing: 8
            Image {
                width: 160; height: 160
                source: model.coverArt || "qrc:/logo.png"
            }
            Text {
                text: model.name
                color: "#d9d9d9"
                width: parent.width
                elide: Text.ElideRight
            }
            Text {
                text: model.albumCount + " Album(s)"
                color: "#d9d9d9"
                opacity: 0.7
                font.pixelSize: 12
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: stackView.push("qrc:/qml/ArtistFocusView.qml", {artist: model.name})
        }
    }
}