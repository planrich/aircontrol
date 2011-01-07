import Qt 4.7

Image {
    x: 400
    y: 100
    source: "airport1"

    property int type: 0

    function canLand(type,x,y) {
        if (type == airstrip1.type) {
            if (airstrip1.canLand(x,y))
                return airstrip1.generateParams();
        } else if (type == airstrip2.type) {
            if (airstrip2.canLand(x,y))
                return airstrip2.generateParams();
        }

        return null;
    }

    Airstrip {
        id: airstrip1
        x: 10
        y: 10
        type: 0
        landingRotation: 90
        landingWidth: 350
    }

    Airstrip {
        id: airstrip2
        x: 70
        y: 70
        type: 1
        landingRotation: 90
        landingWidth: 330
    }
}
