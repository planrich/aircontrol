#-------------------------------------------------
#
# Project created by QtCreator 2010-12-27T19:47:22
#
#-------------------------------------------------

QT += core gui declarative opengl

TARGET = wefly
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app
target.path=/usr/local/bin
INSTALLS=target


SOURCES += main.cpp

OTHER_FILES += \
    Game.qml \
    Aircraft.qml \
    Checkpoint.qml \
    Airport.qml \
    Menu.qml \
    game.js \
    aircraft.js \
    Button.qml \
    util.js \
    Explosion.qml \
    GameOver.qml \
    Main.qml \
    main.js


RESOURCES += \
    img.qrc \
    qml.qrc \
    scripts.qrc

HEADERS +=
