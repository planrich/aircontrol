import Qt 4.7

Rectangle {
    id: container
    width: 500
    height: 350
    radius: 7
    anchors.centerIn: parent

    Image {
        id: icon
        source: "info"
        x: 5
        y: 5
    }

    Text {
        id: header
        font.pointSize: 24
        style: Text.Sunken
        font.bold: true
        color: "black"
        text: "Aircontrol";
        anchors.top: parent.top; anchors.topMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter;
    }

    Text {
        id: rev
        font.pointSize: 10
        style: Text.Sunken
        color: "black"
        text: "(" + window.buildState + " rev" + window.rev + ")";
        anchors.left: header.right; anchors.leftMargin: 15
        anchors.top: header.top; anchors.topMargin: 10
    }

    Text {
        id: desc
        font.pointSize: 14
        width: parent.width;
        color: "black"
        text: "In this game you try to land as many airplanes as possible without letting them crash. We hope you enjoy it!";
        anchors.top: header.bottom; anchors.topMargin: 25
        anchors.left: parent.left; anchors.leftMargin: 20
        wrapMode: Text.WordWrap
        anchors.horizontalCenter: parent.horizontalCenter;
    }

    Text {
        id: can
        font.pointSize: 13
        width: parent.width;
        color: "black"
        text: "You can submit a feature request or bug report at https://github.com/planrich/wefly or write me an e-mail Richard.Plangger@gmx.net";
        anchors.top: desc.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 20
        wrapMode: Text.WordWrap
        anchors.horizontalCenter: parent.horizontalCenter;
    }

    Text {
        id: programmerTitle
        font.pointSize: 13
        color: "black"
        text: "Gamedeveloper: Richard Plangger";
        anchors.top: can.bottom; anchors.topMargin: 45
        anchors.left: parent.left; anchors.leftMargin: 20;
    }

    Text {
        id: programmer
        font.pointSize: 10
        color: "black"
        text: "software engineer-in-training";
        anchors.bottom: programmerTitle.bottom;
        anchors.left: programmerTitle.right; anchors.leftMargin: 5;
        anchors.horizontalCenter: parent.horizontalCenter;
    }

    Text {
        id: desginerTitle
        font.pointSize: 13
        color: "black"
        text: "Graphic designer: Kelteseth";
        anchors.top: programmerTitle.bottom; anchors.topMargin: 5
        anchors.left: parent.left; anchors.leftMargin: 20;
    }

    Text {
        id: designer
        font.pointSize: 10
        color: "black"
        text: "aka Elias at Evolutionzone.net";
        anchors.bottom: desginerTitle.bottom;
        anchors.left: desginerTitle.right; anchors.leftMargin: 5;
        anchors.horizontalCenter: parent.horizontalCenter;
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "silver" }
        GradientStop { position: 1.0; color: "gray" }
    }

    states: [
        State {
            name: "show"
        }
    ]

    transitions: [
        Transition {
            to: "show"
            SequentialAnimation {
                PropertyAnimation {
                    target: container
                    property: "scale"
                    to: 1.1
                    duration: 175
                    easing: Easing.InOutQuad
                }
                PropertyAnimation {
                    target: container
                    property: "scale"
                    to: 1.0
                    duration: 175
                }
            }
        }
    ]

    function show() {
        container.state = "";
        container.state = "show";
    }
}
