import 'package:flutter/material.dart';
import 'package:resto_app_v3/data/database/database_helper.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:resto_app_v3/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getResto();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<Resto> _resto = [];
  List<Resto> get resto => _resto;

  void _getResto() async {
    _resto = await databaseHelper.getResto();
    if (_resto.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Kamu belum memiliki resto favorit';
    }
    notifyListeners();
  }

  void addResto(Resto resto) async {
    try {
      await databaseHelper.insertResto(resto);
      _getResto();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarkedRestaurant = await databaseHelper.getRestoById(id);
    return bookmarkedRestaurant.isNotEmpty;
  }

  void removeResto(String id) async {
    try {
      await databaseHelper.removeResto(id);
      _getResto();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
