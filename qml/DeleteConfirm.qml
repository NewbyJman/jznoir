Popup {
    id: confirmDialog
    width: 300; height: 150
    modal: true

    Column {
        anchors.centerIn: parent
        spacing: 20
        Text {
            text: "Delete this playlist?"
            color: "#d9d9d9"
        }
        Row {
            spacing: 10
            Button {
                text: "Yes"
                onClicked: {
                    playlistManager.deletePlaylist(playlistId);
                    confirmDialog.close();
                }
            }
            Button { 
                text: "No"
                onClicked: confirmDialog.close()
            }
        }
    }
}