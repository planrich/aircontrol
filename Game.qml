import Qt 4.7
import com.planrich.aircontrol 1.0
import "game.js" as Logic
import "util.js" as Util

Image {
    source: {
        if (type == 1) {
            "background1"
        }
    }

    Component.onCompleted: Logic.createAirport();

    property int type: 1
    property int maxAircrafts: 3
    property int spawnInterval: 3800
    property real spawnChance: .25
    property int spawnIntervalMod: 0


    Item {
        id: airportLayer
    }

    Item {
         id: checkpointLayer
    }

    Item {
        id: planeLayer
    }

    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton;
        onEntered: Logic.control(mouseX,mouseY);
        onPositionChanged: Logic.updateControl(mouseX,mouseY);
    }

    Random {
        id: rand
    }

    Timer {
        id: crashchecker
        interval: 125
        repeat: true
        onTriggered: Logic.checkCollisions();
    }

    Timer {
        id: spawner
        interval: (spawnInterval - spawnIntervalMod) / window.gamespeed
        repeat: true
        onTriggered: Logic.spawn(spawnChance);
    }

    states: [
        State {
            name: "play"; when: window.inGame == true
        },
        State {
            name: "pause"; when: window.inGame == false
        }
    ]

    function speedChanged() {
        Logic.speedChanged();
    }

    function canLand(type,x,y) {
        return Logic.canLand(type,x,y);
    }

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

    function random() {
        return rand.random();
    }

    function randomMinMax(min,max) {
        return rand.randomMinMax(min,max);
    }
 }
