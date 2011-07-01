#-------------------------------------------------
#
# Project created by QtCreator 2010-12-27T19:47:22
#
#-------------------------------------------------

QT += core gui declarative opengl

TARGET = aircontrol
target.path = /usr/bin
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

desktop.files += aircontrol.desktop
desktop.path = /usr/share/applications

icon.files += img/aircontrol.png
icon.path = /usr/share/icons/hicolor/192x192/apps

INSTALLS += target desktop icon

SOURCES += main.cpp \
    src/random.cpp

OTHER_FILES += \
    Game.qml \
    Aircraft.qml \
    Checkpoint.qml \
    airport/Airport1.qml \
    game.js \
    aircraft.js \
    Button.qml \
    util.js \
    Explosion.qml \
    GameOver.qml \
    Main.qml \
    main.js \
    airport/Airstrip.qml \
    airport/Airport2.qml \
    info/Info.qml


RESOURCES += \
    img.qrc \
    qml.qrc \
    scripts.qrc

HEADERS += \
    src/random.h
