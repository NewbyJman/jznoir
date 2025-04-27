var activeView = null;

function setActiveView(view) {
    activeView = view;
}

function handleNavigation(event) {
    if (activeView && activeView.handleNavigation) {
        return activeView.handleNavigation(event);
    }
    return false;
}

function triggerContextMenu() {
    if (activeView && activeView.triggerContextMenu) {
        activeView.triggerContextMenu();
    }
}

function moveColumnLeft() {
    if (activeView && activeView.moveColumnLeft) {
        activeView.moveColumnLeft();
    }
}

function moveColumnRight() {
    if (activeView && activeView.moveColumnRight) {
        activeView.moveColumnRight();
    }
}
