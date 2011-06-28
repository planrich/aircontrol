import Qt 4.7
import Box2D 1.0
import "main.js" as Logic

Rectangle {
    id: window
    width: 1366; height: 768
    focus: true; Keys.onEscapePressed: Qt.quit();

    property real gamespeed: 1
    property int score: 0
    property bool inGame: false
    property bool displayInfo: false

    property string buildState: "alpha"
    property int rev: 3

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

        Item {
            id: playpause
            anchors.left: toolbar.left
            anchors.top: toolbar.top
            width: 35
            height: 35
            Image {
                anchors.centerIn: parent
                source: {
                    if (window.state == "play") {
                        "pause"
                    } else {
                        "play"
                    }
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

        /*Item {
            id: settings
            anchors.left: playpause.right
            anchors.top: toolbar.top
            width: 35
            height: 35
            Image {
                anchors.centerIn: parent
                source: "settings"
                opacity: 0.2
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {} //not yet
            }
        }*/

        Item {
            id: speed
            anchors.left: playpause.right
            anchors.top: toolbar.top
            width: 35
            height: 35
            Image {
                id: speedimg
                anchors.centerIn: parent
                source: "speed"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (inGame) {
                        if (gamespeed == 1) {
                            gamespeed = 3;
                            speedimg.source = "speed2";
                        } else {
                            gamespeed = 1;
                            speedimg.source = "speed";
                        }

                        world.speedChanged();
                    }
                }
            }
        }

        Item {
            id: scores
            anchors.left: speed.right
            anchors.top: toolbar.top
            width: 35
            height: 35
            Image {
                anchors.centerIn: parent
                source: "scores"
                opacity: 0.2
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {} //not yet
            }
        }

        Item {
            id: infoButton
            anchors.left: scores.right
            anchors.top: toolbar.top
            width: 35
            height: 35
            Image {
                anchors.centerIn: parent
                source: "info"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Logic.info();
                }
            }
        }

        Text {
            id: scoreText
            anchors.left: infoButton.right; anchors.leftMargin: 50
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

        Item {
            id:quitbutton
            width: 35
            height: 35
            anchors.right: toolbar.right
            anchors.top: toolbar.top

            Image {
                anchors.centerIn: parent
                source: "quit"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit();
            }
        }
    }

    Game {
        id: world
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Item {
        id: infoWindow
        z: 20
        anchors.centerIn: parent
    }

    Rectangle {
        id: pauseFog
        anchors.top: toolbar.bottom
        width: parent.width; height: parent.height
        color: "black"
        opacity: 0.5
        z: 1
    }

    states: [
        State {
            name: "play"; when: inGame == true
            StateChangeScript {
                script: {
                    if (inGame) {
                        world.resume();
                    } else {
                        inGame = true;
                        world.newGame();
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
                    world.pause();
                }
            }
        }
    ]
}
