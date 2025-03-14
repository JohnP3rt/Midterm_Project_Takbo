import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takbo/components/background.dart';
import 'package:takbo/components/bird.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/pipe_manager.dart';
import 'package:takbo/components/pipes.dart';
import 'package:takbo/components/score.dart';
import 'package:takbo/constants.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late AudioPlayer _audioPlayer;

  BuildContext? gameContext; // Store the context for dialog use

  @override
  FutureOr<void> onLoad() async {
    background = Background(size);
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);

    _audioPlayer = AudioPlayer();
    await _audioPlayer.setAsset('assets/audio/scary_bg.mp3');
    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.play();
  }

  @override
  void onDetach() {
    _audioPlayer.dispose(); // Properly dispose of the audio player
    super.onDetach();
  }

  @override
  void onTap() {
    bird.flap();
  }

  @override
  void onTapDown(TapDownInfo info) {
    bird.isGliding = true;
  }

  @override
  void onTapUp(TapUpInfo info) {
    bird.isGliding = false;
  }

  int score = 0;
  bool isGameOver = false;

  void incrementScore() => score += 1;
  void incrementScoreBy(int points) => score += points;

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    _audioPlayer.pause();
    pauseEngine();

    if (gameContext != null) {
      showDialog(
        context: gameContext!,
        builder: (context) => AlertDialog(
          title: const Text('Nahuli ka'),
          content: Text('High Score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text('Lipad again'),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    isGameOver = false;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
    _audioPlayer.seek(Duration.zero); // Reset audio playback
    _audioPlayer.play();
  }
}
