import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:multistreamer_pomodoro/models/chatter.dart';
import 'package:provider/provider.dart';

class ChattersProvided extends FirebaseListProvided<Chatter> {
  ChattersProvided() : super(pathToData: 'chatter') {
    initializeFetchingData();
  }

  static ChattersProvided of(context, {listen = false}) =>
      Provider.of<ChattersProvided>(context, listen: listen);

  @override
  Chatter deserializeItem(data) {
    return Chatter.fromSerialized(data);
  }
}
