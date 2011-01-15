import Qt 4.7

Item {
    function canLand(type,x,y) {

        for (var i = 0; i < airstrips.length;++i) {
            if (airstrips[i].type == type && airstrips[i].canLand(x,y))
                return airstrips[i].generateParams();
        }
    }

    property variant airstrips: [
        airstrip1,
        airstrip2,
        airstrip3,
        airstrip4,
        airstrip5,
        airstrip6
    ]

    //big aircrafts
    Airstrip {
        id: airstrip1
        x: 360
        y: 277
        width: 60
        height: 60
        type: 1
        landingRotation: 90
        landingWidth: 320
    }

    //small aircrafts
    Airstrip {
        id: airstrip2
        x: 1210
        y: 280
        type: 0
        landingRotation: 270
        landingWidth: 320
    }

    //zeppelin 1
    Airstrip {
        id: airstrip3
        x: 647
        y: 62
        width: 100
        height: 100
        type: 2
        landingRotation: 0
        landingWidth: 0
        duration: 1000
    }

    //zeppelin 2
    Airstrip {
        id: airstrip4
        x: 1039
        y: 437
        width: 100
        height: 100
        type: 2
        landingRotation: 180
        landingWidth: 0
        duration: 1000
    }

    //heli 1
    Airstrip {
        id: airstrip5
        x: 947
        y: 34
        width: 60
        height: 60
        type: 3
        landingRotation: 0
        landingWidth: 0
        duration: 1000
    }

    //heli 2
    Airstrip {
        id: airstrip6
        x: 605
        y: 464
        width: 60
        height: 60
        type: 3
        landingRotation: 0
        landingWidth: 0
        duration: 1000
    }
}
