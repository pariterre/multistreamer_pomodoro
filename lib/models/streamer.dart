import 'package:enhanced_containers/enhanced_containers.dart';

class Streamer extends ItemSerializable {
  final String streamerId;
  final String name;

  Streamer({required this.streamerId, required this.name});

  Streamer.fromSerialized(map)
      : streamerId = map['streamerId'],
        name = map['name'],
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() => {
        'id': id,
        'streamerId': streamerId,
        'name': name,
      };
}
