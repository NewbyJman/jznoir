import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "transparent"
    
    property var currentDirectories: []
    signal directoriesChanged(var dirList)
    signal scanRequested(var dirList)
    
    ColumnLayout {
        width: parent.width
        
        // Current directories list
        ListView {
            id: dirListView
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            model: currentDirectories
            clip: true
            
            delegate: Rectangle {
                width: dirListView.width
                height: 40
                color: index % 2 === 0 ? "#2c2c2c" : "#1a1a1a"
                
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
                            source: "icons/trash.svg"
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                        }
                    }
                    
                    onClicked: {
                        currentDirectories.splice(index, 1)
                        directoriesChanged(currentDirectories)
                    }
                }
            }
        }
        
        // Add directory controls
        RowLayout {
            Layout.fillWidth: true
            
            Button {
                text: "Add Directory"
                Layout.fillWidth: true
                onClicked: folderDialog.open()
                
                background: Rectangle {
                    color: parent.down ? "#7048a0" : "#d24fff"
                    radius: 5
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                text: "Scan All"
                Layout.fillWidth: true
                enabled: currentDirectories.length > 0
                onClicked: root.scanRequested(currentDirectories)
                
                background: Rectangle {
                    color: parent.down ? "#7048a0" : 
                          parent.enabled ? "#d24fff" : "#555555"
                    radius: 5
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // Progress bar
        ProgressBar {
            id: scanProgress
            Layout.fillWidth: true
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
    
    // Folder selection dialog
    FileDialog {
        id: folderDialog
        title: "Select Music Directory"
        selectFolder: true
        folder: shortcuts.home
        
        onAccepted: {
            if (!currentDirectories.includes(folderDialog.folder)) {
                currentDirectories.push(folderDialog.folder)
                directoriesChanged(currentDirectories)
            }
        }
    }
    
    // Connect to scanner
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