import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1 as Platform
import JZNoir 1.0

ScrollView {
    id: settingsScroll
    id: root
    contentWidth: parent.width
    clip: true

    Column {
        width: parent.width
        spacing: 20
        padding: 15

        // Title
        Text {
            text: "Settings"
            color: "#d9d9d9"
            font.pixelSize: 24
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            bottomPadding: 20
        }

        // Music Folders Section
        Rectangle {
            width: parent.width
            height: musicFoldersColumn.height + 30
            color: "transparent"
            border.color: "#444444"
            radius: 5

            Column {
                id: musicFoldersColumn
                width: parent.width - 20
                anchors.centerIn: parent
                spacing: 10
                topPadding: 15
                bottomPadding: 15

                Text {
                    text: "Music Libraries"
                    color: "#d9d9d9"
                    font.pixelSize: 16
                    bottomPadding: 10
                }

                Button {
                    id: addFolderBtn
                    text: "Add Music Folder"
                    width: parent.width
                    onClicked: folderDialog.open()

                    background: Rectangle {
                        color: parent.down ? "#7048a0" : "#d24fff"
                        radius: 3
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Repeater {
                    model: libraryManager.directories
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
                        color: index % 2 === 0 ? "#2c2c2c" : "#1a1a1a"
                        radius: 3

                        Text {
                            text: modelData
                            color: "#d9d9d9"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            elide: Text.ElideRight
                            width: parent.width - removeBtn.width - 20
                        }

                        Button {
                            id: removeBtn
                            width: 30
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            background: Rectangle {
                                color: "transparent"
                                Image {
                                    source: "../icons/trash.svg"
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                }
                            }
                            onClicked: libraryManager.removeDirectory(index)
                        }
                    }
                }
            }
        }

        // Scan Button
        Button {
            text: "Scan Libraries"
            width: parent.width
            enabled: libraryManager.directories.length > 0
            onClicked: libraryScanner.scanDirectories(libraryManager.directories)

            background: Rectangle {
                color: parent.down ? "#7048a0" : 
                      parent.enabled ? "#d24fff" : "#555555"
                radius: 3
            }

            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Progress Bar (hidden by default)
        ProgressBar {
            id: scanProgress
            width: parent.width
            visible: false
            value: 0
            background: Rectangle {
                color: "#1a1a1a"
                radius: 3
            }
            contentItem: Item {
                Rectangle {
                    width: scanProgress.visualPosition * parent.width
                    height: parent.height
                    radius: 3
                    color: "#d24fff"
                }
            }
        }
    }

    // Folder Dialog
    Platform.FileDialog {
        id: folderDialog
        title: "Select Music Folder"
        folder: Platform.StandardPaths.writableLocation(Platform.StandardPaths.MusicLocation)
        onAccepted: libraryManager.addDirectory(folder)
    }

    // Connections
    Connections {
        target: libraryScanner
        function onScanStarted() {
            scanProgress.visible = true
            scanProgress.value = 0
        }
        function onScanProgress(percent) {
            scanProgress.value = percent / 100
        }
        function onScanFinished() {
            scanProgress.visible = false
        }
    }
}