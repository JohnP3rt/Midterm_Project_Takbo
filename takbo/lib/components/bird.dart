import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/pipes.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird()
      : super(
            position: Vector2(birdStartX, birdStartY),
            size: Vector2(birdWidth, birdHeight));

  double velocity = 0;
  bool isGliding = false; // Tracks whether the bird is gliding

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    sprite = await Sprite.load('mananaggal.png');

    add(RectangleHitbox());
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    if (isGliding) {
      velocity = glideUpwardVelocity; // Apply upward velocity when gliding
    } else {
      velocity += gravity * dt; // Apply gravity when not gliding
    }
    position.y += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as FlappyBirdGame).gameOver();
    }

    if (other is Pipe) {
      (parent as FlappyBirdGame).gameOver();
    }
  }
}
