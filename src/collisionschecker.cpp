#include "collisionschecker.h"
#include "src/polygon.h"
#include "src/vector2d.h"
#include <QList>

CollisionsChecker::CollisionsChecker(QObject *parent) :
    QObject(parent)
{
}

bool CollisionsChecker::collidate(float x, float y, float w, float h, float rot, float x1, float y1, float w1, float h1, float rot1) {

    QList<Vector2D> points;
    points.append(Vector2D(0, 0));
    points.append(Vector2D(w, 0));
    points.append(Vector2D(w, h));
    points.append(Vector2D(0, h));

    Polygon * plane1 = new Polygon(points);
    plane1->offset(plane1->_center.x(),plane1->_center.y());
    plane1->translate(x,y);
    plane1->rotate(rot);

    QList<Vector2D> points1;
    points1.append(Vector2D(0,  0));
    points1.append(Vector2D(w1, 0));
    points1.append(Vector2D(w1, h1));
    points1.append(Vector2D(0,  h1));

    Polygon * plane2 = new Polygon(points1);
    plane2->offset(plane2->_center.x(),plane2->_center.y());
    plane2->translate(x1,y1);
    plane2->rotate(rot1);

    bool intersect = false;
    if (plane1->intersect(*plane2) || plane2->intersect(*plane1)) {
        intersect = true;
    }

    delete plane1; plane1 = 0;
    delete plane2; plane2 = 0;

    return intersect;
}
