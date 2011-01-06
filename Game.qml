import Qt 4.7
import "game.js" as Logic
import "util.js" as Util

Image {
        id: game
        source: {
            if (type == 1) {
                "background1"
            }
        }

        Component.onCompleted: {
            Logic.newGame();
            game.state = "play";
        }

        property int type: 1
        property int spawnInterval: 200
        property real spawnChance: .99

        Airport {
            id: airport
            type: game.type
            x: { if (type == 1) { 600 } }
            y: { if (type == 1) { 100 } }
        }

        Item {
             id: checkpointCanvas
        }

        Item {
            id: planeCanvas
        }

        MouseArea {
            anchors.fill: parent;
            acceptedButtons: Qt.LeftButton;
            onEntered: Logic.control(mouseX,mouseY);
            onPositionChanged: Logic.updateControl(mouseX,mouseY);
        }

        Timer {
            id: crashchecker
            interval: 125
            repeat: true
            onTriggered: Logic.checkCollisions();
        }

        Timer {
            id: spawner
            interval: spawnInterval
            repeat: true
            onTriggered: Logic.spawn(spawnChance);
        }

        states: [
            State {
                name: "play"
            },
            State {
                name: "pause"
            }
        ]

        function newGame() {
            Logic.newGame();
        }

        function removePlane(plane) {
            Logic.removePlane(plane);
        }

        function pause() {
            Logic.pause();
        }

        function resume() {
            Logic.resume();
        }
   }


