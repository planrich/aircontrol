import Qt 4.7
//import Qt.labs.particles 1.0 not installed on the wetab?
import "util.js" as Util

Image {
    source: "airport" + type

    property int type: 1

    function canLand(type,x,y) {
        if (type == airstrip1.type) {
            if (airstrip1.canLand(x,y))
                return airstrip1;
        }

        return null;
    }


    //TODO make nice lights
    //Particles {

    //}

    //TODO convert to Item and remove color
    Rectangle {
        id: airstrip1
        color: "red"
        opacity: 0.2

        property int type: 0

        property int landrotation: 90;
        property int endX: parent.x + parent.width - 20;
        property int endY: parent.y + 20;


        function getCenterX() {
            return parent.x + x + width / 2;
        }

        function getCenterY() {
            return parent.y + y + height / 2;
        }

        function canLand(x,y) {
            if (Util.isin(x,y,airstrip1.x + airport.x,airstrip1.y + airport.y,airstrip1.width,airstrip1.height)) {
                return true;
            }
            return false;
        }

        x: {
            if (airport.type == 1) {
                10
            }
        }

        y: {
            if (airport.type == 1) {
                10
            }
        }

        width: 50
        height: 50
    }
}
