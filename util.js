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

