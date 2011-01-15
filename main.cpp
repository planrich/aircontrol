#include <QApplication>
#include <QGLWidget>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>
#include <QDeclarativeContext>
#include <QDeclarativeItem>
#include "src/random.h"
#include "src/collisionschecker.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Random>("com.planrich.aircontrol",1,0,"Random");
    qmlRegisterType<CollisionsChecker>("com.planrich.aircontrol",1,0,"CollisionsChecker");

    QDeclarativeEngine engine;
    QDeclarativeComponent mainComponent(&engine,QUrl("qrc:/Main.qml"));

    QObject * obj = mainComponent.create();

    QDeclarativeItem * item = qobject_cast<QDeclarativeItem*>(obj);

    QGraphicsScene scene;
    scene.setStickyFocus(true);
    scene.setItemIndexMethod(QGraphicsScene::NoIndex);
    QGraphicsView view(&scene);
    view.setOptimizationFlags(QGraphicsView::DontSavePainterState);
    view.setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    view.viewport()->setFocusPolicy(Qt::NoFocus);
    view.setFocusPolicy(Qt::StrongFocus);
    view.setWindowTitle(QObject::tr("Aircontrol"));
    view.setWindowFlags(Qt::FramelessWindowHint);
    view.setViewport(new QGLWidget);

    scene.addItem(item);

    view.setGeometry(0,0,item->width(),item->height());
    view.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    view.setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

    app.connect(&engine, SIGNAL(quit()),
                &view, SLOT(close()));
    view.show();

    return app.exec();
}
