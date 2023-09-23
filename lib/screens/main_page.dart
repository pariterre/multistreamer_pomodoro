import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/models/streamer.dart';
import 'package:multistreamer_pomodoro/models/streamer_info.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/providers/streamers_provided.dart';
import 'package:multistreamer_pomodoro/widgets/background.dart';
import 'package:multistreamer_pomodoro/widgets/menu.dart';
import 'package:multistreamer_pomodoro/widgets/schedule_page.dart';
import 'package:multistreamer_pomodoro/widgets/viewers_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const route = '/main-page';
  final deltaTime = 30; // In seconds

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  final streamersInformation = [
    StreamerInfo(
        name: 'AlchimisteDesMots',
        url: 'twitch.tv/AlchimisteDesMots',
        starting: DateTime(2023, 10, 5, 14, 00),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'Le_Sketch',
        url: 'twitch.tv/Le_Sketch',
        starting: DateTime(2023, 10, 5, 18, 30),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'WayceUpenFoya',
        url: 'twitch.tv/WayceUpenFoya',
        starting: DateTime(2023, 10, 5, 23, 0),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'Helene_Ducrocq',
        url: 'twitch.tv/Helene_Ducrocq',
        starting: DateTime(2023, 10, 6, 3, 30),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'elidelivre',
        url: 'twitch.tv/elidelivre',
        starting: DateTime(2023, 10, 6, 8, 0),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'Pariterre',
        url: 'twitch.tv/pariterre',
        starting: DateTime(2023, 10, 6, 13, 30),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'Fenyxya',
        url: 'twitch.tv/Fenyxya',
        starting: DateTime(2023, 10, 6, 18, 0),
        length: const Duration(hours: 4)),
    StreamerInfo(
        name: 'MemePauteure',
        url: 'twitch.tv/MemepAuteure',
        starting: DateTime(2023, 10, 7, 2, 30),
        length: const Duration(hours: 3, minutes: 30)),
    StreamerInfo(
        name: 'destinova_glo',
        url: 'twitch.tv/destinova_glo',
        starting: DateTime(2023, 10, 7, 6, 30),
        length: const Duration(hours: 3, minutes: 30)),
    StreamerInfo(
        name: 'LizEMyers',
        url: 'twitch.tv/LizEMyers',
        starting: DateTime(2023, 10, 7, 10, 30),
        length: const Duration(hours: 3, minutes: 30)),
  ];

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: chatters.isEmpty
          ? const CircularProgressIndicator()
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                const Background(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 120),
                    Menu(
                        items: const ['Auditeurs & Auditrices', 'Horaire'],
                        tabController: _tabController),
                    const SizedBox(height: 36),
                    Expanded(
                      child: SizedBox(
                        width: 500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ViewersPage(chatters: chatters.toList()),
                            SchedulePage(streamers: streamersInformation),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
