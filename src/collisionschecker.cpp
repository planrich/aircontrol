#include "collisionschecker.h"
#include <QVector2D>
#include <QRectF>
#include <cmath>

CollisionsChecker::CollisionsChecker(QObject *parent) :
    QObject(parent)
{
}

bool CollisionsChecker::collidate(CollisionRectangle r1,CollisionRectangle r2) {

    QVector2D axis[4];
    axis[0] = r1.upperRight() - r1.upperLeft();
    axis[1] = r1.upperRight() - r1.lowerRight();
    axis[2] = r2.upperLeft() - r2.lowerLeft();
    axis[3] = r2.upperLeft() - r2.upperRight();

    for (int i = 0; i < axis->length(); ++i) {
        if (!axisCollision(r1,r2,axis[i]))
            return false;
    }

    return true;
}

bool CollisionsChecker::axisCollision(CollisionRectangle r1,CollisionRectangle r2, QVector2D axis) {

    qreal scalars1[4];
    scalars1[0] = genScalar(r1.upperLeft(),axis);
    scalars1[1] = genScalar(r1.upperRight(),axis);
    scalars1[2] = genScalar(r1.lowerLeft(),axis);
    scalars1[3] = genScalar(r1.lowerRight(),axis);


    qreal scalars2[4];
    scalars2[0] = genScalar(r2.upperLeft(),axis);
    scalars2[1] = genScalar(r2.upperRight(),axis);
    scalars2[2] = genScalar(r2.lowerLeft(),axis);
    scalars2[3] = genScalar(r2.lowerRight(),axis);


    qreal min1 = scalars1[0];
    for (int i = 0; i < 4; ++i) {
        if (scalars1[i] < min1) {
            min1 = scalars1[i];
        }
    }

    qreal max1 = scalars1[0];
    for (int i = 0; i < 4; ++i) {
        if (scalars1[i] > max1) {
            min1 = scalars1[i];
        }
    }

    qreal min2 = scalars2[0];
    for (int i = 0; i < 4; ++i) {
        if (scalars2[i] < min2) {
            min2 = scalars2[i];
        }
    }

    qreal max2 = scalars2[0];
    for (int i = 0; i < 4; ++i) {
        if (scalars2[i] > max2) {
            min1 = scalars2[i];
        }
    }

    if(min2 <= max1 && max2 >= min1) {
            return true;
    } else if(min1 <= max2 && max1 >= min2) {
            return true;
    }

    return false;
}

qreal CollisionsChecker::genScalar(QVector2D c, QVector2D a) {
    qreal num = c.x() * a.x() + c.y() * a.y();
    qreal den = a.x() * a.x() + a.y() * a.y();
    QVector2D v((num / den) * a.x(),(num / den) * a.y());
    return a.x() * v.x() + a.y() * v.y();
}
