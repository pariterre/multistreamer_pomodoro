import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:multistreamer_pomodoro/models/streamer.dart';
import 'package:provider/provider.dart';

class StreamersProvided extends FirebaseListProvided<Streamer> {
  StreamersProvided() : super(pathToData: 'streamers') {
    initializeFetchingData();
  }

  static StreamersProvided of(context, {listen = true}) =>
      Provider.of<StreamersProvided>(context, listen: listen);

  @override
  Streamer deserializeItem(data) {
    return Streamer.fromSerialized(data);
  }
}
