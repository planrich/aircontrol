#include "random.h"
#include <QDateTime>
#include <stdlib.h>

Random::Random(QObject *parent) :
    QObject(parent)
{
    qsrand(QDateTime::currentDateTime().toTime_t());
}

/**
  * @returns a random number between 0-1
  */
float Random::random() const {
    return qrand() / (float) RAND_MAX;
}

/**
  * @param min
  * @param max
  * @returns a random number between min and max
  */
int Random::randomMinMax(int min, int max) const {
    return qRound((max - min) * random() + min);
}
