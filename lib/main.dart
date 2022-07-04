import 'dart:async';
import 'dart:io' as io;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/providers/category_component_items.dart';
import 'package:pomodoro/providers/category_items.dart';
import 'package:pomodoro/providers/pomo_duration.dart';
import 'package:pomodoro/screens/category_components_screen.dart';
import 'package:pomodoro/screens/component_detail_screen.dart';
import 'package:pomodoro/screens/favorite_screen.dart';
import 'package:pomodoro/screens/homepage_screen.dart';
import 'package:pomodoro/screens/tab_screen.dart';
import 'package:pomodoro/screens/test.dart';
import 'package:pomodoro/screens/time_manager_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await SavingDataLocally.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext ctx) => CategoryItems(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext ctx) => CategoryComponentItems(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.brown,
              fontFamily: 'DancingScript',
              primaryColor: const Color(0xffc9ad7f),
            ),
            initialRoute: '/',
            // home: CategoriesScreen(),
            routes: {
              '/': (ctx) => const TabsScreen(),
              TimeManagerScreen.routeName: (ctx) => const TimeManagerScreen(),
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

// import 'package:flutter/material.dart';
// import 'package:simple_timer/simple_timer.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Simple Timer Widget Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   late TimerController _timerController;
//   TimerStyle _timerStyle = TimerStyle.ring;
//   TimerProgressIndicatorDirection _progressIndicatorDirection =
//       TimerProgressIndicatorDirection.clockwise;
//   TimerProgressTextCountDirection _progressTextCountDirection =
//       TimerProgressTextCountDirection.count_down;

//   @override
//   void initState() {
//     // initialize timercontroller
//     _timerController = TimerController(this);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           textAlign: TextAlign.center,
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//           child: Column(
//         children: <Widget>[
//           Expanded(
//               child: Container(
//             margin: EdgeInsets.symmetric(vertical: 10),
//             child: SimpleTimer(
//               duration: const Duration(seconds: 5),
//               controller: _timerController,
//               timerStyle: _timerStyle,
//               onStart: handleTimerOnStart,
//               onEnd: handleTimerOnEnd,
//               valueListener: timerValueChangeListener,
//               backgroundColor: Colors.black,
//               progressIndicatorColor: Colors.green,
//               progressIndicatorDirection: _progressIndicatorDirection,
//               progressTextCountDirection: _progressTextCountDirection,
//               progressTextStyle: TextStyle(color: Colors.black),
//               strokeWidth: 5,
//             ),
//           )),
//           Column(
//             children: <Widget>[
//               const Text(
//                 "Timer Status",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   TextButton(
//                       onPressed: () {
//                         if (!_timerController.isAnimating) {
//                           _timerController.start();
//                           print('o');
//                         }
//                       },
//                       child: const Text("Start",
//                           style: TextStyle(color: Colors.white)),
//                       style:
//                           TextButton.styleFrom(backgroundColor: Colors.green)),
//                   TextButton(
//                       onPressed: _timerController.pause,
//                       child: const Text("Pause",
//                           style: TextStyle(color: Colors.white)),
//                       style:
//                           TextButton.styleFrom(backgroundColor: Colors.blue)),
//                   TextButton(
//                       onPressed: _timerController.reset,
//                       child: const Text("Reset",
//                           style: TextStyle(color: Colors.white)),
//                       style: TextButton.styleFrom(backgroundColor: Colors.red)),
//                   TextButton(
//                       onPressed: _timerController.restart,
//                       child: const Text("Restart",
//                           style: TextStyle(color: Colors.white)),
//                       style:
//                           TextButton.styleFrom(backgroundColor: Colors.orange)),
//                 ],
//               )
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               const Text(
//                 "Timer Style",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Flexible(
//                       child: TextButton(
//                           onPressed: () => _setStyle(TimerStyle.ring),
//                           style: TextButton.styleFrom(
//                               backgroundColor: Colors.blue),
//                           child: const Text("Ring",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(color: Colors.white)))),
//                   Flexible(
//                     child: TextButton(
//                         onPressed: () => _setStyle(TimerStyle.expanding_circle),
//                         style:
//                             TextButton.styleFrom(backgroundColor: Colors.green),
//                         child: const Text("Expanding Circle",
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: Colors.white))),
//                   ),
//                   Flexible(
//                     child: TextButton(
//                         onPressed: () => _setStyle(TimerStyle.expanding_sector),
//                         style: TextButton.styleFrom(
//                             backgroundColor: Colors.orange),
//                         child: const Text("Expanding Sector",
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: Colors.white))),
//                   ),
//                   Flexible(
//                     child: TextButton(
//                         onPressed: () =>
//                             _setStyle(TimerStyle.expanding_segment),
//                         style:
//                             TextButton.styleFrom(backgroundColor: Colors.red),
//                         child: const Text("Expanding Segment",
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: Colors.white))),
//                   )
//                 ],
//               )
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               const Text(
//                 "Timer Count Direction",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () => _setCountDirection(
//                         TimerProgressTextCountDirection.count_up),
//                     style: TextButton.styleFrom(backgroundColor: Colors.blue),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Flexible(
//                             child: const Text("Count Up",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.white))),
//                         Flexible(
//                             child: Icon(Icons.arrow_upward,
//                                 size: 18, color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => _setCountDirection(
//                         TimerProgressTextCountDirection.count_down),
//                     style: TextButton.styleFrom(backgroundColor: Colors.orange),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Flexible(
//                             child: const Text("Count Down",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.white))),
//                         Icon(Icons.arrow_downward,
//                             size: 18, color: Colors.white),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               const Text(
//                 "Timer Progress Indicator Direction",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () => _setProgressIndicatorDirection(
//                         TimerProgressIndicatorDirection.clockwise),
//                     style: TextButton.styleFrom(backgroundColor: Colors.blue),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Flexible(
//                             child: const Text("Clockwise",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.white))),
//                         Flexible(
//                             child: Icon(Icons.subdirectory_arrow_left,
//                                 size: 18, color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => _setProgressIndicatorDirection(
//                         TimerProgressIndicatorDirection.both),
//                     style: TextButton.styleFrom(backgroundColor: Colors.green),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Flexible(
//                             child: const Text("Both",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.white))),
//                         Icon(Icons.compare_arrows,
//                             size: 18, color: Colors.white),
//                       ],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => _setProgressIndicatorDirection(
//                         TimerProgressIndicatorDirection.counter_clockwise),
//                     style: TextButton.styleFrom(backgroundColor: Colors.orange),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Flexible(
//                             child: const Text("Counter Clockwise",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(color: Colors.white))),
//                         Icon(Icons.subdirectory_arrow_right,
//                             size: 18, color: Colors.white),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ],
//       )),
//     );
//   }

//   void _setCountDirection(TimerProgressTextCountDirection countDirection) {
//     setState(() {
//       _progressTextCountDirection = countDirection;
//     });
//   }

//   void _setProgressIndicatorDirection(
//       TimerProgressIndicatorDirection progressIndicatorDirection) {
//     setState(() {
//       _progressIndicatorDirection = progressIndicatorDirection;
//     });
//   }

//   void _setStyle(TimerStyle timerStyle) {
//     setState(() {
//       _timerStyle = timerStyle;
//     });
//   }

//   void timerValueChangeListener(Duration timeElapsed) {}

//   void handleTimerOnStart() {
//     print("timer has just started");
//   }

//   void handleTimerOnEnd() {
//     print("timer has ended");
//   }
// }
