import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/models/streamer.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/providers/streamers_provided.dart';

class ShowParticipantsPage extends StatefulWidget {
  const ShowParticipantsPage({super.key});

  static const route = '/show-participants-page';
  final deltaTime = 30; // In seconds

  @override
  State<ShowParticipantsPage> createState() => _ShowParticipantsPageState();
}

class _ShowParticipantsPageState extends State<ShowParticipantsPage> {
  void _addChatterTime(
      {required String streamerName, required List<String> currentChatters}) {
    final chatters = ChattersProvided.of(context, listen: false);

    for (final chatterName in currentChatters) {
      // Check if it is a new chatter
      if (!chatters.any((chatter) => chatter.name == chatterName)) {
        chatters.add(Chatter(name: chatterName));
        continue; // We must wait for firebase to respond
      }
      final currentChatter =
          chatters.firstWhere((chatter) => chatter.name == chatterName);

      // Check if it is the first time on a specific chanel
      if (currentChatter.hasNotStreamer(streamerName)) {
        currentChatter.addStreamer(streamerName);
      }

      // Add one time increment to the user
      currentChatter.incrementTimeWatching(widget.deltaTime, of: streamerName);

      // Update the provider
      chatters.add(currentChatter);
    }
    setState(() {});
  }

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
            .fetchChatters();
        if (chatters == null) return;

        final api = TwitchInterface.instance.managers[streamerId]?.api;
        if (api == null) return;

        // If the user is not live, do not add time to their viewers
        if (!(await api.isUserLive(api.streamerId))!) return;

        _addChatterTime(
            streamerName:
                streamers.firstWhere((e) => e.streamerId == streamerId).name,
            currentChatters: chatters);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final chatters = ChattersProvided.of(context);

    return Scaffold(
      body: Center(
        child: chatters.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auditeur\u2022trice présent\u2022e par chaine',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...chatters.map((chatter) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _ChatterTile(chatter: chatter),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ChatterTile extends StatelessWidget {
  const _ChatterTile({required this.chatter});

  final Chatter chatter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chatter.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: chatter.isEmpty
              ? const Text('Aucun')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...chatter.streamerNames.map((streamer) => Text(
                        '$streamer (${chatter.watchingTime(of: streamer) ~/ 60} minutes)')),
                    Text(
                        'En tout (${chatter.totalWatchingTime ~/ 60} minutes)'),
                  ],
                ),
        ),
      ],
    );
  }
}
