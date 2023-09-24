import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/main.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';

class ViewersPage extends StatelessWidget {
  const ViewersPage({super.key, required this.isInitialized});

  final bool isInitialized;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // TODO font style
          'AUDITEURS ET AUDITRICES',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Expanded(child: _buildChattersListTile(context)),
      ],
    );
  }

  Widget _buildChattersListTile(BuildContext context) {
    final chatters = ChattersProvided.of(context);
    final sortedChatters = [...chatters]
      ..sort((a, b) => b.totalWatchingTime - a.totalWatchingTime);

    return isInitialized
        ? (chatters.isEmpty
            ? const Text('Aucun auditeur ou auditrice pour l\'instant')
            : ListView.builder(
                itemCount: sortedChatters.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: _ChatterTile(chatter: sortedChatters[index]),
                ),
              ))
        : const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class _ChatterTile extends StatelessWidget {
  const _ChatterTile({required this.chatter});

  final Chatter chatter;

  @override
  Widget build(BuildContext context) {
    return chatter.isEmpty
        ? Container()
        : Card(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: selectedColor, borderRadius: BorderRadius.circular(8)),
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatter.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...chatter.streamerNames.map((streamer) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(streamer),
                                Text(
                                    '${chatter.watchingTime(of: streamer) ~/ 60} minutes'),
                              ],
                            )),
                        const SizedBox(width: 80, child: Divider()),
                        Text('${chatter.totalWatchingTime ~/ 60} minutes'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
