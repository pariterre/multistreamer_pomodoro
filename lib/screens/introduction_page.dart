import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('INTRODUCTION', style: Theme.of(context).textTheme.titleLarge),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                    'Bienvenue au PomoLattePumpkin-48h-Relais!! Yeah!! Heu... le quoi?'),
                const SizedBox(height: 12),
                const Text('Le PomoLattePumpkin-48h-Relais! Je t\'explique :'),
                const SizedBox(height: 12),
                const Text(
                    'Tu te prépares un (ou plusieurs) spicy lattes pumpkins pour célébrer octobre, '
                    'tu ouvres un fureteur web et tu t\'installes pour travailler avec nous! '
                    'Nous serons des vôtres pour travailler sur 48h les 5 au 7 octobre prochain de 14h à 14h!'),
                const SizedBox(height: 12),
                const Text(
                    'Viens découvrir des animateurs et animatrices ainsi que des communautés de '
                    'travail merveilleuses, en plus de découvrir différentes approches de '
                    'la méthode pomodoro. Que ce soit des séances courtes (25 minutes '
                    'travail/5 minutes de pause) ou longues (50/10), strictes ou plus...laxistes(!), '
                    'il y en aura pour toutes les personnalités, dont la tienne.'),
                const SizedBox(height: 12),
                const Text(
                    'Alors n\'hésite pas à nous joindre juste avant tes examens pour un '
                    'blitz d\'étude ou d\'écriture! Pour les plus vieux d\'entre-vous, '
                    'il y a un événement Facebook que vous pouvez joindre en '
                    'guise de rappel, à l\'adresse suivante : '),
                InkWell(
                    onTap: () {
                      launchUrl(Uri(
                          scheme: 'https',
                          path: 'www.facebook.com/events/1557104731490847'));
                    },
                    child: const Text(
                      'https://www.facebook.com/events/1557104731490847',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
