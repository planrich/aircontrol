#include "polygon.h"
#include <cmath>

Polygon::Polygon(QList<Vector2D> list)
{
    for (int i = 0; i < list.length();i++) {
        _points[i] = list.at(i);
    }

    defineCenter();
}

void Polygon::defineCenter() {
    float totalX = 0;
    float totalY = 0;

    float size = 4;

    for (int i = 0; i < size; ++i)
    {
        Vector2D v = _points[i];

        totalX += v.x;
        totalY += v.y;
    }

    _center.setX(totalX / size);
    _center.setY(totalY / size);
}

void Polygon::defineAxes() {

    int size = 4;
    for (int i = 0; i < size; ++i)
    {
        Vector2D v = _points[i];
        Vector2D v2 = _points[(i + 1) % size];
        // if there's another point available, define an edge.
        _edge.y = (v.x - v2.x);
        _edge.x = (v.y - v2.y);

        Vector2D potentialAxis = _edge.normalRight().normalize();
        _axes[i] = potentialAxis;
    }

    //TODO removeDuplicateAxes(_axes);
}

void Polygon::offset(float x, float y) {

    _offset.x = x;
    _offset.y = y;

    _center.setX(_center.x() - x);
    _center.setY(_center.y() - y);

    //rect -> 4 points
    for (int i = 0; i < 4; ++i)
    {
        Vector2D v = _points[i];
        v.x -= x;
        v.y -= y;
    }
}

void Polygon::translate(float x, float y) {
    _center.setX(_center.x() + x);
    _center.setY(_center.y() + y);

    //rect -> 4 points
    for (int i = 0; i < 4; ++i)
    {
        Vector2D v = _points[i];
        v.x += x;
        v.y += y;
    }
}

void Polygon::rotate(float radians) {
    int size = 4;

    for (int i = 0; i < size; ++i)
    {
        Vector2D v = _points[i];
        v.x -= _center.x();
        v.y -= _center.y();

        float rotx = (v.x * cos(radians)) - (v.y * sin(radians));
        float roty = (v.x * sin(radians)) + (v.y * cos(radians));

        v.x = rotx + _center.x();
        v.y = roty + _center.y();
    }

    // redefine the axes as rotation has surely altered them.
    defineAxes();
}

bool Polygon::intersect(Polygon p)
{
    int amount;
    Vector2D axis;

    for (int i = 0; i < 4; ++i)
    {
        axis = _axes[i];
        amount = getAxisOverlap(p, axis);

        // If the overlap is greater than zero, check to see if it's the
        // smallest value of the group.
        if(amount == 0)
            return false;
    }

    for (int i = 0; i < 4; ++i)
    {
        axis = p._axes[i];
        amount = getAxisOverlap(p, axis);

        // If the overlap is greater than zero, check to see if it's the
        // smallest value of the group.
        if(amount == 0)
            return false;
    }

    return true;
}

/**
 * Calls for all vertices represented on both this and the argument polygon
 * to be projected on a given axis.
 *
 * Returns the amount of overlap that exists.
 */
int Polygon::getAxisOverlap(Polygon p,Vector2D axis)
{
    int overlapAmount = 0;

    float theseScalars[4];

    for (int i = 0; i < 4; ++i) {
        theseScalars[i] = axis.projectPoint(_points[i]);
    }

    float thoseScalars[4];

    for (int i = 0; i < 4; ++i) {
        thoseScalars[i] = axis.projectPoint(p._points[i]);
    }

    float scalar;
    float thisMin = theseScalars[0];
    float thisMax = theseScalars[0];
    for (int i = 0; i < 4; ++i) {
        scalar = theseScalars[i];
        if (scalar < thisMin) thisMin = scalar;
        if (scalar > thisMax) thisMax = scalar;
    }

    float thatMin = thoseScalars[0];
    float thatMax = thoseScalars[0];
    for (int i = 0; i < 4; ++i) {
        scalar = thoseScalars[i];
        if (scalar < thatMin) thatMin = scalar;
        if (scalar > thatMax) thatMax = scalar;
    }

    // if there is any overlap between the objects
    // (min of tile rect is less than max of player rect)
    // then there is a collision present along the axis.
    if((thatMin <= thisMax) && (thatMax >= thisMax))
            overlapAmount = thisMax - thatMin;
    else if((thisMin <= thatMax) && (thisMax >= thatMax))
            overlapAmount = thatMax - thisMin;

    return overlapAmount;
}
