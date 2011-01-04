var aircraftBuilder = Qt.createComponent("Aircraft.qml");
var explosionBuilder = Qt.createComponent("Explosion.qml");

var planes = new Array();

var controlled = null;

function newGame() {

    menu.visible = false;

    scoreCounter.score = 0;
    scoreCounter.visible = true;

    controlled = null;
    var len = planes.length;
    while (len > 0) {
        var plane = planes.pop();
        plane.clearCheckpoints();
        plane.destroy();

        len = len - 1;
    }

    spawner.start();
    spawner2.start();
    crashchecker.start();
}

function crash(plane1,plane2) {

    explode(plane1, plane1.x + plane1.width / 2, plane1.y + plane1.height / 2);
    explode(plane2, plane2.x + plane2.width / 2, plane2.y + plane2.height / 2);

    menu.visible = true;

    scoreCounter.score = 0;
    scoreCounter.visible = true;

    for (var i = 0; i < planes.length; i++) {
        planes[i].pause();
    }

    spawner.stop();
    spawner2.stop();
}

function removePlane(plane) {
    //find index of plane CONSIDER: make this its own method
    var index = 0;
    for (var i = 0; i < planes.length;++i) {
        if (planes[i] == plane) {
            index = i;
            break;
        }
    }
    planes.splice(index,1);
}

function explode(plane,centerx,centery) {

    if (explosionBuilder.status != Component.Ready) {
        console.log("error loading explosion component");
        console.log(explosionBuilder.errorString());
        return;
    }

    var e = explosionBuilder.createObject(gameCanvas);
    e.x = centerx - e.width / 2;
    e.y = centery - e.height / 2;

    removePlane(plane);

    e.destroy(1600);
    plane.crashed = true;
}

function createAircraft(type)
{
    if(aircraftBuilder.status == Component.Ready){
         var plane = aircraftBuilder.createObject(gameCanvas);
         if(plane == null){
             console.log("error creating aircraft");
             console.log(component.errorString());
             return null;
         }
         plane.type = type;
         planes.push(plane);
         return plane;

     } else {
         console.log("error loading aircraft component");
         console.log(aircraftBuilder.errorString());
         return null;
     }
}

function tick(gamespeed)
{
    for (var i = 0; i <  planes.length; i ++)
    {
        var plane = planes[i];
        clampPlane(plane);
    }
}



function spawn(chance)
{
    if (Math.random() <= chance) {
        //create new plane
        var type = Math.floor(Math.random() * 1); //type 0 for now
        var plane = createAircraft(type);
        var side = Math.round(Math.random() * 3); //0 top 1 right 2 bottom 3 left
        placeAircraft(plane,side);
    }
}

function spawnat(x,y) {
    var type = Math.floor(Math.random() * 1); //type 0 for now
    var plane = createAircraft(type);
    plane.x = x;
    plane.y = y;
}

function placeAircraft(plane,side)
{
    var x = 0;
    var y = 0;
    var rot = 0;

    if (side == 0) {
        y = -plane.height;
        x = Math.round(25 + Math.random() * (window.width + 50));
        rot = random(180 - 45, 180 + 45);
    }
    else if (side == 1) {
        y = Math.round(25 + Math.random() * (window.height + 50));
        x = window.width;
        rot = random(270 - 45, 270 + 45);
    }
    else if (side == 2) {
        y = window.height;
        x = Math.round(25 + Math.random() * (window.width + 50));
        rot = random(-45, 45);
    }
    else if (side == 3) {
        y = Math.round(25 + Math.random() * (window.height + 50));
        x = -plane.width;
        rot = random(90 - 45, 90 + 45);
    }

    rot = rot % 360;

    plane.x = x;
    plane.y = y;
    plane.rotate(rot);
    plane.updateFlightPath(rot);

    console.debug("new aircraft ("+x+"/"+y+") at side " + side + " and rotation " + rot);
}

function random(min, max) {
    var tmp = max - min;
    return Math.random() * tmp + min;
}

/**
 * Get Quadrant where to spawn 0,1,2,3 bot,left,top,right
 */
function getQuadrant(deg)
{
    if (deg <= 45 || deg >= 315)
        return 0;
    else if (deg <= 135)
        return 1;
    else if (deg <= 225)
        return 2;
    else
        return 3;
}

/**
 * Start controlling an aircraft
 */
function control(x,y)
{
    controlled = null;

    for (var i = 0; i < planes.length; i ++)
    {
        var plane = planes[i];
        if (Util.isin(x,y,plane.x,plane.y,plane.width,plane.height)) {

            controlled = plane;
            controlled.startControl();

            return true;
        }
    }

    return false;
}

/**
 * Update the control. This is needed to generate checkpoints
 */
function updateControl(x,y)
{
    if (controlled != null)
        controlled.updateControl(x,y);
}


/**
 * Checks plane collisions
 */
function checkCollisions() {
    var len = planes.length;
    for (var i = 0; i < len; i++) {
        var p1 = planes[i];
        if (p1.landing) {
            continue;
        }

        for (var j = 0; j < len; j++) {
            //dont check self
            if (j == i) {
                continue;
            }

            var p2 = planes[j];

            if (p2.landing) {
                continue;
            }

            if (Util.distance(p1.getCenterX(),p1.getCenterY(),p2.getCenterX(),p2.getCenterY()) < 55) {
                crash(p1,p2);
                return;
            }
        }
    }
}


