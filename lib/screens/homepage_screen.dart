import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/providers/category_component_items.dart';
import 'package:pomodoro/providers/category_items.dart';
import 'package:pomodoro/widgets/category_item.dart';
import 'package:pomodoro/widgets/digital_clock.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/categories';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryComponents = Provider.of<CategoryComponentItems>(context);
    final categories = Provider.of<CategoryItems>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
          future: categoryComponents.getCategoriesCollectionFromFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text('Oh no'),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(top: 60),
                // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const DigitalClockBuilder()),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(left: 20),
                        child: Lottie.network(
                            'https://assets10.lottiefiles.com/packages/lf20_oojuetow.json'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: GridView.builder(
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: categories.categoryData.length,
                          itemBuilder: (context, index) {
                            // create: (ctx) => products[index]
                            return CategoryItem(
                              id: categories.categoryData[index].id,
                              image:
                                  categories.categoryData[index].categoryImage,
                              name: categories.categoryData[index].category,
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            //  else {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
          }),
    );
  }
}
