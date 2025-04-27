import QtQuick 2.15
import QtQuick.Controls 2.15
import JZNoir 1.0

Popup {
    id: root
    width: 350
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    // [NEW] Background styling matching your theme
    background: Rectangle {
        color: "#2c2c2c"
        border.color: "#d24fff"
        border.width: 1
        radius: 5
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        anchors.margins: 5

        // [NEW] Header matching your UI style
        Text {
            text: "Current Queue"
            color: "#d9d9d9"
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 10
        }

        // [MODIFIED] Your existing ListView with enhancements
        ListView {
            id: queueList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: queueManager  // [CHANGED] Use existing queueManager
            currentIndex: audioEngine.currentTrackIndex
            spacing: 1

            delegate: Rectangle {
                id: delegateRoot
                width: queueList.width
                height: 50
                color: index === audioEngine.currentTrackIndex ? "#7048a0" : 
                      (dragArea.containsDrag ? "#3c3c3c" : 
                      (index % 2 === 0 ? "#2c2c2c" : "#1a1a1a"))

                // [MODIFIED] Your existing text with additional info
                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    // [NEW] Drag handle matching your icons
                    Text {
                        text: "☰"
                        color: "#d9d9d9"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 20

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.OpenHandCursor
                            onPressed: {
                                drag.source = delegateRoot
                                drag.hotSpot = Qt.point(width/2, height/2)
                            }
                        }
                    }

                    // [ENHANCED] Track info display
                    Column {
                        width: parent.width - 100
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: model.title || QFileInfo(model.filePath).baseName()
                            color: "#d9d9d9"
                            width: parent.width
                            elide: Text.ElideRight
                        }

                        Text {
                            text: (model.artist || "Unknown Artist") + " • " + 
                                  (model.album || "Unknown Album")
                            color: "#a0a0a0"
                            width: parent.width
                            elide: Text.ElideRight
                            font.pixelSize: 12
                        }
                    }

                    // [NEW] Duration display
                    Text {
                        text: QTime(0, 0).addSecs(model.duration).toString("mm:ss")
                        color: "#d9d9d9"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 12
                    }

                    // [NEW] Remove button matching your icon style
                    Button {
                        width: 30
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter
                        background: Rectangle {
                            color: "transparent"
                            Image {
                                source: "icons/trash.svg"
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                            }
                        }
                        onClicked: queueManager.remove(index)
                    }
                }

                // [MODIFIED] Your existing drag/drop with improved handling
                Drag.active: dragArea.drag.active
                Drag.source: delegateRoot
                Drag.hotSpot: Qt.point(10, 10)

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    hoverEnabled: true
                    drag.target: parent
                    onClicked: audioEngine.playTrack(index)
                    onDoubleClicked: audioEngine.playTrack(index)
                    drag.onActiveChanged: {
                        if (drag.active) {
                            drag.source = delegateRoot
                        }
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: {
                        if (drag.source && drag.source !== delegateRoot) {
                            drag.accept()
                        }
                    }
                    onPositionChanged: {
                        if (drag.source) {
                            queueManager.move(drag.source.DelegateModel.itemsIndex, 
                                            queueList.indexAt(drag.x, drag.y))
                        }
                    }
                }
            }

            // [NEW] Scrollbar matching your style
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                width: 8
                background: Rectangle { color: "#1a1a1a" }
                contentItem: Rectangle {
                    color: "#d24fff"
                    radius: 3
                }
            }
        }

        // [NEW] Footer controls matching your button style
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            spacing: 10

            Button {
                text: "Clear All"
                Layout.fillWidth: true
                onClicked: queueManager.clear()

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

            Button {
                text: "Close"
                Layout.fillWidth: true
                onClicked: root.close()

                background: Rectangle {
                    color: parent.down ? "#444444" : "#666666"
                    radius: 3
                }

                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}