Menu {
    MenuItem { text: "Play"; onTriggered: AudioEngine.play(model.filePath) }
    MenuItem { text: "Add to Queue" }
    MenuItem { text: "Go to Album" }
    MenuItem { text: "Go to Artist" }
}