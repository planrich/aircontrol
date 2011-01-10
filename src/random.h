#ifndef RANDOM_H
#define RANDOM_H

#include <QObject>

class Random : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE explicit Random(QObject *parent = 0);
    Q_INVOKABLE float random() const;
    Q_INVOKABLE int randomMinMax(int,int) const;

};

#endif // RANDOM_H
