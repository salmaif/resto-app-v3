import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:resto_app_v3/data/api/api_service.dart';
import 'package:resto_app_v3/data/model/resto_search.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'resto_search_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  var searchTest = {
    "error": false,
    "founded": 1,
    "restaurants": [
      {
        "id": "fnfn8mytkpmkfw1e867",
        "name": "Makan mudah",
        "description":
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
        "pictureId": "22",
        "city": "Medan",
        "rating": 3.7
      }
    ]
  };

  final client = MockClient();
  final api = ApiService(client);
  const _url = "https://restaurant-api.dicoding.dev/search?q=query";

  test('Search Feature is Working', () async {
    when(client.get(Uri.parse(_url)))
        .thenAnswer((_) async => http.Response(jsonEncode(searchTest), 200));

    expect(await api.restoSearch(_url), isA<RestoSearch>());
  });

  test('Seach Feature is Not Working', () {
    when(client.get(Uri.parse(_url)))
        .thenAnswer((_) async => http.Response('Failed to load data', 404));

    expect(api.restoSearch(_url), throwsException);
  });
}
