import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    width: 300; height: 150
    modal: true

    Column {
        anchors.centerIn: parent
        spacing: 15

        TextField {
            id: playlistNameField
            width: parent.width
            placeholderText: "Playlist name"
        }

        Button {
            text: "Create"
            onClicked: {
                if (playlistNameField.text !== "") {
                    PlaylistManager.createPlaylist(playlistNameField.text);
                    close();
                }
            }
        }
    }
}