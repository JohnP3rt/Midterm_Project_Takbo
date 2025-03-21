import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu(this.game, {super.key});
  final ManananggalGame game;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Mananggalis',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontFamily: "PressStart2P",
            )
          ),
          SizedBox(height: 25,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(),
            onPressed: () {
              game.gameStart = true;
              game.overlays.add('PauseButton');
            },
            child: Text('Play'),
          )
        ],
      ),
    );
  }
}
