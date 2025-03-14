import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlappyBirdGame> {
  final bool isTopPipe;
  bool scored = false;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    sprite = await Sprite.load(isTopPipe ? 'topPipe.png' : 'bottomPipe.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // TODO: implement update
    position.x -= groundScrollingSpeed * dt;

    if (!scored && position.x + size.x < gameRef.bird.position.x) {
      scored = true;
      if (isTopPipe) {
        gameRef.incrementScore();
      }
    }

    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
