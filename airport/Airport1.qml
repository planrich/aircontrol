import Qt 4.7

Image {
    source: "airport1"

    property int type: 0

    function canLand(type,x,y) {
        if (type == airstrip1.type && airstrip1.canLand(x,y)) {
                return airstrip1.generateParams();
        } else if (type == airstrip2.type && airstrip2.canLand(x,y)) {
                return airstrip2.generateParams();
        }

        return null;
    }

    Airstrip {
        id: airstrip1
        x: 10
        y: 17
        type: 0
        landingRotation: 90
        landingWidth: 320
    }

    Airstrip {
        id: airstrip2
        x: 10
        y: 72
        type: 0
        landingRotation: 90
        landingWidth: 320
    }
}
