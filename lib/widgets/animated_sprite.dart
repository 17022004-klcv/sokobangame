import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedSprite extends StatefulWidget {
  final String imagePath;
  final int totalFrames;
  final double frameWidth;
  final double frameHeight;
  final Duration stepTime;

  const AnimatedSprite({
    Key? key,
    required this.imagePath,
    required this.totalFrames,
    required this.frameWidth,
    required this.frameHeight,
    this.stepTime = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  _AnimatedSpriteState createState() => _AnimatedSpriteState();
}

class _AnimatedSpriteState extends State<AnimatedSprite> {
  int _currentFrame = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Bucle para cambiar el fotograma cada X milisegundos
    _timer = Timer.periodic(widget.stepTime, (timer) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % widget.totalFrames;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.frameWidth,
      height: widget.frameHeight,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxWidth: widget.frameWidth * widget.totalFrames,
          maxHeight: widget.frameHeight,
          child: Transform.translate(
            // Movemos la tira de imágenes hacia la izquierda frame a frame
            offset: Offset(-_currentFrame * widget.frameWidth, 0),
            child: Image.asset(widget.imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
