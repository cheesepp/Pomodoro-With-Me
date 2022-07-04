import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class DigitalClockBuilder extends StatelessWidget {
  const DigitalClockBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return DigitalClock(
    //   showSecondsDigit: false,
    //   areaDecoration: BoxDecoration(
    //     color: Colors.transparent,
    //   ),
    //   hourMinuteDigitTextStyle: TextStyle(color: Colors.white, fontSize: 40),
    // );
    return DigitalClock(
      showSecondsDigit: false,
      areaDecoration: const BoxDecoration(color: Colors.transparent),
      areaWidth: 130,
      secondDigitDecoration: const BoxDecoration(color: Colors.transparent),
      hourMinuteDigitDecoration: const BoxDecoration(color: Colors.transparent),
      hourMinuteDigitTextStyle:
          const TextStyle(fontSize: 40, color: Colors.white70),
    );
  }
}
