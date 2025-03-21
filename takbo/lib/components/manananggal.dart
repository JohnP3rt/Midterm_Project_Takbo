import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/obstacle.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Manananggal extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ManananggalGame> {
  Manananggal()
      : super(
            position: Vector2(playerStartX, playerStartY),
            size: Vector2(playerWidth, playerHeight));

  double velocity = 0;
  bool isGliding = false; // Tracks whether the bird is gliding

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    final spriteSheet = await Flame.images.load('og/Manananggal.png');
    final data = SpriteAnimationData.sequenced(
        textureSize: Vector2(150, 65), amount: 3, stepTime: 0.1, loop: true);
    animation = SpriteAnimation.fromFrameData(spriteSheet, data);
    add(RectangleHitbox.relative(Vector2(0.8, 0.5),
        parentSize: Vector2(playerWidth, playerHeight)));
    return super.onLoad();
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    // TODO: implement update

    if (position.y < 0) {
      position.y = 0;
    }
    position.x = -300;

    if (game.gameStart) {
      position.x += 400;
      if (isGliding) {
        velocity = glideUpwardVelocity; // Apply upward velocity when gliding
      } else {
        velocity += gravity * dt; // Apply gravity when not gliding
      }
    }

    position.y += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as ManananggalGame).gameOver();
    }

    if (other is Obstacle) {
      (parent as ManananggalGame).gameOver();
    }
  }
}
