import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/data/model/resto_list.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/ui/resto_detail_screen.dart';

class ListPage extends StatelessWidget {
  final Resto restaurant;
  const ListPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RestoDetailScreen.routeName,
                    arguments: restaurant.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Hero(
                    tag: restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/" +
                            restaurant.pictureId,
                        width: 90,
                      ),
                    ),
                  ),
                  title: Text(
                    restaurant.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(restaurant.city),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text('${restaurant.rating}')
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider()
                    ],
                  ),
                  trailing: isBookmarked
                      ? IconButton(
                          onPressed: () => provider.removeResto(restaurant.id),
                          icon: const Icon(Icons.favorite_rounded),
                          color: Colors.red[400],
                        )
                      : IconButton(
                          onPressed: () => provider.addResto(restaurant),
                          icon: const Icon(Icons.favorite_rounded),
                          color: Colors.grey[400],
                        ),
                ),
              ),
            );
          });
    });
  }
}
