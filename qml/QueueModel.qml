import QtQuick 2.15

ListModel {
    dynamicRoles: true
    function moveItem(from, to) {
        move(from, to, 1)
    }
}