import QtQuick 2.15
import QtQuick.Controls 2.15
import JZNoir 1.0

Rectangle {
    id: root
    color: "transparent"

    property alias model: listView.model
    property int currentIndex: -1

    signal trackSelected(int index)
    signal trackDoubleClicked(int index)
    signal contextMenuRequested(int index, point position)

    Keys.onPressed: handleNavigation(event)
    function handleNavigation(event) {
        if (NavigationManager.handleListNavigation(event, listView)) {
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header row
        RowLayout {
            Layout.fillWidth: true
            height: 40
            spacing: 0

            Item { width: 40 } // Album art
            Item { width: 30 } // Checkbox

            // [MODIFIED] Header buttons with proper sorting
            HeaderButton {
                text: "Title"
                width: 200
                onClicked: listView.model.sortByColumn(TracksModel.SortTitle)
            }
            HeaderButton {
                text: "Artist" 
                width: 150
                onClicked: listView.model.sortByColumn(TracksModel.SortArtist)
            }
            HeaderButton {
                text: "Album"
                width: 150
                onClicked: listView.model.sortByColumn(TracksModel.SortAlbum)
            }
            HeaderButton {
                text: "Year"
                width: 60
                onClicked: listView.model.sortByColumn(TracksModel.SortYear)
            }
            HeaderButton {
                text: "Length"
                width: 80
                onClicked: listView.model.sortByColumn(TracksModel.SortDuration)
            }
            HeaderButton {
                text: "Plays"
                width: 60
                onClicked: listView.model.sortByColumn(TracksModel.SortPlayCount)
            }
            Item { Layout.fillWidth: true }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            currentIndex: root.currentIndex
            boundsBehavior: Flickable.StopAtBounds

            delegate: TrackDelegate {
                width: listView.width
                isCurrent: ListView.isCurrentItem
                onClicked: {
                    listView.currentIndex = index
                    root.trackSelected(index)
                }
                onDoubleClicked: root.trackDoubleClicked(index)
                onContextMenuRequested: root.contextMenuRequested(index, position)
                
                // [NEW] Context menu implementation
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.RightButton) {
                            contextMenu.popup()
                        } else {
                            parent.clicked()
                        }
                    }
                    onDoubleClicked: parent.doubleClicked()

                    Menu {
                        id: contextMenu
                        MenuItem {
                            text: "Play"
                            onTriggered: audioEngine.playTrack(model.filePath)
                        }
                        MenuItem {
                            text: "Add to Queue"
                            onTriggered: queueManager.addToQueue(model.filePath)
                        }
                        MenuSeparator {}
                        MenuItem {
                            text: "Go to Artist"
                            onTriggered: stackView.push("ArtistView.qml", {artist: model.artist})
                        }
                        MenuItem {
                            text: "Go to Album"
                            onTriggered: stackView.push("AlbumView.qml", {album: model.album})
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                width: 8
            }
        }

        // Status bar
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#1a1a1a"
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                color: "#d9d9d9"
                text: listView.count + " tracks"
            }
        }
    }
}