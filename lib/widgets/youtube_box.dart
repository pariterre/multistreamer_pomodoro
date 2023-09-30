import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeBox extends StatelessWidget {
  const YoutubeBox(
      {super.key,
      required this.controller,
      this.boxWidth,
      this.widthRatio = 1});

  final double? boxWidth;
  final double widthRatio;
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = boxWidth ?? constraints.maxWidth;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: width * widthRatio,
              child: YoutubePlayer(controller: controller)),
          SizedBox(width: width)
        ],
      );
    });
  }
}
