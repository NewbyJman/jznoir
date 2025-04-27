import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    width: 300; height: 400
    modal: true

    ListView {
        anchors.fill: parent
        model: PlaylistModel {}
        delegate: ItemDelegate {
            width: parent.width
            height: 50
            Text {
                text: model.name
                color: "#d9d9d9"
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                PlaylistManager.addToPlaylist(model.id, selectedTracks);
                close();
            }
        }
    }
}