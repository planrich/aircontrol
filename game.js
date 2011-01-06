var aircraftBuilder = Qt.createComponent("Aircraft.qml");
var explosionBuilder = Qt.createComponent("Explosion.qml");

var planes = new Array();

var controlled = null;

/**
 * Clear all existing resources and a new start game
 */
function newGame() {

    window.score = 0;

    controlled = null;
    var len = planes.length;
    while (len > 0) {
        var plane = planes.pop();
        plane.clearCheckpoints();
        plane.destroy();
        len = len - 1;
    }

    //crashchecker.start();
    spawner.start();
}

function pause() {
    for (var i = 0; i < planes.length; i++) {
        planes[i].pause();
    }

    spawner.stop();
}

function resume() {
    for (var i = 0; i < planes.length; i++) {
        planes[i].resume();
    }

    spawner.start();
}

/**
 * Generate a new aircraft and return it
 */
function createAircraft(type)
{
    if(aircraftBuilder.status == Component.Ready){
         var plane = aircraftBuilder.createObject(planeCanvas);
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

/**
 * Generate a new aircraft if the random number is lower than the chance
 */
function spawn(chance)
{
    if (Math.random() < chance) {
        var plane = createAircraft(Math.floor(Math.random() * 1)); //type 0 for now
        var obj = randomSpawnPoint(plane.width,plane.height);

        plane.x = obj[0];
        plane.y = obj[1];
        plane.rotate(obj[2]);
        plane.updateFlightPath(obj[2]);

        console.debug("new aircraft ("+obj[0]+"/"+obj[1]+") and rotation " + obj[2]);
    }
}

/**
 * Generate a new aircraft and place it according to the params
 */
function spawnat(x,y) {
    var type = Math.floor(Math.random() * 1); //type 0 for now
    var plane = createAircraft(type);
    plane.x = x;
    plane.y = y;
}

/**
 * Let two planes crash and animate an explosion on each
 */
function crash(plane1,plane2) {

    explode(plane1.x + plane1.width / 2, plane1.y + plane1.height / 2);
    explode(plane2.x + plane2.width / 2, plane2.y + plane2.height / 2);

    removePlane(plane1); plane1.crashed = true;
    removePlane(plane2); plane2.crashed = true;

    for (var i = 0; i < planes.length; i++) {
        planes[i].stop();
    }

    spawner.stop();
}

/**
 * Returns an index of a given plane. -1 if no was match found
 */
function indexOf(plane) {
    for (var i = 0; i < planes.length;++i) {
        if (planes[i] == plane) {
            return i;
        }
    }

    return -1;
}

/**
 * Removes a plane from the Array
 */
function removePlane(plane) {
    return planes.splice(indexOf(plane),1);
}

/**
 * Animates an explosion at the given params
 */
function explode(centerx,centery) {

    if (explosionBuilder.status != Component.Ready) {
        console.log("error loading explosion component");
        console.log(explosionBuilder.errorString());
        return;
    }

    var e = explosionBuilder.createObject(planeCanvas);
    e.x = centerx - e.width / 2;
    e.y = centery - e.height / 2;

    e.destroy(1600);
}

/**
 * Generates a random spawnpoint
 */
function randomSpawnPoint(w,h)
{
    var side = Math.floor(Math.random() * 4); //0 top 1 right 2 bottom 3 left

    var x = 0;
    var y = 0;
    var rot = 0;

    if (side == 0) {
        y = game.y - h;
        x = Math.round(25 + Math.random() * (window.width + 50));
        rot = Util.random(180 - 45, 180 + 45);
    }
    else if (side == 1) {
        y = Math.round(25 + Math.random() * (window.height + 50));
        x = window.width;
        rot = Util.random(270 - 45, 270 + 45);
    }
    else if (side == 2) {
        y = window.height - game.y;
        x = Math.round(25 + Math.random() * (window.width + 50));
        rot = Util.random(-45, 45);
    }
    else if (side == 3) {
        y = Math.round(25 + Math.random() * (window.height + 50));
        x = -w;
        rot = Util.random(90 - 45, 90 + 45);
    }

    rot = rot % 360;

    return [x,y,rot];
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


