import 'package:flutter/material.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/models/chatter.dart';
import 'package:pomo_latte_pumpkin/providers/chatters_provided.dart';
import 'package:pomo_latte_pumpkin/widgets/animated_expanding_card.dart';
import 'package:pomo_latte_pumpkin/widgets/tab_container.dart';

class ViewersPage extends StatelessWidget {
  const ViewersPage(
      {super.key,
      required this.isInitialized,
      required this.isServer,
      required this.maxWidth});

  final double maxWidth;
  final bool isInitialized;
  final bool isServer;

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      maxWidth: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AUDITEURS ET AUDITRICES',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildChattersListTile(context),
        ],
      ),
    );
  }

  Widget _buildChattersListTile(BuildContext context) {
    final chatters = ChattersProvided.of(context);
    final sortedChatters = [...chatters]
      ..sort((a, b) => b.totalWatchingTime - a.totalWatchingTime);

    return !isEventStarted && !isServer
        ? const Text(
            'Lors de l\'événement, votre temps de participation sera enregistré ici!'
            'Revenez régulièrement sur cette page pour vous comparer aux autres participantes et participants ;-)')
        : !isInitialized
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : (sortedChatters.isEmpty
                ? const Text('Aucun auditeur ou auditrice pour l\'instant')
                : Column(
                    children: sortedChatters
                        .map(
                            (e) => _ChatterTile(chatter: e, isServer: isServer))
                        .toList()));
  }
}

class _ChatterTile extends StatelessWidget {
  const _ChatterTile({required this.chatter, required this.isServer});

  final Chatter chatter;
  final bool isServer;

  @override
  Widget build(BuildContext context) {
    return chatter.isEmpty || (chatter.isBanned && !isServer)
        ? Container()
        : AnimatedExpandingCard(
            expandedColor: chatter.isBanned ? Colors.white : selectedColor,
            closedColor: chatter.isBanned ? Colors.white : unselectedColor,
            header: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatter.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                      'Participation : ${chatter.totalWatchingTime ~/ 30} minutes'),
                  if (isServer)
                    InkWell(
                      onTap: () {
                        final chatters =
                            ChattersProvided.of(context, listen: false);
                        chatter.isBanned = !chatter.isBanned;
                        chatters.add(chatter);
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        height: 40,
                        width: 40,
                        child: Icon(
                            chatter.isBanned ? Icons.person_off : Icons.person),
                      ),
                    )
                ],
              ),
            ),
            builder: (context, isExpanded) => isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Par chaîne',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...chatter.streamerNames.map((streamer) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(streamer),
                                Text(
                                    '${chatter.watchingTime(of: streamer) ~/ 30} minutes'),
                              ],
                            )),
                      ],
                    ),
                  )
                : Container(),
          );
  }
}
