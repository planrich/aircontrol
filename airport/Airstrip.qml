import Qt 4.7
import "../util.js" as Util

Rectangle {

    color: "green"

    id: component
    width: 40
    height: 40

    property int type: 0
    property int landingRotation: 0
    property int landingWidth: 100
    property int duration: 6000

    function getX() {
        return parent.x + x;
    }

    function getY() {
        return parent.y + y;
    }

    function getCenterX() {
        return getX() + width / 2;
    }

    function getCenterY() {
        return getY() + height / 2;
    }

    function canLand(x,y) {
        return Util.isin(x,y,getX(),getY(),component.width,component.height);
    }

    function generateParams() {
        return [component.getCenterX(), component.getCenterY(), component.landingRotation, component.landingWidth, component.duration];
    }
}
