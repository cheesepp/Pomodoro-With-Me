import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/screens/favorite_screen.dart';
import 'package:pomodoro/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pomodoro/screens/tasks_screen.dart';
import 'package:pomodoro/screens/time_manager_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>>? _pages;
  int _selectedPageIndex = 0;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? internetconnection;
  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(),
        'title': 'Categories',
      },
      {
        'page': FavoriteScreen(),
        'title': 'Your Favorite',
      },
      {'page': TasksScreen(), 'title': 'Tasks'}
    ];
    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:
          //  StreamBuilder(
          //     stream: Connectivity().onConnectivityChanged,
          //     builder: (context, snapshot) {
          //       // if (!snapshot.hasData)
          //       //   return Center(
          //       //     child: CircularProgressIndicator(),
          //       //   );
          //       if (snapshot.data != ConnectivityResult.wifi &&
          //           snapshot.data != ConnectivityResult.mobile) {
          //         return Center(
          //           child: Container(
          //             width: double.infinity,
          //             height: 170,
          //             child: Column(
          //               children: [
          //                 SizedBox(
          //                     width: 100,
          //                     height: 100,
          //                     child:
          //                         Lottie.asset('assets/lotties/no_connect.json')),
          //                 const SizedBox(
          //                   height: 10,
          //                 ),
          //                 Text(
          //                   'No internet connection! Please check your wifi or mobile data again!',
          //                   style: TextStyle(fontWeight: FontWeight.bold),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       }
          //       return SafeArea(child: _pages![_selectedPageIndex]['page']);
          //     }),
          SafeArea(child: _pages![_selectedPageIndex]['page']),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(offset: Offset(0, 3), blurRadius: 20),
          ],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            onTap: _selectedPage,
            backgroundColor: Colors.transparent,
            unselectedItemColor: Theme.of(context).primaryColor,
            selectedItemColor: Colors.black,
            currentIndex: _selectedPageIndex,
            // showSelectedLabels: false,
            // backgroundColor: Colors.green,
            type: BottomNavigationBarType.shifting,
            // type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  backgroundColor: Color(0xfff6f7dd),
                  icon: Icon(Icons.home),
                  label: 'Categories'),
              BottomNavigationBarItem(
                  backgroundColor: Color(0xfff6f7dd),
                  icon: Icon(Icons.favorite),
                  label: 'Favorites'),
              BottomNavigationBarItem(
                  backgroundColor: Color(0xfff6f7dd),
                  icon: Icon(Icons.check_box),
                  label: 'Todo list'),
            ],
          ),
        ),
      ),
    );
  }
}
