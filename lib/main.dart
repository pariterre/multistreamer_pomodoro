import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pomo_latte_pumpkin/config.dart';
import 'package:pomo_latte_pumpkin/models/twitch_interface.dart';
import 'package:pomo_latte_pumpkin/providers/chatters_provided.dart';
import 'package:pomo_latte_pumpkin/providers/streamers_provided.dart';
import 'package:pomo_latte_pumpkin/screens/connect_streamers_page.dart';
import 'package:pomo_latte_pumpkin/screens/main_page.dart';
import 'package:provider/provider.dart';
import 'package:twitch_manager/twitch_app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MyApp(isServer: false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isServer});

  final bool isServer;

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
          textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'BebasNeue',
                fontSize: 28),
            titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'BebasNeue',
                fontSize: 20),
            titleSmall: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'BebasNeue',
                fontSize: 18),
            bodyMedium: TextStyle(
                color: Colors.white, fontFamily: 'Nirmala', fontSize: 16),
          ),
          useMaterial3: true,
        ),
        routes: {
          ConnectedStreamersPage.route: (context) =>
              const ConnectedStreamersPage(),
          MainPage.route: (context) => MainPage(isServer: isServer),
        },
        initialRoute: isServer ? ConnectedStreamersPage.route : MainPage.route,
      ),
    );
  }
}
