#ifndef COLLISIONSCHECKER_H
#define COLLISIONSCHECKER_H

#include <QObject>
#include "collisionrectangle.h"

class CollisionsChecker : public QObject
{
    Q_OBJECT
public:
    explicit CollisionsChecker(QObject *parent = 0);
    Q_INVOKABLE bool checkCollision
            (float x, float y, float w, float h, float r, float x1, float y1, float w1, float h1, float r1) {

        return collidate(CollisionRectangle(x,y,w,h,r),CollisionRectangle(x1,y1,w1,h1,r1));
    }

    Q_INVOKABLE bool collidate
            (float x, float y, float w, float h, float rot, float x1, float y1, float w1, float h1, float rot1) {

        CollisionRectangle *r1 = new CollisionRectangle(x,y,w,h);
        r1->rotate(rot);

        CollisionRectangle *r2 = new CollisionRectangle(x1,y1,w1,h1);
        r2->rotate(rot1);

        bool out = collidate(r1,r2);

        delete (r1);
        r1 = 0;
        delete (r2);
        r2 = 0;

        return out;
    }
    bool axisCollision(CollisionRectangle r1,CollisionRectangle r2, QVector2D axis);
    bool collidate(CollisionRectangle,CollisionRectangle);
    qreal genScalar(QVector2D, QVector2D);
};

#endif // COLLISIONSCHECKER_H
