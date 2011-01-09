var informationWindow;

function info() {
    if (informationWindow == null) {
        var infoBuilder = Qt.createComponent("Info.qml");
        informationWindow = infoBuilder.createObject(infoWindow);
    } else {
        informationWindow.visible = !informationWindow.visible;
    }

    if (informationWindow.visible) {
        informationWindow.show();
    }
}
