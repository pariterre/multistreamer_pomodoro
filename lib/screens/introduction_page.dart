import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('INTRODUCTION', style: Theme.of(context).textTheme.titleLarge),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                    'Bienvenue au PomoLattePumpkin-48h-Relais!! Yeah!! Heu... le quoi?'),
                SizedBox(height: 12),
                Text('Le PomoLattePumpkin-48h-Relais! Je t\'explique :'),
                SizedBox(height: 12),
                Text(
                    'Tu te prépares un (ou plusieurs) spicy lattés pumpkings pour célébrer octobre, '
                    'tu ouvres un fureteur web et tu t\'installes pour travailles avec nous! '
                    'Nous serons des vôtres pour travailler sur 48h les 5 au 7 octobre prochain de 14h à 14h!'),
                SizedBox(height: 12),
                Text(
                    'Viens découvrir des animateurs et animatrices ainsi que des communautés de '
                    'travail merveilleuses, en plus de découvrir différentes approches de '
                    'la méthode pomodoro. Que ce soit des séances courtes (25 minutes '
                    'travail/5 minutes de pause) ou longue (50/10), strictes ou plus...laxistes(!), '
                    'il y en aura pour toutes les personnalités, dont la tienne.'),
                SizedBox(height: 12),
                Text(
                    'Alors n\'hésite pas à nous joindre juste avant tes examens pour un '
                    'blitz d\'étude ou d\'écriture!'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
