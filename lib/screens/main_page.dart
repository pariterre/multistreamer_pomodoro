import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/models/chatter.dart';
import 'package:pomo_latte_pumpkin/models/streamer.dart';
import 'package:pomo_latte_pumpkin/models/twitch_interface.dart';
import 'package:pomo_latte_pumpkin/providers/chatters_provided.dart';
import 'package:pomo_latte_pumpkin/providers/streamers_provided.dart';
import 'package:pomo_latte_pumpkin/screens/introduction_page.dart';
import 'package:pomo_latte_pumpkin/screens/schedule_page.dart';
import 'package:pomo_latte_pumpkin/screens/streamer_page.dart';
import 'package:pomo_latte_pumpkin/screens/thanking_page.dart';
import 'package:pomo_latte_pumpkin/screens/viewers_page.dart';
import 'package:pomo_latte_pumpkin/widgets/background.dart';
import 'package:pomo_latte_pumpkin/widgets/menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.isServer});

  static const route = '/main-page';
  final bool isServer;
  final int deltaTime = 30;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool _isInitialized = false;
  final _tabMenu = [
    'Introduction',
    'Animateurs &\nAnimatrices',
    'Horaire',
    'Auditeurs &\nAuditrices',
    'Remerciements',
  ];

  late final _tabController =
      TabController(length: _tabMenu.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _prepareListTwitchInterface(maxRetries: 10, maxWaitingTime: 2000);

    // The page should open on the last tab at the event
    if (isEventStarted) {
      _tabController.animateTo(3);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columnWidth = MediaQuery.of(context).size.width > 536
        ? 500.0
        : MediaQuery.of(context).size.width - 36;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Background(),
          if (widget.isServer)
            Padding(
              padding: const EdgeInsets.only(top: 156.0),
              child: SizedBox(
                  width: columnWidth,
                  child: ViewersPage(
                    isInitialized: _isInitialized,
                    isServer: widget.isServer,
                  )),
            ),
          if (!widget.isServer)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 120),
                Menu(items: _tabMenu, tabController: _tabController),
                const SizedBox(height: 36),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: columnWidth,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          const IntroductionPage(),
                          const StreamerPage(),
                          const SchedulePage(),
                          ViewersPage(
                            isInitialized: _isInitialized,
                            isServer: widget.isServer,
                          ),
                          const ThankingPage(),
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
    if (!widget.isServer) {
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

    final currentChatters = await api.fetchChatters();
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
