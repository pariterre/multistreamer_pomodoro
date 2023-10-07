import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/models/chatter.dart';
import 'package:pomo_latte_pumpkin/providers/chatters_provided.dart';
import 'package:pomo_latte_pumpkin/widgets/tab_container.dart';

class PrizePage extends StatefulWidget {
  const PrizePage({super.key, required this.maxWidth});

  final double maxWidth;

  @override
  State<PrizePage> createState() => _PrizePageState();
}

class _PrizePageState extends State<PrizePage> {
  final nbParticipantsToDraw = TextEditingController();

  @override
  void dispose() {
    nbParticipantsToDraw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatters = ChattersProvided.of(context);

    if (chatters.isEmpty) {
      return TabContainer(
          maxWidth: widget.maxWidth,
          child: const Text('Aucun auditeur ou auditrice pour l\'instant'));
    }

    const border = InputBorder.none;

    return TabContainer(
        maxWidth: widget.maxWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: selectedColor, borderRadius: BorderRadius.circular(8)),
              width: 290,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 12, bottom: 8, right: 8),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: nbParticipantsToDraw,
                  decoration: const InputDecoration(
                    border: border,
                    errorBorder: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    disabledBorder: border,
                    focusedErrorBorder: border,
                    isDense: false,
                    label: Text(
                      'Tirer un nom parmi les X premiers',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  int? nbParticipants = int.tryParse(nbParticipantsToDraw.text);
                  nbParticipants ??= chatters.length;

                  _drawViewer(nbParticipants);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    foregroundColor: Colors.white),
                child: const Text('Tirer au sort!')),
          ],
        ));
  }

  void _drawViewer(int nbParticipants) {
    final chatters = ChattersProvided.of(context, listen: false);
    final sortedChatters = [...chatters]
      ..sort((a, b) => b.totalWatchingTime - a.totalWatchingTime);

    Chatter? winner;
    while (winner == null) {
      final winnerIndex =
          Random().nextInt(min(nbParticipants, chatters.length));
      winner = sortedChatters[winnerIndex];
      if (winner.isBanned || winner.totalWatchingTime ~/ 30 < 100) {
        winner = null;
      }
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: selectedColor,
              title: const Text(
                'Gagnants',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                  '${winner!.name} (Temps de visionnement : ${winner.totalWatchingTime ~/ 30} minutes})'),
            ));
  }
}
