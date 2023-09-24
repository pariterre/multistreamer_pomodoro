import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFF8800)),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          width: 800,
          decoration: const BoxDecoration(color: Color(0xFFFF8800)),
          child: const Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              _Image('tomato_timer', top: 12, left: 12, height: 110),
              _Image('cup', top: 12, right: 12, height: 110),
              _Image('bean', top: 45, right: 140, height: 25),
              _Image('bean', top: 80, right: 125, height: 25, angle: 60),
              _Image('title', top: 24, height: 60),
              _Image('leef1', bottom: 0, right: 8, height: 250, opacity: 0.5),
              _Image('leef2', bottom: 0, left: 8, height: 150, opacity: 0.3),
              _Image('leef3',
                  top: 350, right: 140, height: 120, opacity: 0.1, angle: 60),
              _Image('leef4', top: 200, left: 140, height: 150, opacity: 0.1),
              _Image('leef5',
                  bottom: 100, left: 280, height: 100, opacity: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image(
    this.name, {
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.height,
    this.angle = 0,
    this.opacity = 1,
  });
  final String name;

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  final double? height;

  final double angle;
  final double opacity;

  double? _responsiveDimension(double? maxValue,
      {required double windowWidth}) {
    if (maxValue == null) return null;

    const maxWidth = 700.0;
    return windowWidth > maxWidth
        ? maxValue
        : maxValue * windowWidth / maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: _responsiveDimension(top, windowWidth: windowWidth),
      bottom: _responsiveDimension(bottom, windowWidth: windowWidth),
      left: _responsiveDimension(left, windowWidth: windowWidth),
      right: _responsiveDimension(right, windowWidth: windowWidth),
      child: SizedBox(
          height: _responsiveDimension(height, windowWidth: windowWidth),
          child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                  angle: angle * pi / 180,
                  child: Image.asset('assets/images/$name.png',
                      fit: BoxFit.contain)))),
    );
  }
}
