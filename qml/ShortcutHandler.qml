import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    anchors.fill: parent
    focus: true

    property Item currentFocusItem: null

    // Main key handler
    Keys.onPressed: (event) => {
        // Playback controls
        if (event.key === Qt.Key_Space) AudioEngine.togglePlay();
        else if (event.key === Qt.Key_M) AudioEngine.toggleMute();
        else if (event.key === Qt.Key_Left) AudioEngine.seekRelative(-5000);
        else if (event.key === Qt.Key_Right) AudioEngine.seekRelative(5000);
        else if (event.key === Qt.Key_Up) AudioEngine.adjustVolume(+5);
        else if (event.key === Qt.Key_Down) AudioEngine.adjustVolume(-5);

        // Navigation (HJKL)
        else if (event.key === Qt.Key_H) navigateLeft();
        else if (event.key === Qt.Key_J) navigateDown();
        else if (event.key === Qt.Key_K) navigateUp();
        else if (event.key === Qt.Key_L) navigateRight();
        else if (event.key === Qt.Key_Backspace) stackView.pop();

        // UI controls (Ctrl combos)
        else if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_S) searchBox.forceActiveFocus();
            else if (event.key === Qt.Key_Q) queuePopup.open();
            else if (event.key === Qt.Key_Space) playerUi.visible = !playerUi.visible;
            else if (event.key === Qt.Key_H) tabBar.decrementCurrentIndex();
            else if (event.key === Qt.Key_L) tabBar.incrementCurrentIndex();
        }

        // Context menu (Ctrl+Enter)
        else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_Return) {
            if (currentFocusItem && currentFocusItem.contextMenu) {
                currentFocusItem.contextMenu.open();
            }
        }
    }

    // Navigation functions (fully implemented)
    function navigateLeft() {
        if (currentFocusItem && currentFocusItem.moveFocusLeft) {
            currentFocusItem.moveFocusLeft();
        } else if (stackView.depth > 1) {
            stackView.pop();
        }
    }

    function navigateRight() {
        if (currentFocusItem && currentFocusItem.moveFocusRight) {
            currentFocusItem.moveFocusRight();
        } else if (currentFocusItem && currentFocusItem.accept) {
            currentFocusItem.accept(); // e.g., open selected item
        }
    }

    function navigateUp() {
        if (currentFocusItem && currentFocusItem.moveFocusUp) {
            currentFocusItem.moveFocusUp();
        } else if (currentFocusItem instanceof ListView) {
            currentFocusItem.decrementCurrentIndex();
        }
    }

    function navigateDown() {
        if (currentFocusItem && currentFocusItem.moveFocusDown) {
            currentFocusItem.moveFocusDown();
        } else if (currentFocusItem instanceof ListView) {
            currentFocusItem.incrementCurrentIndex();
        }
    }

    // Initialize focus
    Component.onCompleted: {
        currentFocusItem = tracksView;
        forceActiveFocus();
    }
}