import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/models/streamer_info.dart';
import 'package:multistreamer_pomodoro/widgets/background.dart';
import 'package:multistreamer_pomodoro/widgets/menu.dart';
import 'package:multistreamer_pomodoro/widgets/schedule_page.dart';
import 'package:multistreamer_pomodoro/widgets/viewers_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.isClient});

  static const route = '/main-page';
  final bool isClient;

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
                      ViewersPage(isClient: widget.isClient),
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
