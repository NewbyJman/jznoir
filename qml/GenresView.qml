import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    model: GenreModel {}
    delegate: ItemDelegate {
        width: parent.width
        height: 50
        Text {
            text: model.name
            color: "#d9d9d9"
            anchors.verticalCenter: parent.verticalCenter
        }
        onClicked: stackView.push("qrc:/qml/TracksView.qml", {genreFilter: model.name})
    }
}