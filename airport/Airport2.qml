import Qt 4.7

Image {
    source: "airport2"

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
        y: 138
        type: 0
        landingRotation: 90
        landingWidth: 300
    }

    Airstrip {
        id: airstrip2
        x: 88
        y: 290
        type: 0
        landingRotation: 0
        landingWidth: 280
    }
}
