import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: genreList
    model: GenreModel {}
    Keys.onPressed: handleNavigation(event)

    function handleNavigation(event) {
        if (NavigationManager.handleListNavigation(event, genreList)) {
            event.accepted = true;
        }
    }

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