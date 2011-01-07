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
    smooth: true

    property int type: 0
    property bool crashed: false
    property bool landing: false

    property real dragX: 0
    property real dragY: 0

    property variant landingParams: null;

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

    onXChanged: Logic.clamp(x,y);
    onYChanged: Logic.clamp(x,y);

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
                     aircraft.destroy(100);
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
                 RotationAnimation { target: aircraft; property: "rotation"; to: landingParams[0] }
             }
         }
     ]

}
