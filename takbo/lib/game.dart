import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takbo/components/background.dart';
import 'package:takbo/components/bottom_power_up.dart';
import 'package:takbo/components/manananggal.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/parallax_background.dart';
import 'package:takbo/components/obstacle_manager.dart';
import 'package:takbo/components/obstacle.dart';
import 'package:takbo/components/score.dart';
import 'package:takbo/constants.dart';

class ManananggalGame extends FlameGame
    with TapDetector, HasCollisionDetection {
  late Manananggal player;
  late Background background;
  late Ground ground;
  late ObstacleManager obstacleManager;
  late ScoreText scoreText;
  late AudioPlayer _audioPlayer;
  late ParallaxBackground parallax;
  int score = 0;
  late SharedPreferences sharedPrefs;
  bool gameStart = false;
  var highestScore;
  @override
  FutureOr<void> onLoad() async {
    debugMode = false;
    // background = Background(size);
    // add(background);

    parallax = ParallaxBackground();
    add(parallax);

    player = Manananggal();
    add(player);

    ground = Ground();
    add(ground);

    obstacleManager = ObstacleManager();
    //add(obstacleManager);

    scoreText = ScoreText();
    //add(scoreText);

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
    if (gameStart) {
      player.flap();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    player.isGliding = true;
  }

  @override
  void onTapUp(TapUpInfo info) {
    player.isGliding = false;
  }

  bool isGameOver = false;
  bool isPaused = false;
  bool isComplete = false;

  void incrementScore() => score += 1;

  void incrementScoreBy(int points) => score += points;
  int lastDifficultyIncrease = 0;

  void increaseDifficulty() {
    if (score % 10 == 0 && score > 0 && lastDifficultyIncrease != score) {
      groundScrollingSpeed += 20;
      obstacleInterval = (obstacleInterval - .5).clamp(1.0, double.infinity);
      lastDifficultyIncrease = score;
      print('Scrolling Speed: $groundScrollingSpeed');
      print('Obstacle Interval: $obstacleInterval');
    }
  }

  void compareScore() async {
    sharedPrefs = await SharedPreferences.getInstance();
    highestScore = sharedPrefs.getInt('highestScore');
    if (highestScore != null) {
      if (score > highestScore) {
        await sharedPrefs.setInt('highestScore', score);
      }
    } else {
      await sharedPrefs.setInt('highestScore', score);
    }
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    _audioPlayer.pause();
    pauseEngine();
    obstacleInterval = 3;
    groundScrollingSpeed = 150;
    overlays.remove('PauseButton');
    overlays.add('GameOverHUD');
    remove(scoreText);
  }

  void resetGame() {
    player.position = Vector2(playerStartX, playerStartY);
    player.velocity = 0;
    score = 0;
    isGameOver = false;
    add(scoreText);
    children.whereType<Obstacle>().forEach((pipe) => pipe.removeFromParent());
    children
        .whereType<BuntisPowerUp>()
        .forEach((buntis) => buntis.removeFromParent());
    resumeEngine();
    _audioPlayer.seek(Duration.zero); // Reset audio playback
    _audioPlayer.play();
    overlays.remove('GameOverHUD');
    overlays.add('PauseButton');
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused == true) {
      pauseEngine();
      overlays.add('PauseMenu');
      overlays.remove('PauseButton');
    } else {
      overlays.remove('PauseMenu');
      overlays.add('PauseButton');
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    compareScore();
    // TODO: implement update
    if (gameStart) {
      add(obstacleManager);
      add(scoreText);
      overlays.remove('MainMenu');
    }
    if (!isGameOver) {
      //If di pa complete ang laro and not game over mag execute atoy
      increaseDifficulty();
    }
    super.update(dt);
  }
}
