import Qt 4.7

import "main.js" as Main

Rectangle {
    id: window
    width: 1252; height: 768
    focus: true; Keys.onEscapePressed: Qt.quit();

    property real speed: 1
    property int score: 0

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
            source: {
                if (window.speed == 1) {
                    "speed"
                } else {
                    "speed2"
                }
            }

            MouseArea {
                anchors.fill: parent
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

    Item {
        id: canvas
        anchors.top: toolbar.bottom
        width: parent.width; height: parent.height
    }

    Rectangle {
        id: pauseFog
        anchors.top: toolbar.bottom
        width: parent.width; height: parent.height
        color: "black"
        opacity: 0.8
        z: 1
    }

    states: [
        State {
            name: "menu"
        },
        State {
            name: "settings"
        },
        State {
            name: "play"
            StateChangeScript {
                script: {
                    Main.resume();
                }
            }
            PropertyChanges {
                target: window
                width: 1366
                height: 768
            }
            PropertyChanges {
                target: pauseFog
                opacity: 0
            }
        },
        State {
            name: "pause"
            StateChangeScript {
                script: {
                    Main.pause();
                }
            }
            PropertyChanges {
                target: window
                width: 1252
                height: 768
            }
            PropertyChanges {
                target: pauseFog
                opacity: 0.8
            }
        }
    ]

    transitions: [
        Transition { PropertyAnimation { properties: "width,height" } },
        Transition { PropertyAnimation { property: "opacity" } }
    ]



    function pause() {

    }
}
