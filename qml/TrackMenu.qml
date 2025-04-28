MenuItem {
    text: "Play"
    onTriggered: audioEngine.playTrackAt(tracksView.currentIndex)
}

MenuItem {
    text: "Go to Album"
    onTriggered: navigationManager.goToAlbum(tracksView.currentTrack.album)
}

MenuItem {
    text: "Go to Artist"
    onTriggered: navigationManager.goToArtist(tracksView.currentTrack.artist)
}

MenuItem {
    text: "Add to Queue"
    onTriggered: queueManager.addTracksToQueue(tracksView.selectedTracks)
}

MenuItem {
    text: "Play Next"
    onTriggered: queueManager.addTracksNext(tracksView.selectedTracks)
}

MenuItem {
    text: "Add to Playlist"
    onTriggered: popupManager.openAddToPlaylist(tracksView.selectedTracks)
}
