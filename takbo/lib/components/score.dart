import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class ScoreText extends TextComponent with HasGameRef<FlappyBirdGame> {
  ScoreText()
      : super(
            text: '0',
            textRenderer: TextPaint(
                style: TextStyle(color: Colors.grey.shade900, fontSize: 40)));

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {
    // TODO: implement update
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
