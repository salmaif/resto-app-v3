import 'package:flutter/material.dart';
import 'package:resto_app_v3/ui/resto_detail_screen.dart';
import 'package:resto_app_v3/ui/resto_fav_screen.dart';
import 'package:resto_app_v3/ui/resto_list_screen.dart';
import 'package:resto_app_v3/ui/setting_screen.dart';
import 'package:resto_app_v3/utils/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  int _bottomNavIndex = 0;

  static const String _homeScreenText = 'Beranda';
  static const String _favScreenText = 'Favorit';
  static const String _settingScreenText = 'Pengaturan';

  final List<Widget> _list = [
    const RestoListScreen(),
    const RestoFavScreen(),
    const SettingScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded),
      label: _homeScreenText,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite_rounded),
      label: _favScreenText,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded),
      label: _settingScreenText,
    ),
  ];

  void _onBottomNavTaped(int index) {
    setState(
      () {
        _bottomNavIndex = index;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestoDetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _list[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        onTap: _onBottomNavTaped,
        currentIndex: _bottomNavIndex,
      ),
    );
  }
}
