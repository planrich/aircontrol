var gameBuilder = Qt.createComponent("Game.qml");
var game;

//show the game, and create it if it does not exist
function resume() {
    if (game == null) {
        console.debug("creating new game");
        game = gameBuilder.createObject(canvas);
        console.debug(gameBuilder.errorString());
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
