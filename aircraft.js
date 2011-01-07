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
    var cp = checkpointBuilder.createObject(checkpointLayer);
    checkpoints.push(cp);
    cp.x = x;
    cp.y = y;

    return cp;
}

function updateControl(x,y) {

    //if the last checkpoint is a landing point we just return and do nothing at all
    if (checkpoints.length > 0 && checkpoints[checkpoints.length - 1].landing) {
        return;
    }

    var obj = game.canLand(aircraft.type,x,y);

    //if we have found an suitable airstrip we land
    if ( obj != null ) {
        var cp = createCheckpoint(obj[0], obj[1]);
        cp.landing = true;

        var rad = (obj[2] * (Math.PI / 180));
        var vector_x = Math.sin(rad) * obj[3];
        var vector_y = -Math.cos(rad) * obj[3];
        aircraft.landingParams = [obj[2], Math.round(obj[0] + vector_x), Math.round(obj[1] + vector_y), obj[4]];

    } else if (checkpoints.length > 0) { //we append if len is appropriet
        var last_cp = checkpoints[checkpoints.length - 1];

        if (Util.distance(x,y,last_cp.x,last_cp.y) > 20) {
            createCheckpoint(x,y);
        }
    } else { //first checkpoint we head for it
        if (Util.distance(x,y,aircraft.getCenterX(),aircraft.getCenterY()) > 25) {
            var cp = createCheckpoint(x,y);
        }
    }
}

function canLanding(x,y) {
    return airport.canLand(x,y);
}

function updateFlightPath(deg)
{
    checkpoint = null;

    var rad = (deg * (Math.PI / 180));

    var vector_x = Math.sin(rad);
    var vector_y = -Math.cos(rad);

    var tox = aircraft.x + aircraft.width / 2 + vector_x;
    var toy = aircraft.y + aircraft.height / 2 + vector_y;

    var fly_distance = Util.distance(aircraft.getCenterX(), aircraft.getCenterY(),tox,toy);

    flyto(tox - aircraft.width / 2,toy - aircraft.height / 2,fly_distance * 35);
}

function flyto(tox,toy,duration) {
    xanim.duration = duration / window.gamespeed;
    yanim.duration = duration / window.gamespeed;
    xanim.to = tox
    yanim.to = toy

    if (!moveanim.running) {
        moveanim.start();
    }
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
        var curr_cp = checkpoints[0];

        if (curr_cp.landing) {
            game.removePlane(aircraft);
            aircraft.landing = true;
            curr_cp.destroy();
            return;
        }

        if (curr_cp == checkpoint) {
            checkpoints.shift();
            curr_cp.destroy();
        }
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

    var rad = Util.calculateAngle(v_1_x,v_1_y,v_2_x,v_2_y);

    if (0 < v_2_x) {
        aircraft.rotate(360 - (rad * (180 / Math.PI)));
    } else {
        aircraft.rotate(rad * (180 / Math.PI));
    }

    var fly_distance = Util.distance(aircraft.getCenterX(), aircraft.getCenterY(),checkpoint.getCenterX(),checkpoint.getCenterY());

    flyto(checkpoint.getCenterX() - aircraft.width / 2, checkpoint.getCenterY() - aircraft.height / 2,fly_distance * 35);
}


function speedChanged() {
    moveanim.stop();
    if (checkpoint != null) {
        headfor(checkpoint);
    } else {
        updateFlightPath();
    }
}
