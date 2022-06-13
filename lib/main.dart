import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/common/navigation.dart';
import 'package:resto_app_v3/data/api/api_service.dart';
import 'package:resto_app_v3/data/database/database_helper.dart';
import 'package:resto_app_v3/data/preferences/preferences_helper.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/provider/preferences_provider.dart';
import 'package:resto_app_v3/provider/resto_list_provider.dart';
import 'package:resto_app_v3/provider/scheduling_provider.dart';
import 'package:resto_app_v3/ui/home_screen.dart';
import 'package:resto_app_v3/ui/resto_detail_screen.dart';
import 'package:resto_app_v3/ui/resto_search_screen.dart';
import 'package:resto_app_v3/ui/setting_screen.dart';
import 'package:resto_app_v3/utils/background_service.dart';
import 'package:resto_app_v3/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestoListProvider(
            apiService: ApiService(Client()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resto App v3',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: AnimatedSplashScreen(
          splash: Image.asset(
            'images/restaurant.png',
          ),
          backgroundColor: Colors.brown,
          duration: 1500,
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: const HomeScreen(),
        ),
        routes: {
          RestoDetailScreen.routeName: (context) => RestoDetailScreen(
                name: ModalRoute.of(context)?.settings.arguments as String,
              ),
          RestoSearchScreen.routeName: (context) => const RestoSearchScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
        },
      ),
    );
  }
}
