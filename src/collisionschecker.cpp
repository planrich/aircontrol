#include "collisionschecker.h"
#include "src/geomfig.h"

CollisionsChecker::CollisionsChecker(QObject *parent) :
    QObject(parent)
{
}


bool CollisionsChecker::collidate(float x, float y, float w, float h, float rot, float x1, float y1, float w1, float h1, float rot1) {

    //check collision here
    geomfig plane1;
    plane1.angle = rot;
    plane1.scale = 1;
    plane1.prototype.push_back(new vec(x,y));
    plane1.prototype.push_back(new vec(x + w,y));
    plane1.prototype.push_back(new vec(x + w,y + h));
    plane1.prototype.push_back(new vec(x,y + h));


    geomfig plane2;
    plane2.angle = rot1;
    plane2.scale = 1;
    plane2.prototype.push_back(new vec(x1,y1));
    plane2.prototype.push_back(new vec(x1 + w1,y1));
    plane2.prototype.push_back(new vec(x1 + w1,y1 + h1));
    plane2.prototype.push_back(new vec(x1,y1 + h1));


    return false;
}
