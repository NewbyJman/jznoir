import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    width: 300; height: 400
    modal: true

    ListView {
        id: queueList
        anchors.fill: parent
        model: QueueModel {}
        delegate: Rectangle {
            width: parent.width
            height: 50
            color: dragArea.containsDrag ? "#3c3c3c" : "transparent"

            Text {
                text: model.title
                color: "#d9d9d9"
                anchors.verticalCenter: parent.verticalCenter
            }

            DragHandler {
                id: dragHandler
                acceptedDevices: PointerDevice.GenericPointer
            }

            DropArea {
                id: dragArea
                anchors.fill: parent
                onEntered: (drag) => {
                    if (drag.source !== dragArea) {
                        queueList.model.move(drag.source.DelegateModel.itemsIndex, 
                                           dragArea.DelegateModel.itemsIndex, 1)
                    }
                }
            }
        }
    }
}