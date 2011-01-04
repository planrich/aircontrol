import Qt 4.7

import "wefly.js" as Logic
import "util.js" as Util


Rectangle {
    id: window
    width: 1252; height: 768

    focus: true;

    property int spawnInterval: 2700

    property real spawnchance: 0.2
    property real gamespeed: 1.0

    SystemPalette { id: activePalette }

    function newGame() {
        Logic.newGame();
    }

    Image {
        id: background
        source: "background1"
        z:0
    }

    Airport {
        id: airport
        type: 1
        x: 600
        y: 100
        z: 1
    }

    Item {
         id: checkpointCanvas
         z: 2;
    }

    Item {
        id: gameCanvas
        function removePlane(plane) {
            Logic.removePlane(plane);
        }


         z: 3
    }

    Menu {
        id: menu
        z: 20
    }

    Text {
        id: scoreCounter
        text: "Score: " + score
        font.pointSize: 20
        color: "silver"
        visible: false
        x: 10
        y: 5
        z: 4

        property int score: 0
    }

    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton;
        onEntered: Logic.control(mouseX,mouseY);
        onPositionChanged: Logic.updateControl(mouseX,mouseY);
    }

    Timer {
        id: spawner
        interval: spawnInterval
        repeat: true
        onTriggered: {
            Logic.spawn(spawnchance);
            spawnchance += 0.01;
        }
    }

    Timer {
        id: spawner2
        interval: 5000
        repeat: true
        onTriggered: {
            Logic.spawn(1);
        }
    }

    Timer {
        id: crashchecker
        interval: 125
        repeat: true
        onTriggered: Logic.checkCollisions();
    }
    Keys.onEscapePressed: Qt.quit();
}
