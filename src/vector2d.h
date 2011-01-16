#ifndef VECTOR2D_H
#define VECTOR2D_H

#include <QPointF>
#include <cmath>


class Vector2D
{
public:
    Vector2D() {
        x = 0;
        y = 0;
    }

    Vector2D(float x, float y) {
        this->x = x;
        this->y = y;
    }

    float projectPoint(Vector2D point) {
        float scalar = 0;
        float numerator = (point.x * x) + (point.x * x);
        float denominator = (x * x) + (y * y);
        float result = numerator / denominator;
        QPointF projected(result * x, result * y);
        scalar = (x * projected.x()) + (y * projected.y());

        return scalar;
    }

    inline float dotProduct(Vector2D v) {
        return (x * v.x) + (y * v.y);
    }

    inline Vector2D invert() {
        return Vector2D(-x,-y);
    }

    inline Vector2D normalRight() {
        return Vector2D(-y,x);
    }

    inline Vector2D normalize() {
        float length = sqrt((x * x) + (y * y));
        float tmpx,tmpy;

        if(x != 0) tmpx /= length;
        if(y != 0) tmpy /= length;

        return Vector2D(tmpx,tmpy);
    }

    float x;
    float y;
};

#endif // VECTOR2D_H
