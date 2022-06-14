import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:resto_app_v3/data/api/api_service.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:resto_app_v3/provider/resto_list_provider.dart';

import 'resto_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  var response = '''
  {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
          {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
          },
          {
              "id": "s1knt6za9kkfw1e867",
              "name": "Kafe Kita",
              "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
              "pictureId": "25",
              "city": "Gorontalo",
              "rating": 4
          }
      ]
  }
  ''';

  var restoListTest = {
    "id": "rqdv5juczeskfw1e867",
    "name": "Melting Pot",
    "description":
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
    "pictureId": "14",
    "city": "Medan",
    "rating": 4.2
  };

  const _url = "https://restaurant-api.dicoding.dev/list";
  final client = MockClient();

  test(
    'Resto List Test Success',
    () async {
      when(
        client.get(
          Uri.parse(_url),
        ),
      ).thenAnswer(
        (_) async => http.Response(response, 200),
      );
      RestoListProvider restoListProvider =
          RestoListProvider(apiService: ApiService(client));
      await restoListProvider.fetchRestoList();
      var nameTest = restoListProvider.result.restaurants[0].name ==
          Resto.fromJson(restoListTest).name;
      expect(nameTest, true);
    },
  );

  test(
    'Resto List Test Error',
    () async {
      when(
        client.get(
          Uri.parse(_url),
        ),
      ).thenAnswer(
        (_) async => http.Response(response, 404),
      );
      RestoListProvider restoListProvider =
          RestoListProvider(apiService: ApiService(client));
      await restoListProvider.fetchRestoList();
      var nameTest = restoListProvider.result.restaurants[1].name ==
          Resto.fromJson(restoListTest).name;
      expect(nameTest, false);
    },
  );
}
