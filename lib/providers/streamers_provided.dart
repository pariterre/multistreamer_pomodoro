import 'dart:convert';

import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:flutter/services.dart';
import 'package:pomo_latte_pumpkin/models/streamer.dart';
import 'package:provider/provider.dart';

class StreamersProvided extends ListProvided<Streamer> {
  StreamersProvided() {
    rootBundle.loadString('assets/data/streamers.json').then((data) {
      final streamers = json.decode(data) as Map<String, dynamic>;
      for (final streamerId in streamers.keys) {
        add(Streamer.fromSerialized(streamers[streamerId]), notify: false);
      }
      notifyListeners();
    });
  }

  static StreamersProvided of(context, {listen = true}) =>
      Provider.of<StreamersProvided>(context, listen: listen);

  @override
  Streamer deserializeItem(data) {
    return Streamer.fromSerialized(data);
  }
}
