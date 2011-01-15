#include "collisionschecker.h"
#include "src/geomfig.h"

CollisionsChecker::CollisionsChecker(QObject *parent) :
    QObject(parent)
{
}


bool CollisionsChecker::collidate(float x, float y, float w, float h, float rot, float x1, float y1, float w1, float h1, float rot1) {

    //check collision here

    return false;
}
