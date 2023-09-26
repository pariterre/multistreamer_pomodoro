import 'package:flutter/material.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/main.dart';
import 'package:pomo_latte_pumpkin/models/streamer_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class StreamerPage extends StatelessWidget {
  const StreamerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final streamerInfoSorted = [...streamersInfo]..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    return ListView.builder(
        itemCount: streamerInfoSorted.length,
        itemBuilder: (context, index) =>
            _StreamerCard(streamerInfo: streamerInfoSorted[index]));
  }
}

class _StreamerCard extends StatefulWidget {
  const _StreamerCard({required this.streamerInfo});

  final StreamerInfo streamerInfo;
  @override
  State<_StreamerCard> createState() => _StreamerCardState();
}

class _StreamerCardState extends State<_StreamerCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              color: _isExpanded ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(8)),
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.streamerInfo.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InkWell(
                    onTap: () {
                      launchUrl(Uri(
                          scheme: 'https',
                          path: widget.streamerInfo.twitchUrl));
                    },
                    child: Text(
                      widget.streamerInfo.twitchUrl,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white),
                    )),
                if (!_isExpanded) const Text('Voir plus...'),
                if (_isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(widget.streamerInfo.description),
                      const SizedBox(height: 12),
                      if (widget.streamerInfo.presentationYoutubeId == null &&
                          widget.streamerInfo.philosophyYoutubeId == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vidéo de présentation',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const Text('À venir'),
                          ],
                        ),
                      if (widget.streamerInfo.presentationYoutubeId != null)
                        _VideoWithTitle(
                            title: 'Qui suis-je?',
                            videoId:
                                widget.streamerInfo.presentationYoutubeId!),
                      if (widget.streamerInfo.presentationYoutubeId != null &&
                          widget.streamerInfo.philosophyYoutubeId != null)
                        const SizedBox(height: 24),
                      if (widget.streamerInfo.philosophyYoutubeId != null)
                        _VideoWithTitle(
                          title: 'Mon approche du cotravail en pomodoro',
                          videoId: widget.streamerInfo.philosophyYoutubeId!,
                          delayBeforeLoading: 1000,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoWithTitle extends StatelessWidget {
  const _VideoWithTitle({
    required this.title,
    required this.videoId,
    this.delayBeforeLoading = 0,
  });

  final String title;
  final String videoId;
  final int delayBeforeLoading;

  ///
  /// For some reason, if two videos are loaded at the same time, one does not
  /// load. This method along with [delayBeforeLoading] allows to delay the
  /// loading of the video while another one is loading
  Future<bool> _wait() async {
    if (delayBeforeLoading != 0) {
      await Future.delayed(Duration(milliseconds: delayBeforeLoading));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return FutureBuilder(
      future: _wait(),
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (!snapshot.hasData)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          if (snapshot.hasData) YoutubePlayer(controller: controller),
        ],
      ),
    );
  }
}
