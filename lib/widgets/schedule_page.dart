import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multistreamer_pomodoro/main.dart';
import 'package:multistreamer_pomodoro/models/streamer_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({
    super.key,
    required this.streamers,
  });

  final List<StreamerInfo> streamers;

  @override
  Widget build(BuildContext context) {
    final sortedStreamers = [...streamers]..sort(
        (a, b) =>
            a.starting.millisecondsSinceEpoch -
            b.starting.millisecondsSinceEpoch,
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // TODO font style
          'HORAIRE',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: sortedStreamers.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _StreamerTile(info: sortedStreamers[index]),
            ),
          ),
        )
      ],
    );
  }
}

class _StreamerTile extends StatelessWidget {
  const _StreamerTile({required this.info});

  final StreamerInfo info;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMM - HH:mm');

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
                info.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Début de l\'animation'),
                  Text(dateFormat.format(info.starting)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fin de l\'animation'),
                  Text(dateFormat.format(info.ending)),
                ],
              ),
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
                            decoration: TextDecoration.underline),
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
