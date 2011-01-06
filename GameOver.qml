import Qt 4.7

Rectangle {
    anchors.centerIn: parent
    width: label.width + 50
    height: label.height + 50
    color: "gray"

    property bool test: false


    function setScore(score) {
        if (score >= 100) {
            label.text = "Well done! Your score: " + score
        } else if(score >= 200) {
            label.text = "Great! Your score: " + score
        } else {
            label.text = "Game over! Your score: " + score
        }
    }

    function gameOver() {
        test = true;
        setScore(1000);
    }

    Text {
        id: label
        anchors.top: parent.top; anchors.topMargin: 25
        anchors.left: parent.left; anchors.leftMargin: 25

        text: "asd"
        font.pointSize: 35
        style: Text.Outline
        styleColor: "black"
        color: "gold"
        z: parent.z + 1;
    }

    SequentialAnimation on scale {
        PropertyAnimation { to: 2; duration: 175; easing.type: Easing.InOutQuad; }
        PropertyAnimation { to: 1; duration: 175 }
    }
}
