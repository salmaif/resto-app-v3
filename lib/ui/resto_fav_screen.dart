import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/utils/result_state.dart';
import 'package:resto_app_v3/widgets/list_page.dart';

class RestoFavScreen extends StatelessWidget {
  const RestoFavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resto Favorit"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.resto.length,
            itemBuilder: (context, index) {
              return ListPage(
                restaurant: provider.resto[index],
              );
            },
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }
}
