import 'package:flutter/foundation.dart';
import 'package:resto_app_v3/data/api/api_service.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:resto_app_v3/utils/result_state.dart';

class RestoListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestoListProvider({required this.apiService}) {
    fetchRestoList();
  }

  ResultState? _state;
  RestoList? _list;
  String _message = '';

  ResultState? get state => _state;
  RestoList? get result => _list;
  String get message => _message;

  Future<dynamic> fetchRestoList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final resto = await apiService.restoList();
      if (resto.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _list = resto;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Gagal memuat data';
    }
  }
}
