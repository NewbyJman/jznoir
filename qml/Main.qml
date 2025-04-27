import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import JZNoir 1.0
import "NavigationManager.js" as NavigationManager

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 800
    minimumWidth: 1000
    minimumHeight: 700
    title: "JZNoir"
    color: "#171717"

    // Color properties
    property color accentColor: "#D24FFF"
    property color accentDark: "#7030A0"
    property color textColor: "#D9D9D9"
    property color bgColor: "#2C2C2C"

    // Navigation Manager (simple forwarding)
    property alias navigationManager: NavigationManager

    // Global Shortcuts
    focus: true
    Keys.onPressed: (event) => {
        if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_Space) {
                // Ctrl+Space: Open Player UI (toggle minimized/maximized)
                window.visibility === Window.Maximized ? window.showNormal() : window.showMaximized();
                event.accepted = true;
            } else if (event.key === Qt.Key_S) {
                // Ctrl+S: Open Search
                searchView.open();
                event.accepted = true;
            } else if (event.key === Qt.Key_Q) {
                // Ctrl+Q: Open Queue
                queuePopup.open();
                event.accepted = true;
            } else if (event.key === Qt.Key_H) {
                // Ctrl+H: Move left tab
                if (stackView.currentIndex > 0) stackView.currentIndex--;
                event.accepted = true;
            } else if (event.key === Qt.Key_L) {
                // Ctrl+L: Move right tab
                if (stackView.currentIndex < 5) stackView.currentIndex++;
                event.accepted = true;
            } else if (event.key === Qt.Key_Return) {
                // Ctrl+Enter: Context Menu
                navigationManager.triggerContextMenu();
                event.accepted = true;
            }
        } else if (event.modifiers & Qt.ShiftModifier) {
            if (event.key === Qt.Key_H) {
                // Shift+H: Move left between columns
                navigationManager.moveColumnLeft();
                event.accepted = true;
            } else if (event.key === Qt.Key_L) {
                // Shift+L: Move right between columns
                navigationManager.moveColumnRight();
                event.accepted = true;
            }
        } else {
            switch (event.key) {
            case Qt.Key_Up:
                // Volume up
                audioEngine.volume = Math.min(audioEngine.volume + 5, 100);
                event.accepted = true;
                break;
            case Qt.Key_Down:
                // Volume down
                audioEngine.volume = Math.max(audioEngine.volume - 5, 0);
                event.accepted = true;
                break;
            case Qt.Key_Right:
                // Seek forward 5 sec
                audioEngine.seek(audioEngine.position + 5000);
                event.accepted = true;
                break;
            case Qt.Key_Left:
                // Seek back 5 sec
                audioEngine.seek(audioEngine.position - 5000);
                event.accepted = true;
                break;
            case Qt.Key_M:
                // Mute toggle
                audioEngine.toggleMute();
                event.accepted = true;
                break;
            case Qt.Key_Space:
                // Play/pause toggle
                audioEngine.togglePlayback();
                event.accepted = true;
                break;
            case Qt.Key_H:
            case Qt.Key_J:
            case Qt.Key_K:
            case Qt.Key_L:
            case Qt.Key_Return:
                // Navigation keys passed to active view
                if (navigationManager.handleNavigation(event))
                    event.accepted = true;
                break;
            case Qt.Key_Backspace:
                // Back navigation
                historyManager.goBack();
                event.accepted = true;
                break;
            default:
                break;
            }
        }
    }

    WheelHandler {
        id: wheelHandler
        target: window
        onWheel: (event) => {
            if (event.angleDelta.y > 0)
                audioEngine.volume = Math.min(audioEngine.volume + 5, 100);
            else if (event.angleDelta.y < 0)
                audioEngine.volume = Math.max(audioEngine.volume - 5, 0);
        }
    }

    // Tab model
    ListModel {
        id: tabModel
        ListElement { title: "Tracks"; viewSource: "TracksView.qml" }
        ListElement { title: "Albums"; viewSource: "AlbumsView.qml" }
        ListElement { title: "Artists"; viewSource: "ArtistsView.qml" }
        ListElement { title: "Playlists"; viewSource: "PlaylistsView.qml" }
        ListElement { title: "Genres"; viewSource: "GenresView.qml" }
        ListElement { title: "Settings"; viewSource: "SettingsView.qml" }
    }

    // Logo
    Image {
        id: logo
        source: "qrc:/assets/logo.png"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 15
        width: 40
        height: 40
        smooth: true
    }

    // Tab bar
    Rectangle {
        id: tabBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: bgColor

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            // Back Button
            ToolButton {
                text: "←"
                font.pixelSize: 20
                onClicked: historyManager.goBack()
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Forward Button
            ToolButton {
                text: "→"
                font.pixelSize: 20
                onClicked: historyManager.goForward()
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Tabs
            Repeater {
                model: tabModel
                ToolButton {
                    property string viewSource: model.viewSource
                    text: model.title
                    font.pixelSize: 16
                    hoverEnabled: true
                    contentItem: Text {
                        text: parent.text
                        color: parent.hovered ? accentColor : textColor
                    }
                    onClicked: {
                        if (stackView.currentItem) {
                            stackView.clear();
                        }
                        stackView.push(viewSource);

                        if (viewSource === "TracksView.qml") {
                            tracksModel.refresh();
                        }
                    }
                }
            }

            // Spacer
            Item {
                Layout.fillWidth: true
            }

            // Search Icon
            ToolButton {
                text: "🔍"
                font.pixelSize: 18
                onClicked: searchView.open()
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Settings Icon
            ToolButton {
                text: "⚙"
                font.pixelSize: 18
                onClicked: {
                    if (stackView.currentItem) stackView.clear();
                    stackView.push("SettingsView.qml");
                }
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Window Controls
            ToolButton { 
                text: "_" 
                onClicked: window.showMinimized() 
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }
            ToolButton { 
                text: "❐" 
                onClicked: window.visibility === Window.Maximized ? window.showNormal() : window.showMaximized()
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }
            ToolButton { 
                text: "✕" 
                onClicked: Qt.quit() 
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }
        }
    }

    // Main content area
    StackView {
        id: stackView
        anchors.top: tabBar.bottom
        anchors.bottom: playerBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        initialItem: TracksView {
            id: tracksView
            onTrackDoubleClicked: {
                queueManager.setQueue(tracksModel);
                audioEngine.playTrack(index);
            }
            onContextMenuRequested: trackContextMenu.show(index, position)
        }

        transitions: Transition {
            from: "*"
            to: "*"
            SequentialAnimation {
                // Fade out old item
                PropertyAnimation {
                    target: stackView.currentItem
                    properties: "opacity"
                    from: 1
                    to: 0
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
                // Fade in new item
                PropertyAnimation {
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

    }


    // Player Bar
    Rectangle {
        id: playerBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        color: bgColor
        border.color: accentDark
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            Image {
                id: nowPlayingArt
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                source: audioEngine.currentTrack.albumArt || "qrc:/assets/logo.png"
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: nowPlayingArt.width
                        height: nowPlayingArt.height
                        radius: 5
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: audioEngine.currentTrack.title || "No track selected"
                    color: textColor
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: audioEngine.currentTrack.artist || "Unknown Artist"
                    color: accentColor
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Slider {
                    id: progressBar
                    Layout.fillWidth: true
                    from: 0
                    to: audioEngine.duration
                    value: audioEngine.position
                    onMoved: audioEngine.seek(value)
                    background: Rectangle {
                        color: "#444444"
                        radius: 3
                        height: 4
                    }
                    handle: Rectangle {
                        visible: false
                    }
                }
            }

            RowLayout {
                spacing: 10

                ToolButton {
                    text: "🔀"
                    font.pixelSize: 18
                    onClicked: audioEngine.toggleShuffle()
                    ToolTip.text: "Shuffle"
                    ToolTip.visible: hovered
                }

                ToolButton {
                    text: "⏮"
                    font.pixelSize: 18
                    onClicked: audioEngine.previous()
                    ToolTip.text: "Previous"
                    ToolTip.visible: hovered
                }

                ToolButton {
                    id: playButton
                    text: audioEngine.playing ? "❚❚" : "▶"
                    font.pixelSize: 22
                    onClicked: audioEngine.togglePlayback()
                    ToolTip.text: audioEngine.playing ? "Pause" : "Play"
                    ToolTip.visible: hovered
                }

                ToolButton {
                    text: "⏭"
                    font.pixelSize: 18
                    onClicked: audioEngine.next()
                    ToolTip.text: "Next"
                    ToolTip.visible: hovered
                }

                ToolButton {
                    text: "🔁"
                    font.pixelSize: 18
                    onClicked: audioEngine.toggleRepeat()
                    ToolTip.text: "Repeat"
                    ToolTip.visible: hovered
                }
            }

            RowLayout {
                spacing: 5

                ToolButton {
                    text: audioEngine.muted ? "🔇" : "🔊"
                    font.pixelSize: 18
                    onClicked: audioEngine.toggleMute()
                }

                Slider {
                    id: volumeSlider
                    from: 0
                    to: 100
                    value: audioEngine.volume
                    onMoved: audioEngine.setVolume(value)
                    Layout.preferredWidth: 100
                    background: Rectangle {
                        color: "#444444"
                        radius: 3
                        height: 4
                    }
                    handle: Rectangle {
                        visible: false
                    }
                }
            }

            ToolButton {
                text: "🎵"
                font.pixelSize: 18
                onClicked: queuePopup.open()
                ToolTip.text: "Queue (" + queueManager.count + ")"
                ToolTip.visible: hovered
            }
        }
    }

    // Context Menu
    Menu {
        id: trackContextMenu
        property int currentIndex: -1

        MenuItem {
            text: "Play"
            onTriggered: {
                queueManager.setQueue(tracksModel);
                audioEngine.playTrack(trackContextMenu.currentIndex);
            }
        }
        MenuItem {
            text: "Play Next"
            onTriggered: queueManager.playNext(tracksModel.getTrack(trackContextMenu.currentIndex))
        }
        MenuItem {
            text: "Add to Queue"
            onTriggered: queueManager.addToQueue(tracksModel.getTrack(trackContextMenu.currentIndex))
        }
        MenuSeparator {}
        MenuItem {
            text: "Go to Artist"
            onTriggered: stackView.push("ArtistView.qml", {artist: tracksModel.getTrack(trackContextMenu.currentIndex).artist})
        }
        MenuItem {
            text: "Go to Album"
            onTriggered: stackView.push("AlbumView.qml", {album: tracksModel.getTrack(trackContextMenu.currentIndex).album})
        }
    }

    // Queue Popup
    QueuePopup {
        id: queuePopup
        x: window.width - width - 20
        y: window.height - height - 100
    }

    // Models
    TracksModel {
        id: tracksModel
    }

    SortProxyModel {
        id: sortedTracksModel
        sourceModel: tracksModel
    }
}