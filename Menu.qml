import Qt 4.7

Item {
    width: parent.width
    height: parent.height

    Button {
        id: newgame
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 5
        text: "New Game"
        onClicked: window.newGame();
    }

    Button {
        id: scores
        anchors.right: parent.right
        anchors.top: newgame.bottom
        anchors.margins: 5
        opacity: 0.2
        text: "Scores"
    }

    Button {
        id: quit
        anchors.right: parent.right
        anchors.top: scores.bottom
        anchors.margins: 5
        text: "Quit"
        onClicked: Qt.quit();
    }
}
