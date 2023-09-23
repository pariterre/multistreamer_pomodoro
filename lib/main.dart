import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/config.dart';
import 'package:multistreamer_pomodoro/firebase_options.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/screens/connect_streamers_page.dart';
import 'package:multistreamer_pomodoro/screens/show_participants_page.dart';
import 'package:provider/provider.dart';
import 'package:twitch_manager/twitch_app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  TwitchInterface.instance.initialize(
    appInfo: TwitchAppInfo(
      appName: twitchAppName,
      twitchAppId: twitchAppId,
      redirectAddress: twitchRedirect,
      scope: twitchScope,
      useAuthenticationService: true,
      authenticationServiceAddress: authenticationServiceAddress,
    ),
    useMock: false,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChattersProvided()),
        ],
        child: MaterialApp(
          title:
              'Participant\u2022e\u2022s du 48h Spicy Pumpkin Pomodoro Relais',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
            ConnectedStreamersPage.route: (context) =>
                const ConnectedStreamersPage(),
            ShowParticipantsPage.route: (context) =>
                const ShowParticipantsPage(),
          },
          initialRoute: ConnectedStreamersPage.route,
        ));
  }
}
