import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multistreamer_pomodoro/main.dart';
import 'package:multistreamer_pomodoro/models/schedule_info.dart';
import 'package:url_launcher/url_launcher.dart';

final _schedule = [
  ScheduleInfo(
      title: 'On est fébrile!',
      url: 'https://www.facebook.com/events/1557104731490847',
      starting: DateTime(2023, 09, 23),
      length: Duration(
          milliseconds: DateTime(2023, 10, 5, 13, 30).millisecondsSinceEpoch -
              (DateTime(2023, 09, 23).millisecondsSinceEpoch))),
  ScheduleInfo(
      title: 'Ouverture',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 5, 13, 30),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'AlchimisteDesMots',
      url: 'twitch.tv/AlchimisteDesMots',
      starting: DateTime(2023, 10, 5, 14, 00),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 5, 18, 0),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'Le_Sketch',
      url: 'twitch.tv/Le_Sketch',
      starting: DateTime(2023, 10, 5, 18, 30),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 5, 22, 30),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'WayceUpenFoya',
      url: 'twitch.tv/WayceUpenFoya',
      starting: DateTime(2023, 10, 5, 23, 0),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 3, 0),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'Helene_Ducrocq',
      url: 'twitch.tv/Helene_Ducrocq',
      starting: DateTime(2023, 10, 6, 3, 30),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 7, 30),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'elidelivre',
      url: 'twitch.tv/elidelivre',
      starting: DateTime(2023, 10, 6, 8, 0),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Table ronde',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 12, 0),
      length: const Duration(hours: 1, minutes: 30)),
  ScheduleInfo(
      title: 'Pariterre',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 13, 30),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 17, 30),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'Fenyxya',
      url: 'twitch.tv/Fenyxya',
      starting: DateTime(2023, 10, 6, 18, 0),
      length: const Duration(hours: 4)),
  ScheduleInfo(
      title: 'Activité à confirmer',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 6, 22, 0),
      length: const Duration(hours: 4, minutes: 30)),
  ScheduleInfo(
      title: 'MemePauteure',
      url: 'twitch.tv/MemepAuteure',
      starting: DateTime(2023, 10, 7, 2, 30),
      length: const Duration(hours: 3, minutes: 30)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 7, 6, 0),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'destinova_glo',
      url: 'twitch.tv/destinova_glo',
      starting: DateTime(2023, 10, 7, 6, 30),
      length: const Duration(hours: 3, minutes: 30)),
  ScheduleInfo(
      title: 'Pause discussion',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 7, 10, 0),
      length: const Duration(minutes: 30)),
  ScheduleInfo(
      title: 'LizEMyers',
      url: 'twitch.tv/LizEMyers',
      starting: DateTime(2023, 10, 7, 10, 30),
      length: const Duration(hours: 3, minutes: 30)),
  ScheduleInfo(
      title: 'Cérémonie de fermeture',
      url: 'twitch.tv/pariterre',
      starting: DateTime(2023, 10, 7, 14, 0),
      length: const Duration(minutes: 10)),
];

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _fromFrance = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // TODO font style
              'HORAIRE',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _fromFrance = true),
                  child: Text(
                    'France',
                    style: TextStyle(
                        fontWeight:
                            _fromFrance ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '/',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                InkWell(
                    onTap: () => setState(() => _fromFrance = false),
                    child: Text('Québec',
                        style: TextStyle(
                            fontWeight: _fromFrance
                                ? FontWeight.normal
                                : FontWeight.bold))),
              ],
            )
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: _schedule.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _StreamerTile(
                info: _schedule[index],
                fromFrance: _fromFrance,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _StreamerTile extends StatelessWidget {
  const _StreamerTile({required this.info, required this.fromFrance});

  final ScheduleInfo info;
  final bool fromFrance;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMM HH:mm');

    final now = DateTime.now();
    final isActive =
        now.compareTo(info.starting) > 0 && now.compareTo(info.ending) < 0;

    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: isActive ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(8)),
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Début / Fin'),
                  Row(
                    children: [
                      Text(dateFormat.format(info.starting
                          .add(Duration(hours: fromFrance ? 6 : 0)))),
                      const Text(' / '),
                      Text(dateFormat.format(info.ending
                          .add(Duration(hours: fromFrance ? 6 : 0)))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lien'),
                  InkWell(
                      onTap: () {
                        launchUrl(Uri(scheme: 'https', path: info.url));
                      },
                      child: Text(
                        info.url,
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
