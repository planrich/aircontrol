.pragma library

/**
 * Check wether a b is in rectangle x,y,w,h
 */
function isin(a,b,x,y,w,h)
{
    return a >= x && b >= y && a <= (x + w) && b <= (y + h);
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

/**
 * Returns a random between a minimum and a maximum value
 */
function random(min, max) {
    var tmp = max - min;
    return Math.round(Math.random() * tmp + min);
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

