import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/providers/auth_notifier.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/providers/category_component_items.dart';
import 'package:pomodoro/providers/category_items.dart';
import 'package:pomodoro/screens/info_screen/info_screen.dart';
import 'package:pomodoro/services/auth_methods.dart';
import 'package:pomodoro/services/storage_data.dart';
import 'package:pomodoro/utils/ThemeColor.dart';
import 'package:pomodoro/widgets/category_item.dart';
import 'package:pomodoro/widgets/digital_clock.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = '/categories';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryComponents = Provider.of<CategoryComponentItems>(context);
    final categories = Provider.of<CategoryItems>(context);
    final authMethods = Provider.of<AuthMethods>(context);
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    print(
        '${authNotifier.userDetails.avatar} ====== ${authNotifier.userDetails.userName}');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen()));
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              authNotifier.userDetails.avatar,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Hello, ${authNotifier.userDetails.userName}!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: () async {
                                String logoutType =
                                    SavingDataLocally.getAuthMethods();
                                switch (logoutType) {
                                  case 'facebook auth':
                                    await authMethods.facebookSignOut(authNotifier, context);
                                    break;
                                  case 'google auth':
                                    await authMethods.googleSignOut(context, authNotifier);
                                    print('ok');
                                    break;
                                  default:
                                    await authMethods
                                        .signOut(authNotifier, context);
                                }
                              },
                              icon: const Icon(Icons.logout)),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const DigitalClockBuilder(),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(left: 20),
                        child: Lottie.network(
                            'https://assets10.lottiefiles.com/packages/lf20_oojuetow.json'),
                      ),
                      SizedBox(
                        width: size.width * 0.00009,
                      ),
                      Text(
                        'category'.tr,
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
          }),
    );
  }
}
