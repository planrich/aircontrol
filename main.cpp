#include <QApplication>
#include <QGLWidget>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;

    view.setWindowTitle("WeFly");
    //view.setWindowState(Qt::WindowMaximized);
    view.setWindowFlags(Qt::FramelessWindowHint);
    view.setSource(QUrl("qrc:/Wefly.qml"));
    // OpenGL rendering of QML may be slow on some platforms
    view.setViewport(new QGLWidget);
    app.connect(view.engine(), SIGNAL(quit()),
                &view, SLOT(close()));
    view.show();

    return app.exec();
}
