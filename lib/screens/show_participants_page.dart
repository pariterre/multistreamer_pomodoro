import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';

class ShowParticipantsPage extends StatefulWidget {
  const ShowParticipantsPage({super.key});

  static const route = '/show-participants-page';
  final deltaTime = 1; // In minutes

  @override
  State<ShowParticipantsPage> createState() => _ShowParticipantsPageState();
}

class _ShowParticipantsPageState extends State<ShowParticipantsPage> {
  final Map<String, String> _streamerNames = {};
  final Map<String, Chatter> _chatters = {};

  void _addChatterTime(
      {required String streamerName, required List<String> chatters}) {
    for (final chatterName in chatters) {
      // Check if it is a new chatter
      if (!_chatters.keys.contains(chatterName)) {
        _chatters[chatterName] = Chatter(name: chatterName);
      }

      // Check if it is the first time on a specific chanel
      if (!_chatters[chatterName]!.duration.containsKey(streamerName)) {
        _chatters[chatterName]!.duration[streamerName] = 0;
      }

      // Add one time increment to the user
      _chatters[chatterName]!.duration[streamerName] =
          _chatters[chatterName]!.duration[streamerName]! + widget.deltaTime;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _prepareListTwitchInterface();
  }

  Future<void> _prepareListTwitchInterface() async {
    for (final streamerId in TwitchInterface.instance.connectedStreamerIds) {
      final streamerLogin =
          (await TwitchInterface.instance.managers[streamerId]!.api.login(
              TwitchInterface.instance.managers[streamerId]!.api.streamerId))!;
      _streamerNames[streamerId] = streamerLogin;

      Timer.periodic(Duration(minutes: widget.deltaTime), (timer) async {
        final chatters = await TwitchInterface
            .instance.managers[streamerId]!.api
            .fetchChatters();
        if (chatters == null) return;
        _addChatterTime(
            streamerName: _streamerNames[streamerId]!, chatters: chatters);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _streamerNames.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auditeur\u2022trice présent\u2022e par chaine',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ..._chatters.keys.map((name) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _ChatterTile(chatter: _chatters[name]!),
                      )),
                ],
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
          child: chatter.duration.isEmpty
              ? const Text('Aucun')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...chatter.duration.keys.map((streamer) => Text(
                        '$streamer (${chatter.duration[streamer]} minutes)')),
                    Text(
                        'En tout (${chatter.duration.values.fold(0, (prev, e) => prev + e)} minutes)')
                  ],
                ),
        ),
      ],
    );
  }
}
