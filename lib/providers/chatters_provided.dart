import 'dart:convert';

import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:flutter/services.dart';
import 'package:pomo_latte_pumpkin/models/chatter.dart';
import 'package:provider/provider.dart';

class ChattersProvided extends ListProvided<Chatter> {
  ChattersProvided() {
    rootBundle.loadString('assets/data/chatters.json').then((data) {
      final chatters = json.decode(data) as Map<String, dynamic>;
      for (final chatterId in chatters.keys) {
        add(Chatter.fromSerialized(chatters[chatterId]), notify: false);
      }
      notifyListeners();
    });
  }

  static ChattersProvided of(context, {listen = true}) =>
      Provider.of<ChattersProvided>(context, listen: listen);

  @override
  Chatter deserializeItem(data) {
    return Chatter.fromSerialized(data);
  }
}
