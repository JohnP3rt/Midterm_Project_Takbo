import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class GameOverHud extends StatelessWidget {
  const GameOverHud(this.game, {super.key});
  final ManananggalGame game;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Game Over',
              style: TextStyle(
                  fontSize: 24,
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontFamily: "PressStart2P")),
        ),

        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 4,
          child: Column(
            children: [
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score',
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontFamily: "PressStart2P")),
                  Text(game.score.value.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontFamily: "PressStart2P")),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Best',
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontFamily: "PressStart2P")),
                  Text(game.highestScore.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontFamily: "PressStart2P")),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              game.overlays.remove('PauseButton');
              game.overlays.remove('PauseMenu');
              game.resetGame();
            },
            child: Text(
              'Play Again',
              style: TextStyle(fontFamily: "PressStart2P"),
            ),
          ),
        )
      ],
    ));
  }
}
