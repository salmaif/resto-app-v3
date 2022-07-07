import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:rxdart/subjects.dart';
import 'package:resto_app_v3/common/navigation.dart';

late int rand;
final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestoList restoList) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "Resto App";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    var titleNotification = "<b>Resto hari ini</b>";
    rand = Random().nextInt(restoList.restaurants.length);
    var titleResto = restoList.restaurants[rand].name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleResto, platformChannelSpecifics,
        payload: json.encode(restoList.restaurants[rand].toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestoList.fromJson(json.decode(payload));
        Navigation.intentWithData(route, data.restaurants[rand].id.toString());
      },
    );
  }
}
