#include "collisionrectangle.h"
#include <cmath>

CollisionRectangle::CollisionRectangle(qreal x, qreal y, qreal w, qreal h, qreal rotation) :
        _origin(x + w / 2, y + h / 2),_x(x),_y(y),_w(w),_h(h),_rotation(rotation) {
}

QVector2D CollisionRectangle::rotate(QVector2D v,QVector2D o, qreal rot) {
    QVector2D out;
    out.setX(o.x() + (v.x() - o.x()) * cos(rot) - (v.y() - o.y()) * sin(rot));
    out.setY(o.y() + (v.y() - o.y()) * cos(rot) + (v.x() - o.x()) * sin(rot));
    return out;
}

QVector2D CollisionRectangle::upperLeft() {
    QVector2D v(_x,_y);
    v = rotate(v,v + _origin,_rotation);
    return v;
}

QVector2D CollisionRectangle::upperRight() {
    QVector2D v(_x + _w,_y);
    v = rotate(v,v + QVector2D(-_origin.x(), _origin.y()),_rotation);
    return v;
}

QVector2D CollisionRectangle::lowerLeft() {
    QVector2D v(_x,_y + _h);
    v = rotate(v,v + QVector2D(_origin.x(), -_origin.y()),_rotation);
    return v;
}

QVector2D CollisionRectangle::lowerRight() {
    QVector2D v(_x + _w,_y + _h);
    v = rotate(v,v + QVector2D(-_origin.x(), -_origin.y()),_rotation);
    return v;
}
