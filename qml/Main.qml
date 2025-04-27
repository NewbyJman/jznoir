import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 800
    minimumWidth: 1000
    minimumHeight: 700
    title: "JZNoir"
    color: "#171717"

    // Accent colors
    property color accentColor: "#D24FFF"
    property color accentDark: "#7030A0"
    property color textColor: "#D9D9D9"
    property color bgColor: "#2C2C2C"

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
                onClicked: console.log("Back pressed")
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
                onClicked: console.log("Forward pressed")
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Tabs
            Repeater {
                model: ["Tracks", "Albums", "Artists", "Playlists", "Genres"]
                ToolButton {
                    text: modelData
                    font.pixelSize: 16
                    hoverEnabled: true
                    contentItem: Text {
                        text: parent.text
                        color: parent.hovered ? accentColor : textColor
                    }
                    onClicked: console.log("Switched to tab:", text)
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
                onClicked: console.log("Search opened")
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
                onClicked: console.log("Settings opened")
                hoverEnabled: true
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? accentColor : textColor
                }
            }

            // Window Controls
            ToolButton { text: "_"; onClicked: window.showMinimized() }
            ToolButton { text: "❐"; onClicked: window.visibility = "Maximized" }
            ToolButton { text: "✕"; onClicked: Qt.quit() }
        }
    }

    Rectangle {
        id: playerBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        color: bgColor
        border.color: accentDark
        border.width: 1

        // Add player bar UI here later
        Text {
            anchors.centerIn: parent
            text: "Player UI Placeholder"
            color: textColor
        }
    }

    Rectangle {
        id: mainBody
        anchors.top: tabBar.bottom
        anchors.bottom: playerBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#1D1D1D"
        // Add dynamic views here later
        Text {
            anchors.centerIn: parent
            text: "Main Body Placeholder"
            color: textColor
        }
    }
} 
