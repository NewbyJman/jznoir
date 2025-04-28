// ShortcutHandler.qml
import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    anchors.fill: parent
    focus: true

    // Properties injected by each view
    property Item currentFocusItem: null
    property Item secondaryFocusItem: null  // for multi-column (e.g., artist albums)
    property alias stackView: stackViewRef
    property alias searchBox: searchBoxRef
    property alias queuePopup: queuePopupRef
    property alias tabBar: tabBarRef
    property alias playerUi: playerUiRef

    // External references (provided by parent view)
    property Item stackViewRef: null
    property Item searchBoxRef: null
    property Item queuePopupRef: null
    property Item tabBarRef: null
    property Item playerUiRef: null

    // Main key handler
    Keys.onPressed: (event) => {
        const ctrl = event.modifiers & Qt.ControlModifier;
        const shift = event.modifiers & Qt.ShiftModifier;

        // --- Playback controls ---
        if (!ctrl && !shift) {
            if (event.key === Qt.Key_Space) AudioEngine.togglePlay();
            else if (event.key === Qt.Key_M) AudioEngine.toggleMute();
            else if (event.key === Qt.Key_Left) AudioEngine.seekRelative(-5000);
            else if (event.key === Qt.Key_Right) AudioEngine.seekRelative(5000);
            else if (event.key === Qt.Key_Up) AudioEngine.adjustVolume(+5);
            else if (event.key === Qt.Key_Down) AudioEngine.adjustVolume(-5);
        }

        // --- Navigation (h, j, k, l) ---
        if (!ctrl && !shift) {
            if (event.key === Qt.Key_H) navigateLeft();
            else if (event.key === Qt.Key_L) navigateRight();
            else if (event.key === Qt.Key_J) navigateDown();
            else if (event.key === Qt.Key_K) navigateUp();
        }

        // --- UI controls (Ctrl + keys) ---
        if (ctrl && !shift) {
            if (event.key === Qt.Key_S) {
                if (searchBox) searchBox.forceActiveFocus();
            }
            else if (event.key === Qt.Key_Q) {
                if (queuePopup) queuePopup.open();
            }
            else if (event.key === Qt.Key_Space) {
                if (playerUi) playerUi.visible = !playerUi.visible;
            }
            else if (event.key === Qt.Key_H) {
                if (tabBar) tabBar.decrementCurrentIndex();
            }
            else if (event.key === Qt.Key_L) {
                if (tabBar) tabBar.incrementCurrentIndex();
            }
        }

        // --- Column Switching (Shift + h / l) ---
        if (shift && !ctrl) {
            if (event.key === Qt.Key_H) {
                shiftFocusLeft();
            }
            else if (event.key === Qt.Key_L) {
                shiftFocusRight();
            }
        }

        // --- Play song (Enter) or open context menu (Ctrl + Enter) ---
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (ctrl) {
                if (currentFocusItem && currentFocusItem.contextMenu) {
                    currentFocusItem.contextMenu.open();
                }
            } else {
                if (currentFocusItem && currentFocusItem.accept) {
                    currentFocusItem.accept();
                }
            }
        }

        // --- Back navigation ---
        if (event.key === Qt.Key_Backspace) {
            if (stackView && stackView.depth > 1) {
                stackView.pop();
            }
        }
    }

    // Movement functions
    function navigateLeft() {
        if (currentFocusItem && currentFocusItem.moveFocusLeft) {
            currentFocusItem.moveFocusLeft();
        }
    }

    function navigateRight() {
        if (currentFocusItem && currentFocusItem.moveFocusRight) {
            currentFocusItem.moveFocusRight();
        }
    }

    function navigateUp() {
        if (currentFocusItem && currentFocusItem.moveFocusUp) {
            currentFocusItem.moveFocusUp();
        } else if (currentFocusItem && currentFocusItem instanceof ListView) {
            currentFocusItem.decrementCurrentIndex();
        } else if (currentFocusItem && currentFocusItem instanceof GridView) {
            currentFocusItem.decrementCurrentIndex();
        }
    }

    function navigateDown() {
        if (currentFocusItem && currentFocusItem.moveFocusDown) {
            currentFocusItem.moveFocusDown();
        } else if (currentFocusItem && currentFocusItem instanceof ListView) {
            currentFocusItem.incrementCurrentIndex();
        } else if (currentFocusItem && currentFocusItem instanceof GridView) {
            currentFocusItem.incrementCurrentIndex();
        }
    }

    // Column switching (Shift + h / l)
    function shiftFocusLeft() {
        if (secondaryFocusItem) {
            currentFocusItem = secondaryFocusItem;
            secondaryFocusItem = null;
            currentFocusItem.forceActiveFocus();
        }
    }

    function shiftFocusRight() {
        if (secondaryFocusItem) {
            currentFocusItem = secondaryFocusItem;
            secondaryFocusItem = null;
            currentFocusItem.forceActiveFocus();
        }
    }

    // Setup focus (optional per view)
    Component.onCompleted: {
        forceActiveFocus();
    }
}