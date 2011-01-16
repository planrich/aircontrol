#ifndef POLYGON_H
#define POLYGON_H

#include <QList>
#include <QPointF>
#include "src/vector2d.h"

class Polygon
{
public:
    Polygon(QList<Vector2D>);

    void offset(float,float);
    void translate(float,float);
    void rotate(float);
    bool intersect(Polygon p);

    void defineCenter();
    void defineAxes();
    int getAxisOverlap(Polygon p,Vector2D axis);

    QPointF _center;
    Vector2D _offset;
    Vector2D _axes[4];
    Vector2D _points[4];
    QPointF _rotatorPoint;
    Vector2D _edge;
    float _dotProduct;
};

#endif // POLYGON_H
