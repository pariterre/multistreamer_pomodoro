import 'package:twitch_manager/models/twitch_manager_internal.dart';
import 'package:twitch_manager/models/twitch_mock_options.dart';
import 'package:twitch_manager/twitch_app_info.dart';

class TwitchInterface {
  late final TwitchAppInfo appInfo;
  final managers = <String, TwitchManager>{};
  late TwitchMockOptions mockOptions;

  static TwitchInterface get instance => _instance;

  void initialize({required TwitchAppInfo appInfo, required bool useMock}) {
    this.appInfo = appInfo;
    mockOptions = TwitchMockOptions(isActive: useMock);
  }

  List<String> get connectedStreamerIds => managers.keys.toList();

  Future<void> addStreamer(
          {required String streamerId, required TwitchManager manager}) async =>
      managers[streamerId] = manager;

  static final TwitchInterface _instance = TwitchInterface._internal();
  TwitchInterface._internal();
}
