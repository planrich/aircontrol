import Qt 4.7
import Box2D 1.0
import com.planrich.aircontrol 1.0
import "game.js" as Logic
import "util.js" as Util

Image {
    id: game;

    World {
        id: world
        anchors.fill: parent

        gravity: Qt.point(0, 0)

        DebugDraw {
                    id: debugDraw
                    world: world
                    anchors.fill: world
                    opacity: 0.75
                    visible: true
                }

        Item {
            id: airportLayer
        }

        Item {
             id: checkpointLayer
        }

        Item {
            id: planeLayer
        }
    }

    source: {
        if (type == 1) {
            "background1"
        }
    }

    Component.onCompleted: {
        Logic.createAirport();
        Logic.test();
    }

    property int type: 1
    property int maxAircrafts: 3
    property int spawnInterval: 3800
    property real spawnChance: .25
    property int spawnIntervalMod: 0

    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton;
        onPositionChanged: Logic.updateControl(mouseX,mouseY);
    }

    Random {
        id: rand
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

    function takeControl(plane) {
        console.log("control here");
    }

    Component {
        id: aircraftComponent
        Body {
            id: aircraft;
            sleepingAllowed: false;
            width: img.width;
            height: img.height;

            property int type: 0;
            property bool crashed: false;
            property bool landing: false;

            fixtures: Box {
                anchors.fill: parent
                density: 1;
                friction: 0.3;
                restitution: 0.5;

                onBeginContact: {
                    Logic.explode()
                }
            }



            Image {
                id: img
                width: 52
                height: 52
                source: {
                    if (parent.type == 0) {
                        "small_aircraft"
                    } else if (parent.type == 1) {
                        "big_aircraft"
                    } else if (parent.type == 2) {
                        "zeppelin"
                    } else if (parent.type == 3) {
                        "helicopter"
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        console.log("test");
                    }
                }
            }





            function getSpeed() {
                if (type == 1) { return 35; }
                if (type == 2) { return 75; }
                if (type == 3) { return 65; }
                else { return 45; }//default small_aircraft
            }

            function getCenterX() {
                return x + width / 2;
            }

            function getCenterY() {
                return y + height / 2;
            }

            function rotate(degree) {
                rotanim.to = degree;
                rotanim.start();
            }

            function clearCheckpoints() {
                Logic.clearCheckpoints();
            }

            function updateFlightPath(angle) {
                Logic.updateFlightPath(angle);
            }

            function startControl() {
                Logic.startControl();
            }

            function updateControl(x,y) {
                Logic.updateControl(x,y);
            }

            function pause() {
                moveanim.pause();
            }

            function speedChanged() {
                Logic.speedChanged();
            }

            function resume() {
                if (moveanim.paused) {
                    moveanim.resume();
                } else {
                    Logic.updateFlightPath(aircraft.rotation);
                }
            }

            RotationAnimation {
                id: rotanim
                target: aircraft
                property: "rotation"
                duration: 100
                direction: RotationAnimation.Shortest
            }

            ParallelAnimation {
                id: moveanim
                onCompleted: {
                    if (landing != true) {
                        Logic.headForNextCheckpoint();
                    }
                }

               PropertyAnimation {
                    id: xanim
                    alwaysRunToEnd: false
                    target: aircraft
                    property: "x"
                }
                PropertyAnimation {
                    id: yanim
                    alwaysRunToEnd: false
                    target: aircraft
                    property: "y"
                }
            }



            states: [
                 State {
                     name: "Crashed"; when: crashed == true
                     StateChangeScript {
                         script: {
                             Logic.clearCheckpoints();
                         }
                     }
                 },
                 State {
                     name: "landing"; when: landing == true
                     StateChangeScript {
                         script: {
                             Logic.clearCheckpoints();
                             moveanim.stop();
                             window.score += 1;
                             aircraft.destroy(landingParams[3] + 500);
                         }
                     }
                 }
             ]

            transitions: [
                 Transition {
                     to: "landing"
                     ParallelAnimation {
                         NumberAnimation { target: aircraft; property: "scale"; to: 0.5; duration: 500 }
                         NumberAnimation { target: aircraft; property: "x"; to: landingParams[1] - aircraft.width / 2; duration: landingParams[3] }
                         NumberAnimation { target: aircraft; property: "y"; to: landingParams[2] - aircraft.height / 2; duration: landingParams[3] }
                         RotationAnimation { target: aircraft; property: "rotation"; to: landingParams[0]; direction: RotationAnimation.Shortest }
                     }
                 }
             ]
        }
    }
 }
