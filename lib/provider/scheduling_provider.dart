import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:resto_app_v3/utils/background_service.dart';
import 'package:resto_app_v3/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isActived = false;

  bool get isActived => _isActived;

  Future<bool> scheduledRestos(bool value) async {
    _isActived = value;
    if (_isActived) {
      print('Penjadwalan resto berhasil diaktifkan');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Penjadwalan resto dibatalkan');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
