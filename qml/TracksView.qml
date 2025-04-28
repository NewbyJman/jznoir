import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import JZNoir 1.0

Item {
    id: tracksView
    anchors.fill: parent

    property alias trackListView: trackListView

    SortProxyModel {
        id: sortedModel
        sourceModel: tracksModel
    }

    ListView {
        id: trackListView
        anchors.fill: parent
        model: sortedModel
        clip: true
        focus: true
        currentIndex: 0
        highlightFollowsCurrentItem: true
        boundsBehavior: Flickable.StopAtBounds
        keyNavigationWraps: true

        delegate: Item {
            id: trackDelegate
            width: parent.width
            height: 50

            Rectangle {
                id: bg
                anchors.fill: parent
                color: ListView.isCurrentItem ? "#444477" : "transparent"
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: model.title
                    color: "white"
                    font.pixelSize: 16
                    Layout.fillWidth: true
                }

                Text {
                    text: model.artist
                    color: "#CCCCCC"
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }

                Text {
                    text: model.album
                    color: "#999999"
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }

                Text {
                    text: model.duration
                    color: "#777777"
                    font.pixelSize: 14
                }
            }
        }
    }
}