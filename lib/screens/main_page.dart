import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/config.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/models/streamer.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/providers/streamers_provided.dart';
import 'package:multistreamer_pomodoro/screens/introduction_page.dart';
import 'package:multistreamer_pomodoro/screens/schedule_page.dart';
import 'package:multistreamer_pomodoro/screens/viewers_page.dart';
import 'package:multistreamer_pomodoro/widgets/background.dart';
import 'package:multistreamer_pomodoro/widgets/menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.isClient});

  static const route = '/main-page';
  final bool isClient;
  final int deltaTime = 30;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool _isInitialized = false;
  final _tabMenu = ['Introduction', 'Horaire', 'Auditeurs &\nAuditrices'];

  late final _tabController =
      TabController(length: _tabMenu.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _prepareListTwitchInterface(maxRetries: 10, maxWaitingTime: 2000);

    // The page should open on the last tab at the event
    if (isEventStarted) {
      _tabController.animateTo(_tabMenu.length - 1);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Background(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 120),
              Menu(items: _tabMenu, tabController: _tabController),
              const SizedBox(height: 36),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 500,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        const IntroductionPage(),
                        const SchedulePage(),
                        ViewersPage(isInitialized: _isInitialized),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _prepareListTwitchInterface({
    int retries = 0,
    required int maxWaitingTime,
    required int maxRetries,
  }) async {
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
      setState(() {
        _isInitialized = true;
      });
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
        _addChatterTime(
            streamer: streamers.firstWhere((e) => e.streamerId == streamerId));
      });
    }

    setState(() {
      _isInitialized = true;
    });
  }

  void _addChatterTime({required Streamer streamer}) async {
    final chatters = ChattersProvided.of(context, listen: false);

    // If the user is not live, do not add time to their viewers
    final api = TwitchInterface.instance.managers[streamer.streamerId]?.api;
    if (api == null) return;
    if (!(await api.isUserLive(api.streamerId))!) return;

    final currentChatters =
        await api.fetchChatters(blacklist: ['CommanderRoot', 'StreamElements']);
    if (currentChatters == null) return;

    // Get the followers of the current streamer
    final followers = (await api.fetchFollowers(includeStreamer: true))!;

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
  }
}
