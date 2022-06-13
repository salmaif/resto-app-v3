import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/provider/preferences_provider.dart';
import 'package:resto_app_v3/provider/scheduling_provider.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting-screen';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return ListTile(
          title: const Text('Penjadwalan Resto'),
          trailing: Consumer<SchedulingProvider>(
            builder: (context, scheduled, _) {
              return Switch.adaptive(
                value: provider.isDailyNewsActive,
                onChanged: (value) async {
                  scheduled.scheduledRestos(value);
                  provider.enableDailyNews(value);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
