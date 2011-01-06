var checkpointBuilder = Qt.createComponent("Checkpoint.qml");
var checkpoints = new Array();
var checkpoint = null;

function startControl() {
    clearCheckpoints();
}

function clearCheckpoints() {
    //reset all checkpoints
    var l = checkpoints.length;
    for (var i = 0; i < l; i++) {
        var cp = checkpoints.pop();
        cp.destroy();
    }
}

function createCheckpoint(x,y) {
    var cp = checkpointBuilder.createObject(checkpointCanvas);
    cp.x = x;
    cp.y = y;
    checkpoints.push(cp);

    return cp;
}

function updateControl(x,y) {

    //if the last checkpoint is a landing point we just return and do nothing at all
    if (checkpoints.length > 0 && checkpoints[checkpoints.length - 1].landing) {
        return;
    }

    var airstrip = airport.canLand(aircraft.type,x,y);

    //if we have found an suitable airstrip we land
    if ( airstrip != null ) {
        var cp = createCheckpoint(airstrip.getCenterX(), airstrip.getCenterY());
        cp.landing = true;
    } else if (checkpoints.length > 0) { //we append if len is appropriet
        var last_cp = checkpoints[checkpoints.length - 1];

        if (distance(x,y,last_cp.x,last_cp.y) > aircraft.height / 2) {
            createCheckpoint(x,y);
        }
    } else { //first checkpoint we head for it
        if (distance(x,y,aircraft.x + aircraft.width / 2,aircraft.y + aircraft.height / 2) > aircraft.height / 2) {
            var cp = createCheckpoint(x,y);

            headfor(cp);
        }
    }
}

function canLanding(x,y) {
    return airport.canLand(x,y);
}

function updateFlightPath(deg)
{
    var rad = (deg * (Math.PI / 180));

    var vector_x = Math.sin(rad);
    var vector_y = -Math.cos(rad);

    var tox = aircraft.x + aircraft.width / 2 + vector_x;
    var toy = aircraft.y + aircraft.height / 2 + vector_y;

    var fly_distance = distance(aircraft.getCenterX(), aircraft.getCenterY(),tox,toy);

    xanim.duration = fly_distance * 25 * aircraft.speed;
    yanim.duration = fly_distance * 25 * aircraft.speed;

    xanim.to = tox - aircraft.width / 2;
    yanim.to = toy - aircraft.height / 2;

    moveanim.start();
}

function clamp(x,y)
{
    var w = aircraft.width;
    var h = aircraft.height;

    if (!Util.isin(x,y,window.x-w,window.y-h,window.width,window.height)) {

        moveanim.stop();

        if (x < -h)
        {
            x = window.width;
        }
        else if (y < -w)
        {
            y = window.height;
        }
        else if (x > window.width)
        {
            x = -w;
        }
        else if (y > window.height)
        {
            y = -h;
        }

        aircraft.x = x;
        aircraft.y = y;
        updateFlightPath(aircraft.rotation);
    }
}

function headForNextCheckpoint() {

    if (checkpoints.length > 0) {
        var curr_cp = checkpoints.shift();

        if (curr_cp.landing) {
            aircraft.landing = true;
            //TODO remove aircraft from list
        }

        curr_cp.destroy();
    }

    if (checkpoints.length > 0) {
        checkpoint = checkpoints[0];
        headfor(checkpoint);
    } else {
        updateFlightPath(aircraft.rotation);
    }
}

/**
 * Calculate distance and rotation to the next checkpoint. Then rotate and start animation
 */
function headfor(checkpoint)
{    
    var v_1_x = 0;
    var v_1_y = 1;

    var v_2_x = aircraft.getCenterX() - checkpoint.getCenterX();
    var v_2_y = aircraft.getCenterY() - checkpoint.getCenterY();

    var rad = calculateAngle(v_1_x,v_1_y,v_2_x,v_2_y);

    if (0 < v_2_x) {
        aircraft.rotate(360 - (rad * (180 / Math.PI)));
    } else {
        aircraft.rotate(rad * (180 / Math.PI));
    }

    var fly_distance = distance(aircraft.getCenterX(), aircraft.getCenterY(),checkpoint.getCenterX(),checkpoint.getCenterY());

    xanim.duration = fly_distance * 25 * aircraft.speed;
    yanim.duration = fly_distance * 25 * aircraft.speed;
    xanim.to = checkpoint.getCenterX() - aircraft.width / 2;
    yanim.to = checkpoint.getCenterY() - aircraft.height / 2;

    moveanim.start();
}

/**
 * Calculate and return angle (radians) between two 2D vectors (x1/y1) and (x2/y2)
 */
function calculateAngle(x1,y1,x2,y2) {
    var len1 = Math.sqrt(x1 * x1 + y1 * y1);
    var len2 = Math.sqrt(x2 * x2 + y2 * y2);

    x1 /= len1;
    y1 /= len1;

    x2 /= len2;
    y2 /= len2;

    return Math.acos(x1 * x2 + y1 * y2);
}

/**
 * Calculates the distance between two 2D vectors (x1/y1) and (x2/y2) using pytagoras
 */
function distance(x1,y1,x2,y2)
{
    var x = x1 - x2;
    var y = y1 - y2;

    return Math.sqrt(x*x + y*y);
}
