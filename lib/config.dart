import 'package:multistreamer_pomodoro/models/schedule_info.dart';
import 'package:twitch_manager/twitch_manager.dart';

const twitchAppName = 'MultiStreamer Pomodoro Counter';
const twitchAppId = 'wuxnu9zxzhgu3noztxtgdsulk4c950';
const twitchRedirect = 'https://twitchauthentication.pariterre.net:3000';
const authenticationServiceAddress =
    'wss://twitchauthentication.pariterre.net:3002';
const twitchScope = [
  TwitchScope.chatters,
  TwitchScope.readFollowers,
];

bool get isEventStarted =>
    DateTime.now().compareTo(DateTime(2023, 10, 5, 14)) > 0;

final eventSchedule = [
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
