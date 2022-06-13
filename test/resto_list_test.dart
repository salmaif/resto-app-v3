import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:resto_app_v3/data/api/api_service.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:resto_app_v3/provider/resto_list_provider.dart';

import 'resto_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  var listRestaurantTest = {
    "id": "s1knt6za9kkfw1e867",
    "name": "Kafe Kita",
    "description":
        "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,",
    "pictureId": "25",
    "city": "Gorontalo",
    "rating": 4
  };

  // ignore: non_constant_identifier_names
  String ListRestaurantResponse = '''
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

  final client = MockClient();
  test('List Restaurant Success', () async {
    when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
        .thenAnswer((_) async => http.Response(ListRestaurantResponse, 200));
    RestoListProvider providerList =
        RestoListProvider(apiService: ApiService(client));
    await providerList.fetchRestoList();
    var nameTest = providerList.result.restaurants[1].name ==
        Resto.fromJson(listRestaurantTest).name;
    var cityTest = providerList.result.restaurants[1].city ==
        Resto.fromJson(listRestaurantTest).city;
    expect(nameTest, true);
    expect(cityTest, true);
  });
  test('List Restaurant Error', () async {
    when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
        .thenAnswer((_) async => http.Response(ListRestaurantResponse, 200));
    RestoListProvider providerList =
        RestoListProvider(apiService: ApiService(client));
    await providerList.fetchRestoList();
    var pictureIdTest = providerList.result.restaurants[0].pictureId ==
        Resto.fromJson(listRestaurantTest).pictureId;
    var ratingTest = providerList.result.restaurants[0].rating ==
        Resto.fromJson(listRestaurantTest).rating;
    expect(pictureIdTest, false);
    expect(ratingTest, false);
  });
}
