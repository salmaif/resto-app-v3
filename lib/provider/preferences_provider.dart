import 'package:flutter/material.dart';
import 'package:resto_app_v3/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRestoPreferences();
  }

  bool _isDailyRestoActive = false;
  bool get isDailyRestoActive => _isDailyRestoActive;

  void _getDailyRestoPreferences() async {
    _isDailyRestoActive = await preferencesHelper.isDailyRestoActive;
    notifyListeners();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyResto(value);
    _getDailyRestoPreferences();
  }
}
