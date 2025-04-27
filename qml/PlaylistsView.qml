import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    model: PlaylistModel {}
    delegate: ItemDelegate {
        width: parent.width
        height: 60
        Row {
            spacing: 15
            Text {
                text: model.name
                color: "#d9d9d9"
                font.pixelSize: 16
            }
            Button {
                icon.source: "qrc:/icons/trash.svg"
                onClicked: deleteDialog.openFor(model.id)
            }
        }
    }

    FloatingButton {
        anchors.bottom: parent.bottom
        onClicked: newPlaylistDialog.open()
    }
}