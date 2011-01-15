#ifndef COLLISIONSCHECKER_H
#define COLLISIONSCHECKER_H

#include <QObject>

class CollisionsChecker : public QObject
{
    Q_OBJECT
public:
    explicit CollisionsChecker(QObject *parent = 0);

    Q_INVOKABLE bool collidate
            (float x, float y, float w, float h, float rot, float x1, float y1, float w1, float h1, float rot1);
};

#endif // COLLISIONSCHECKER_H
