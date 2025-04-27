import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1 as Platform

ScrollView {
    Column {
        spacing: 20
        Button {
            text: "Add Music Folder"
            onClicked: folderDialog.open()
        }
        Repeater {
            model: Settings.folders
            delegate: FolderItem { path: modelData }
        }
    }

    FileDialog {
        id: folderDialog
        selectFolder: true
        onAccepted: Settings.addFolder(folder)
    }
}

Item {
    property string musicFolder: ""

    Component.onCompleted: {
        if (musicFolder === "") {
            musicFolder = Platform.StandardPaths.writableLocation(
                Platform.StandardPaths.MusicLocation
            )
            console.log("Default music folder set:", musicFolder)
        }
    }
}