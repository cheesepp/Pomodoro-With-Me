import 'dart:async';
import 'dart:io' as io;
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pomodoro/providers/auth_notifier.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/providers/category_component_items.dart';
import 'package:pomodoro/providers/category_items.dart';
import 'package:pomodoro/providers/handle_tasks.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/screens/auth_screen/auth_screen.dart';
import 'package:pomodoro/services/auth_methods.dart';
import 'package:pomodoro/services/firebase_services.dart';
import 'package:pomodoro/services/language_service.dart';
import 'package:pomodoro/services/storage_data.dart';
import 'package:pomodoro/screens/category_components_screen.dart';
import 'package:pomodoro/screens/component_detail_screen.dart';
import 'package:pomodoro/screens/favorite_screen.dart';
import 'package:pomodoro/screens/homepage_screen.dart';
import 'package:pomodoro/screens/onboarding/onboarding_screen.dart';
import 'package:pomodoro/screens/tab_screen.dart';
import 'package:pomodoro/screens/tasks_screen.dart';
import 'package:pomodoro/screens/time_manager_screen.dart';
import 'package:pomodoro/utils/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await SavingDataLocally.init();
  await Onboarding.init();
  await I18nService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers:[ (ChangeNotifierProvider(
        create: (BuildContext ctx) => AuthNotifier())),
      (ChangeNotifierProvider(
          create: (BuildContext ctx) => ThemeNotifier(beigeTheme))),
  ],
  child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext ctx) => HandleTasks(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext ctx) => CategoryComponentItems(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext ctx) => CategoryItems(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext ctx) => AuthMethods(),
          ),
          ChangeNotifierProxyProvider<CategoryComponentItems, FirebaseService>(
              create: (context) => FirebaseService(items: []),
              update: (context, items, firebase) {
                return FirebaseService(items: items.items);
              }),
        ],
        child: GetMaterialApp(
            useInheritedMediaQuery: true,
            translations: I18nService(),
            locale: I18nService().locale,
            fallbackLocale: I18nService.fallbackLocale,
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            // theme: ThemeData(
            //   fontFamily: 'DancingScript',
            //
            // ),

            theme: themeNotifier.getTheme(),
            initialRoute: '/',
            // home: CategoriesScreen(),
            routes: {
              '/': (ctx) => Onboarding.getOnboardingData() ?? false
                  ? SavingDataLocally.getLogin() ?? false
                      ? const TabsScreen()
                      : const AuthScreen()
                  : const OnboardingScreen(),

              TasksScreen.routeName: (ctx) => const TasksScreen(),
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              FavoriteScreen.routeName: (context) => const FavoriteScreen(),
              CategoryComponentsScreen.routeName: (context) =>
                  const CategoryComponentsScreen(),
              // ComponentDetailScreen.routeName: (context) =>
              //     const ComponentDetailScreen(),
            },
            onGenerateRoute: (settings) {
              print(settings.arguments);
              // return MaterialPageRoute(builder: (context) => CategoriesScreen());
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            }));
  }
}
