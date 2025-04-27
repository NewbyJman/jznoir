pragma Singleton
import QtQuick 2.15

QtObject {
    readonly property color bgPrimary: "#2c2c2c"
    readonly property color bgSecondary: "#1a1a1a"
    readonly property color accent: "#d24fff"
    readonly property color text: "#d9d9d9"
    
    readonly property font defaultFont: Qt.font({
        family: "Segoe UI",
        pixelSize: 14
    })
}