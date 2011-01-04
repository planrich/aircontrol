import Qt 4.7

Rectangle {
    id: checkpoint
    color: "white"
    width: 3; height: 3
    radius: 1;
    opacity: 0.5

    property bool landing: false


    function getCenterX() {
        return x + width / 2;
    }

    function getCenterY() {
        return y + height / 2;
    }
}
