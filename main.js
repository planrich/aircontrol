var gameBuilder = Qt.createComponent("Game.qml");
var game;

//show the game, and create it if it does not exist
function resume() {
    if (game == null) {
        game = gameBuilder.createObject(canvas);
    } else {
        game.resume();
    }
}

//pause
function pause() {
    if (game != null) {
        game.pause();
    }
}
