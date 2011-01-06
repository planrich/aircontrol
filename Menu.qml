import Qt 4.7

Item {
    width: parent.width
    height: parent.height

    Button {
        id: newgame
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 50;
        text: qsTr("new_game");
        onClicked: window.newGame();
    }

    Button {
        id: settings
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: newgame.bottom
        anchors.margins: 5
        opacity: 0.2
        text: qsTr("settings");
    }

    Button {
        id: scores
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: settings.bottom
        anchors.margins: 5
        opacity: 0.2
        text: qsTr("scores");
    }
}
