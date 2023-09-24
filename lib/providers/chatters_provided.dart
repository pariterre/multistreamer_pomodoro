import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:pomo_latte_pumpkin/models/chatter.dart';
import 'package:provider/provider.dart';

class ChattersProvided extends FirebaseListProvided<Chatter> {
  ChattersProvided() : super(pathToData: 'chatter') {
    initializeFetchingData();
  }

  static ChattersProvided of(context, {listen = true}) =>
      Provider.of<ChattersProvided>(context, listen: listen);

  @override
  Chatter deserializeItem(data) {
    return Chatter.fromSerialized(data);
  }
}
