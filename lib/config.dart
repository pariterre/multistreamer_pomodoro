import 'dart:ui';

import 'package:pomo_latte_pumpkin/models/schedule_info.dart';
import 'package:pomo_latte_pumpkin/models/streamer_info.dart';
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

const backgroundColor = Color(0xFFFF8800);
const selectedColor = Color.fromARGB(255, 87, 48, 3);
const unselectedColor = Color.fromARGB(255, 238, 156, 63);

bool get isEventStarted =>
    DateTime.now().compareTo(DateTime(2023, 10, 5, 14)) > 0;

final eventSchedule = [
  ScheduleInfo(
      title: 'On est fébrile!',
      url: 'facebook.com/events/1557104731490847',
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

String eventYoutubeId = '91sBKUfCGpg';

final streamersInfo = [
  StreamerInfo(
    'AlchimisteDesMots',
    description:
        'A la tête de La Petite Boutique des Auteurs, j\'aime aussi faire '
        'des expériences avec les mots, un peu comme une alchimiste, quoi... 🤭 '
        'Bienvenue sur mes lives en carton qui buguent et où les 🐈, le 🐕, '
        'les 🙎‍♂️ (et pas que) sont à rôder pas loin (du stream littéraire '
        'pas prise de tête, en somme)',
    twitchUrl: 'twitch.tv/AlchimisteDesMots',
    presentationYoutubeId: '7kCX3617hkU',
    philosophyYoutubeId: 'DUJZD5FiLAc',
  ),
  StreamerInfo(
    'destinova_glo',
    description: '💻Coworking | 📚 WWM : Travaillons ensemble intensément mais '
        'surtout efficacement, soyons productifs ! || 🎮 Gaming : '
        'Installes-toi confortablement pour te détendre et rire ! || 🌸 '
        'Fondatrice de Authentic\'s Vibes 🌸',
    twitchUrl: 'twitch.tv/destinova_glo',
  ),
  StreamerInfo(
    'elidelivre',
    description:
        'Chroniqueuse littéraire, 21 ans📚Lectures en tous genres 📍Suisse.',
    twitchUrl: 'twitch.tv/elidelivre',
  ),
  StreamerInfo(
    'Fenyxya',
    description: 'Coucou!✨Moi, c\'est Fenyxya, mais tu peux aussi m\'appeler '
        'Fenyx ou encore Feny si tu préfères! Je te souhaite la bienvenue '
        'dans mon univers très pugos... La lecture, l\'art et les sims '
        'seront principalement au rendez-vous!🔮',
    twitchUrl: 'twitch.tv/Fenyxya',
    presentationYoutubeId: 'yclvzNBriGc',
    philosophyYoutubeId: 'cG4uRvS48OM',
  ),
  StreamerInfo(
    'Helene_Ducrocq',
    description:
        'Bienvenue dans mon studio de création ! Découvre mon quotidien de '
        'réalisatrice de films d\'animation, d\'illustratrice, d\'autrice '
        'de livres et d\'artiste. Ici, on coworke pou parler créativité, '
        'coups de coeur et je réalise en direct mes prochains projets '
        '(4 films en animation, 1 livre, 1 expo).',
    twitchUrl: 'twitch.tv/Helene_Ducrocq',
    presentationYoutubeId: 'wmozo8-xjTE',
    philosophyYoutubeId: 'zxv7PvuKWfM',
  ),
  StreamerInfo(
    'Le_Sketch',
    description:
        'Je parle de marketing en essayant de ne pas vous endormir, je '
        'découvre des jeux avec vous et je raconte des blagues nulles trop '
        'souvent. Je suis un consultant SEO qui tente de rendre le marketing '
        'Web plus sympathique et empathique.',
    twitchUrl: 'twitch.tv/Le_Sketch',
  ),
  StreamerInfo(
    'LizEMyers',
    description:
        'French author living in the US / Auteur française - Fantasy - '
        'Urban Fantasy expatriée aux USA / Saga Mathilda Shade',
    twitchUrl: 'twitch.tv/LizEMyers',
    presentationYoutubeId: 'SkYBOe7RbFA',
  ),
  StreamerInfo(
    'MemepAuteure',
    description:
        'Salut ! Moi c\'est MemepAuteure ! J\'ai 28 ans et je suis auteure '
        'de fantasy. Sur ma chaîne, tu découvriras des sessions de '
        'co-working et parfois des jeux vidéos.',
    twitchUrl: 'twitch.tv/MemepAuteure',
    presentationYoutubeId: 'MwWJb_j90FY',
  ),
  StreamerInfo(
    'Pariterre',
    description:
        'Étudiant en musique à une certaine époque, étudiant en kinésiologie '
        'à une autre...Alors pourquoi pas compléter un doctorat en Science '
        'de l\'Activité Physique chez les musiciens?',
    twitchUrl: 'twitch.tv/Pariterre',
    presentationYoutubeId: 'TJHV5L9P12k',
    philosophyYoutubeId: 'iwt_sJ5KFWM',
  ),
  StreamerInfo(
    'WayceUpenFoya',
    description: 'J\'ai lancé cette chaîne pour partager ma passion pour '
        'l\'écriture, la lecture et toutes les créations artistiques. '
        'Même si vous me verrez aussi jouer à des jeux vidéos et '
        'discuter autour de divers sujets, mon but est de partager '
        'avec vous ces univers qui me bercent depuis maintenant '
        'des années.',
    twitchUrl: 'twitch.tv/WayceUpenFoya',
    presentationYoutubeId: 'ELk77ehbDsE',
    philosophyYoutubeId: 'Tof29JZPy7E',
  ),
];
