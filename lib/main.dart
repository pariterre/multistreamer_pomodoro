import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multistreamer_pomodoro/config.dart';
import 'package:multistreamer_pomodoro/firebase_options.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/providers/chatters_provided.dart';
import 'package:multistreamer_pomodoro/providers/streamers_provided.dart';
import 'package:multistreamer_pomodoro/screens/connect_streamers_page.dart';
import 'package:multistreamer_pomodoro/screens/main_page.dart';
import 'package:provider/provider.dart';
import 'package:twitch_manager/twitch_app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Intl.defaultLocale = 'fr_CA';
  await initializeDateFormatting();

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

  runApp(const MyApp(isClientPage: true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isClientPage});

  final bool isClientPage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChattersProvided()),
        ChangeNotifierProvider(create: (context) => StreamersProvided()),
      ],
      child: MaterialApp(
        title: 'Le PomoLattePumkin-48h-Relais',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            bodyMedium: TextStyle(fontSize: 16),
          ),
          useMaterial3: true,
        ),
        routes: {
          ConnectedStreamersPage.route: (context) =>
              const ConnectedStreamersPage(),
          MainPage.route: (context) => const MainPage(),
        },
        initialRoute:
            isClientPage ? MainPage.route : ConnectedStreamersPage.route,
      ),
    );
  }
}
