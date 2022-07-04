import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/widgets/category_component_item.dart';
import 'package:pomodoro/widgets/digital_clock.dart';
import 'package:pomodoro/widgets/favorite_components.dart';
import 'package:provider/provider.dart';

import '../providers/category_component_items.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite-musics';
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    final categoryComponents = Provider.of<CategoryComponentItems>(context);
    final showFavoriteComponents = categoryComponents.fetchFavoriteComponents();
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60, left: 20),
              height: 150,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigitalClockBuilder(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        child: Lottie.network(
                            'https://assets6.lottiefiles.com/packages/lf20_if77rL.json',
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Favorites',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemCount: showFavoriteComponents.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: showFavoriteComponents[index],
                    child: FavoriteComponentItem(),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
