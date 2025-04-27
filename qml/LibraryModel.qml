pragma Singleton
import QtQuick 2.15

QtObject {
    property list<Track> tracks
    property list<Album> albums
    property list<Artist> artists

    function reload() {
        tracks = [];
        LibraryScanner.scanDirectory(Settings.musicFolder);
    }

    Connections {
        target: LibraryScanner
        function onFilesFound(filePaths) {
            for (const path of filePaths) {
                const meta = MetadataReader.readMetadata(path);
                tracks.push({
                    title: meta.title || "Unknown",
                    artist: meta.artist || "Unknown",
                    album: meta.album || "Unknown",
                    filePath: path
                });
            }
        }
    }
}