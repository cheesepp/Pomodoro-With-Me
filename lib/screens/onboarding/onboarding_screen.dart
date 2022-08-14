import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pomodoro/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../auth_screen/auth_screen.dart';
import 'data/pages_view.dart';
import 'model/page_view_model.dart';

class Onboarding {
  static SharedPreferences? _preferences;
  static const _isOnboardingKey = 'isOnboarding';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static setOnboardingData({bool check = false}) {
    _preferences!.setBool(_isOnboardingKey, check);
  }

  static bool? getOnboardingData() => _preferences!.getBool(_isOnboardingKey);
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Theme.of(context).primaryColor,
      pages: pages.map((page) => buildPageView(page)).toList(),
      onDone: () {
        Onboarding.setOnboardingData();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            AuthScreen()), (Route<dynamic> route) => false);
      },
      showBackButton: true,
      back: const Icon(
        Icons.arrow_back_sharp,
        color: Colors.black,
      ),
      skip: const Text("Skip",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      next: const Icon(Icons.arrow_forward_outlined, color: Colors.black),
      done: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text("Get Started!",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.black,
        color: Colors.black38,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  PageViewModel buildPageView(OnboardingPageView page) {
    return PageViewModel(
      title: "",
      bodyWidget: SizedBox(
        height: Get.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 6,
              child: Image.asset(
                page.image,
                height: Get.height * 0.4,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3 / 2),
                  SizedBox(
                    width: Get.width * 0.8,
                    child: Text(
                      page.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
