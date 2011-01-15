#ifndef COLLISIONRECTANGLE_H
#define COLLISIONRECTANGLE_H

#include <QObject>
#include <QVector2D>

class CollisionRectangle
{
public:
    CollisionRectangle(qreal,qreal,qreal,qreal,qreal);

    QVector2D upperLeft();
    QVector2D upperRight();
    QVector2D lowerLeft();
    QVector2D lowerRight();
    QVector2D rotate(QVector2D,QVector2D, qreal);

private:
    QVector2D _origin;

    qreal _x,_y,_w,_h;
    qreal _rotation;

};

#endif // COLLISIONRECTANGLE_H
