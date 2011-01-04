import Qt 4.7
import "aircraft.js" as Logic
import "util.js" as Util

Image {
    id: aircraft
    source: {
        if (type == 0) {
            "qrc:/small_aircraft"
        }
    }
    fillMode: Image.PreserveAspectFit

    width: 52; height: 52
    smooth: true

    property int type: 0
    property bool crashed: false
    property bool landing: false
    property real speed: 2.0

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

    function pause() {
        moveanim.stop();
        moveanim.run = false;
    }

    onXChanged: {
        Logic.clamp(x,y);
    }

    onYChanged: {
        Logic.clamp(x,y);
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
        alwaysRunToEnd: false
        property bool run: true


        PropertyAnimation {
            id: xanim
            target: aircraft
            property: "x"
        }
        PropertyAnimation {
            id: yanim
            target: aircraft
            property: "y"
        }

        onCompleted: {
            if (run) {
                Logic.headForNextCheckpoint();
            }
        }
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
