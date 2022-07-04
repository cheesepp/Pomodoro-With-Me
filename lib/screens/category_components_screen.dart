import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/providers/category_component_items.dart';
import 'package:pomodoro/widgets/category_component_item.dart';
import 'package:pomodoro/widgets/digital_clock.dart';
import 'package:provider/provider.dart';

import '../providers/category.dart';

class CategoryComponentsScreen extends StatefulWidget {
  static const routeName = '/category_components';
  const CategoryComponentsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryComponentsScreen> createState() =>
      _CategoryComponentsScreenState();
}

class _CategoryComponentsScreenState extends State<CategoryComponentsScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryComponents = Provider.of<CategoryComponentItems>(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final displayedComponents =
        categoryComponents.fetchComponentsByCategory(routeArgs['category']);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20),
                height: 100,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 14),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.network(routeArgs['icon'])),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          routeArgs['name'],
                          style: const TextStyle(
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
              Expanded(
                child: ListView.separated(
                    separatorBuilder: ((context, index) => const SizedBox(
                          height: 20,
                        )),
                    itemCount: displayedComponents.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                        value: displayedComponents[index],
                        child: CategoryComponentItem(),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
