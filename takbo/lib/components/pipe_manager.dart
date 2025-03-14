import 'dart:math';
import 'package:flame/components.dart';
import 'package:takbo/components/pipes.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';
import 'package:takbo/components/floating_power_up.dart';

class PipeManager extends Component with HasGameRef<FlappyBirdGame> {
  double pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    // TODO: implement update
    pipeSpawnTimer += dt;

    if (pipeSpawnTimer > pipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;

    final double maxPipeHeight = screenHeight - pipeGap - minPipeHeight;

    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);

    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    final bottomPipe = Pipe(
        Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
        Vector2(pipeWidth, bottomPipeHeight),
        isTopPipe: false);

    final topPipe = Pipe(
        Vector2(gameRef.size.x, 0), Vector2(pipeWidth, topPipeHeight),
        isTopPipe: true);

    gameRef.add(bottomPipe);
    gameRef.add(topPipe);

    // Randomly spawn a floating power-up
    if (Random().nextDouble() < 0.1) {
      // 10% chance to spawn a floating power-up
      final floatingPowerUp = FloatingPowerUp(
        Vector2(gameRef.size.x,
            Random().nextDouble() * (screenHeight - groundHeight - 50)),
        Vector2(40, 40),
      );
      gameRef.add(floatingPowerUp);
    }
  }
}
