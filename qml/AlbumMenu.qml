import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    MenuItem { 
        text: "Play Album" 
        onTriggered: AudioEngine.playAlbum(model.id)
    }
    MenuItem { 
        text: "Add to Queue" 
        onTriggered: AudioEngine.queueAlbum(model.id)
    }
    MenuItem { 
        text: "Go to Artist" 
        onTriggered: stackView.push("qrc:/qml/ArtistFocusView.qml", {artist: model.artist})
    }
}