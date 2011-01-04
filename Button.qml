import Qt 4.7

Rectangle {
    id: container

    property string text: "Button"

    signal clicked

    width: buttonLabel.width + 35; height: buttonLabel.height + 15
    border { width: 1; color: Qt.darker(activePalette.button) }
    smooth: true
    radius: 8

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: container.clicked();
    }

    Text {
        id: buttonLabel
        anchors.centerIn: container
        color: activePalette.buttonText
        text: container.text
        font.pointSize: 35
    }

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.pressed)
                    return activePalette.dark
                else
                    return activePalette.light
            }
        }
        GradientStop { position: 1.0; color: activePalette.button }
    }
}
