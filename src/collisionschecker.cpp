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
    plane1.prototype.push_back(new vec(-w / 2,-h / 2));
    plane1.prototype.push_back(new vec(-w / 2, h / 2));
    plane1.prototype.push_back(new vec(w / 2, h / 2));
    plane1.prototype.push_back(new vec(w / 2, -h / 2));
    plane1.pivot = vec(x,y);
    plane1.apply();

    geomfig plane2;
    plane2.angle = rot1;
    plane2.scale = 1;
    plane2.prototype.push_back(new vec(-w1 / 2,-h1 / 2));
    plane2.prototype.push_back(new vec(-w1 / 2, h1 / 2));
    plane2.prototype.push_back(new vec(w1 / 2, h1 / 2));
    plane2.prototype.push_back(new vec(w1 / 2, -h1 / 2));
    plane2.pivot = vec(x1,y1);
    plane2.apply();

    for (int i = 0; i < plane1.outline.size(); ++i) {
        if (collide(*plane1.outline[i],*plane1.outline[i + 1],*plane2.outline[i],*plane2.outline[i + 1]))
            return true;
    }

    return false;
}
