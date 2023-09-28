import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/models/schedule_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Text('HORAIRE', style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _fromFrance = true),
                  child: Text(
                    'France',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight:
                            _fromFrance ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                InkWell(
                    onTap: () => setState(() => _fromFrance = false),
                    child: Text('Québec',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
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
            itemCount: eventSchedule.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _StreamerTile(
                info: eventSchedule[index],
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
              Text(
                  '${dateFormat.format(info.starting.add(Duration(hours: fromFrance ? 6 : 0)))} '
                  '/ '
                  '${dateFormat.format(info.ending.add(Duration(hours: fromFrance ? 6 : 0)))}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.normal)),
              const SizedBox(height: 8),
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
        ),
      ),
    );
  }
}
