import Qt 4.7

Rectangle {
    id: window
    width: 1366; height: 768
    focus: true; Keys.onEscapePressed: Qt.quit();

    property real gamespeed: 1
    property int score: 0
    property bool inGame: false


    SystemPalette { id: activePalette }

    Rectangle {
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 35;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "gray" }
            GradientStop { position: 1.0; color: "silver" }
        }
        z: 20

        Image {
            id: playpause
            anchors.left: toolbar.left
            anchors.top: toolbar.top
            anchors.margins: 5
            source: {
                if (window.state == "play") {
                    "pause"
                } else {
                    "play"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (window.state == "play") {
                        window.state = "pause"
                    } else {
                        window.state = "play"
                    }
                }
            }
        }

        Image {
            id: settings
            anchors.left: playpause.right
            anchors.top: toolbar.top
            anchors.margins: 5
            source: "settings"

            MouseArea {
                anchors.fill: parent
            }
        }

        Image {
            id: speed
            anchors.left: settings.right
            anchors.top: toolbar.top
            anchors.margins: 5
            source: "speed"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (inGame) {
                        if (gamespeed == 1) {
                            gamespeed = 3;
                            speed.source = "speed2";
                        } else {
                            gamespeed = 1;
                            speed.source = "speed";
                        }

                        game.speedChanged();
                    }
                }
            }
        }

        Image {
            id: scores
            anchors.left: speed.right
            anchors.top: toolbar.top
            anchors.margins: 5
            source: "scores"

            MouseArea {
                anchors.fill: parent
            }
        }

        Text {
            id: scoreText
            anchors.left: scores.right; anchors.leftMargin: 50
            anchors.top: toolbar.top
            text: window.score
            font.pointSize: 22
            style: Text.Raised
        }

        Text {
            anchors.left: scoreText.right; anchors.leftMargin: 10
            anchors.top: toolbar.top; anchors.topMargin: 7
            text: qsTr("landed")
            font.pointSize: 15
        }

        Image {
            anchors.right: toolbar.right
            anchors.top: toolbar.top
            anchors.margins: 5
            source: "quit"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit();
            }
        }
    }

    Game {
        id: game
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Rectangle {
        id: pauseFog
        anchors.top: toolbar.bottom
        width: parent.width; height: parent.height
        color: "black"
        opacity: 0.6
        z: 1
    }

    states: [
        State {
            name: "play"; when: inGame == true
            StateChangeScript {
                script: {
                    if (inGame) {
                        game.resume();
                    } else {
                        inGame = true;
                        game.newGame();
                    }
                }
            }
            PropertyChanges {
                target: pauseFog
                opacity: 0
            }
        },
        State {
            name: "pause"; when: inGame == false
            StateChangeScript {
                script: {
                    game.pause();
                }
            }
        }
    ]
}
