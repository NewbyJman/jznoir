import QtQuick 2.15
import QtQuick.Controls 2.15

SplitView {
    id: focusSplit
    orientation: Qt.Horizontal

    Keys.onPressed: handleNavigation(event)

    function handleNavigation(event) {
        if (NavigationManager.handleArtistFocusNavigation(event, albumList, focusSplit)) {
            event.accepted = true;
        }
    }


    // Left pane: Albums
    ListView {
        width: 300
        model: ArtistAlbumsModel {}
        delegate: ItemDelegate {
            text: model.name
            width: parent.width
            onClicked: songList.filterByAlbum(model.id)
        }
    }

    // Right pane: Songs
    ListView {
        id: songList
        model: ArtistSongsModel {}
        delegate: TrackDelegate {}
    }
}