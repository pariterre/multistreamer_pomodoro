import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/main.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/models/streamer.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/providers/streamers_provided.dart';

class ViewersPage extends StatefulWidget {
  const ViewersPage({super.key, required this.isClient});

  final bool isClient;
  final deltaTime = 30; // In seconds

  @override
  State<ViewersPage> createState() => _ViewersPageState();
}

class _ViewersPageState extends State<ViewersPage> {
  bool _isInitialize = false;

  @override
  void initState() {
    super.initState();
    _prepareListTwitchInterface(maxRetries: 10, maxWaitingTime: 2000);
  }

  Future<void> _prepareListTwitchInterface(
      {int retries = 0,
      required int maxWaitingTime,
      required int maxRetries}) async {
    // Wait for at least X seconds to load data. If none are received thed,
    // we can assume it is a fresh loading
    final streamers = StreamersProvided.of(context, listen: false);
    final chatters = ChattersProvided.of(context, listen: false);
    if (retries < maxRetries && (streamers.isEmpty || chatters.isEmpty)) {
      await Future.delayed(
          Duration(milliseconds: maxWaitingTime ~/ maxRetries));
      _prepareListTwitchInterface(
        retries: retries + 1,
        maxRetries: maxRetries,
        maxWaitingTime: maxWaitingTime,
      );
      return;
    }
    if (widget.isClient) {
      _isInitialize = true;
      setState(() {});
      return;
    }

    for (final streamerId in TwitchInterface.instance.connectedStreamerIds) {
      final streamerLogin =
          (await TwitchInterface.instance.managers[streamerId]!.api.login(
              TwitchInterface.instance.managers[streamerId]!.api.streamerId))!;

      if (!streamers.any((e) => e.name == streamerLogin)) {
        streamers.add(Streamer(streamerId: streamerId, name: streamerLogin));
      }

      Timer.periodic(Duration(seconds: widget.deltaTime), (timer) async {
        final chatters = await TwitchInterface
            .instance.managers[streamerId]!.api
            .fetchChatters(blacklist: ['CommanderRoot', 'StreamElements']);
        if (chatters == null) return;

        final api = TwitchInterface.instance.managers[streamerId]?.api;
        if (api == null) return;

        // If the user is not live, do not add time to their viewers
        if (!(await api.isUserLive(api.streamerId))!) return;

        _addChatterTime(
            streamer: streamers.firstWhere((e) => e.streamerId == streamerId),
            currentChatters: chatters);
      });
    }
    _isInitialize = true;
    setState(() {});
  }

  void _addChatterTime(
      {required Streamer streamer,
      required List<String> currentChatters}) async {
    final chatters = ChattersProvided.of(context, listen: false);
    final followers = (await TwitchInterface
        .instance.managers[streamer.streamerId]!.api
        .fetchFollowers(includeStreamer: true))!;

    for (final chatterName in currentChatters) {
      // Check if it is a new chatter
      if (!chatters.any((chatter) => chatter.name == chatterName)) {
        chatters.add(Chatter(name: chatterName));
        continue; // We must wait for firebase to respond
      }
      final currentChatter =
          chatters.firstWhere((chatter) => chatter.name == chatterName);

      // The chatter must be a follower of the streamer
      if (!followers.contains(currentChatter.name)) continue;

      // Check if it is the first time on a specific chanel
      if (currentChatter.hasNotStreamer(streamer.name)) {
        currentChatter.addStreamer(streamer.name);
      }

      // Add one time increment to the user

      currentChatter.incrementTimeWatching(widget.deltaTime, of: streamer.name);

      // Update the provider
      chatters.add(currentChatter);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final chatters = ChattersProvided.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // TODO font style
          'AUDITEURS ET AUDITRICES',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        chatters.isEmpty
            ? const Text('Aucun auditeur ou auditrice pour l\'instant')
            : Expanded(child: _buildChattersListTile(context)),
      ],
    );
  }

  Widget _buildChattersListTile(BuildContext context) {
    final chatters = ChattersProvided.of(context);
    final sortedChatters = [...chatters]
      ..sort((a, b) => b.totalWatchingTime - a.totalWatchingTime);

    return _isInitialize
        ? ListView.builder(
            itemCount: sortedChatters.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _ChatterTile(chatter: sortedChatters[index]),
            ),
          )
        : const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class _ChatterTile extends StatelessWidget {
  const _ChatterTile({required this.chatter});

  final Chatter chatter;

  @override
  Widget build(BuildContext context) {
    return chatter.isEmpty
        ? Container()
        : Card(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: selectedColor, borderRadius: BorderRadius.circular(8)),
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatter.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...chatter.streamerNames.map((streamer) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(streamer),
                                Text(
                                    '${chatter.watchingTime(of: streamer) ~/ 60} minutes'),
                              ],
                            )),
                        const SizedBox(width: 80, child: Divider()),
                        Text('${chatter.totalWatchingTime ~/ 60} minutes'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
