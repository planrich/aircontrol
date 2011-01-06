import Qt 4.7
import "aircraft.js" as Logic
import "util.js" as Util

Image {
    id: aircraft
    source: {
        if (type == 0) {
            "small_aircraft"
        }
    }
    width: 52; height: 52
    smooth: true

    property int type: 0
    property bool crashed: false
    property bool landing: false
    property real speed: 1.0

    property real landingRotation: 0
    property real landingEndX: 0
    property real landingEndY: 0

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

    function updateFlightPath(angle) {
        Logic.updateFlightPath(angle);
    }

    function startControl() {
        Logic.startControl();
    }

    function updateControl(x,y) {
        Logic.updateControl(x,y);
    }

    function clearCheckpoints() {
        Logic.clearCheckpoints();
    }

    function createCheckpoint(x,y) {
        Logic.createCheckpoint(x,y);
    }

    function stop() {
        if (moveanim.running) {
            moveanim.stop();
        }
    }

    function pause() {
        moveanim.pause();
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

        NumberAnimation {
            id: xanim
            target: aircraft
            property: "x"
        }
        NumberAnimation {
            id: yanim
            target: aircraft
            property: "y"
        }

        onCompleted: { Logic.headForNextCheckpoint(); }
    }

    states: [
         State {
             name: "Crashed"; when: crashed == true
             StateChangeScript {
                 script: {
                     Logic.clearCheckpoints();
                     aircraft.destroy(100);
                 }
             }
         },
         State {
             name: "Landing"; when: landing == true
             StateChangeScript {
                 script: {
                     Logic.clearCheckpoints();
                     gameCanvas.removePlane(aircraft);
                     aircraft.destroy(100);
                     scoreCounter.score += 1;
                 }
             }
         }
     ]


}
