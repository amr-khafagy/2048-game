import 'package:flutter/material.dart';
import 'package:game/models/tile.dart';

class AnimatedTile extends AnimatedWidget {
  final Tile tile;
  final Widget child;
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;
  final double size;
  late final double _top = tile.getTop(size);
  late final double _left = tile.getLeft(size);
  late final double _nextTop = tile.getNextTop(size) ?? _top;
  late final double _nextLeft = tile.getNextLeft(size) ?? _left;
  AnimatedTile(
      {super.key,
      required this.size,
      required this.tile,
      required this.child,
      required this.moveAnimation,
      required this.scaleAnimation})
      : super(listenable: Listenable.merge([moveAnimation, scaleAnimation]));
  late final Animation<double> top =
          Tween<double>(begin: _top, end: _nextTop).animate(moveAnimation),
      left = Tween<double>(begin: _left, end: _nextLeft).animate(moveAnimation),
      scale = TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.0, end: 1.5)
                .chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50.0)
      ]).animate(scaleAnimation);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top.value,
        left: left.value,
        child: tile.merged
            ? ScaleTransition(
                scale: scale,
                child: child,
              )
            : child);
  }
}
