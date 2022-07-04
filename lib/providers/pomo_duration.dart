// import 'dart:async';

// import 'package:duration_picker/duration_picker.dart';
// import 'package:flutter/cupertino.dart';

// class PomoDuration extends ChangeNotifier {
//   int rounds = 5;
//   int initRounds = 5;
//   Duration learningDuration = const Duration(minutes: 25);
//   Duration breakingDuration = const Duration(minutes: 5);
//   Timer? learningTimer;
//   Timer? breakingTimer;
//   String twoDigits(int n) => n.toString().padLeft(2, '0');
//   late AnimationController controller;
//   bool isMuted = false;
//   bool isPlaying = false;
//   bool isBreaking = false;
//   bool isLearningCompleted = false;
//   bool isBreakingCompleted = true;
//   Duration? _selectedDuration;
//   TextEditingController roundsController = TextEditingController();

//   void changeLearnDuration(BuildContext context, bool isLearn) async {
//     _selectedDuration = await showDurationPicker(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           color: Color(0xffEDDFB3),
//         ),
//         context: context,
//         initialTime: isLearn ? learningDuration : breakingDuration);
//     if (_selectedDuration != null) {
//       if (isLearn) {
//         learningDuration = _selectedDuration as Duration;
//         print("learning = $_selectedDuration");
//       } else {
//         breakingDuration = _selectedDuration as Duration;
//         print("breaking = $_selectedDuration");
//       }
//       notifyListeners();
//     }
//   }

//   void addTime() {
//     const subSecond = -1;
//     setState(() {
//       final seconds = learningDuration.inSeconds + subSecond;
//       if (seconds < 0) {
//         learningTimer?.cancel();
//         isBreakingCompleted = !isBreakingCompleted;
//         isLearningCompleted = !isLearningCompleted;
//         startBreak();
//         reset();
//       } else {
//         learningDuration = Duration(seconds: seconds);
//       }
//     });
//   }

//   void addBreakTime() {
//     const subSecond = -1;
//     setState(() {
//       final seconds = breakingDuration.inSeconds + subSecond;
//       if (seconds < 0) {
//         breakingTimer?.cancel();
//         isPlaying = !isPlaying;
//         isBreakingCompleted = !isBreakingCompleted;
//         isLearningCompleted = !isLearningCompleted;
//         rounds = rounds - 1;
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Color.fromARGB(255, 255, 255, 255),
//             content: Text(
//               '✧･ﾟ Yay! You have just finished ${initRounds - rounds} ${initRounds - rounds > 1 ? 'rounds' : 'round'}! Keep learning ᕦ(ò_óˇ)ᕤ',
//               style: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold),
//             )));
//         videoController!.pause();
//         resetBreak();
//       } else {
//         breakingDuration = _selectedDuration ?? const Duration(minutes: 5);
//       }
//     });
//   }

//   Widget buildTime() {
//     final minutes = twoDigits(learningDuration.inMinutes.remainder(60));
//     final seconds = twoDigits(learningDuration.inSeconds.remainder(60));
//     return Text(
//       '$minutes:$seconds',
//       style: const TextStyle(
//           fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),
//     );
//   }

//   void reset() {
//     setState(() {
//       learningDuration = _selectedDuration ?? const Duration(minutes: 25);
//     });
//   }

//   void startTimer() {
//     learningTimer =
//         Timer.periodic(const Duration(seconds: 1), (_) => addTime());
//     setState(() {
//       isBreakingCompleted = true;
//       isLearningCompleted = false;
//     });
//   }

//   Widget buildBreakTime() {
//     final minutes = twoDigits(breakingDuration.inMinutes.remainder(60));
//     final seconds = twoDigits(breakingDuration.inSeconds.remainder(60));
//     return Text(
//       '$minutes:$seconds',
//       style: const TextStyle(
//           fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),
//     );
//   }

//   void resetBreak() {
//     setState(() {
//       breakingDuration = const Duration(minutes: 5);
//     });
//   }

//   void startBreak() {
//     breakingTimer =
//         Timer.periodic(const Duration(seconds: 1), (_) => addBreakTime());
//     setState(() {
//       isPlaying = true;
//       isBreakingCompleted = false;
//       isLearningCompleted = true;
//     });
//   }

// }

import 'package:shared_preferences/shared_preferences.dart';

class SavingDataLocally {
  static SharedPreferences? _preferences;

  static const _keyLearning = 'learning';
  static const _keyBreaking = 'breaking';
  static const _keyRounds = 'rounds';
  static const _keyLearnedMonday = 'monday';
  static const _keyLearnedTuesday = 'tuesday';
  static const _keyLearnedWednesday = 'wednesday';
  static const _keyLearnedThursday = 'thursday';
  static const _keyLearnedFriday = 'friday';
  static const _keyLearnedSaturday = 'saturday';
  static const _keyLearnedSunday = 'sunday';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLearningDuration(int learningDuration) async =>
      await _preferences!.setInt(_keyLearning, learningDuration);

  static Future setBreakingDuration(int breakingDuration) async =>
      await _preferences!.setInt(_keyBreaking, breakingDuration);

  static Future setRounds(int rounds) async =>
      await _preferences!.setInt(_keyRounds, rounds);

  static Future setSecondsLearned(int secondsLearned, String day) async {
    if (day == 'Monday')
      await _preferences!.setInt(_keyLearnedMonday, secondsLearned);
    if (day == 'Tuesday')
      await _preferences!.setInt(_keyLearnedTuesday, secondsLearned);
    if (day == 'Wednesday')
      await _preferences!.setInt(_keyLearnedWednesday, secondsLearned);
    if (day == 'Thursday')
      await _preferences!.setInt(_keyLearnedThursday, secondsLearned);
    if (day == 'Friday')
      await _preferences!.setInt(_keyLearnedFriday, secondsLearned);
    if (day == 'Saturday')
      await _preferences!.setInt(_keyLearnedSaturday, secondsLearned);
    if (day == 'Sunday')
      await _preferences!.setInt(_keyLearnedSunday, secondsLearned);
  }

  static getSecondsLearned(String day) {
    if (day == 'Monday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedMonday) ?? 0;
      learnedOnMonday(seconds: secondsLearned);
    }
    if (day == 'Tuesday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedTuesday) ?? 0;
      learnedOnTuesday(seconds: secondsLearned);
    }
    if (day == 'Wednesday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedWednesday) ?? 0;
      learnedOnWednesday(seconds: secondsLearned);
    }
    if (day == 'Thursday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedThursday) ?? 0;
      learnedOnThursday(seconds: secondsLearned);
    }
    if (day == 'Friday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedFriday) ?? 0;
      learnedOnFriday(seconds: secondsLearned);
    }
    if (day == 'Saturday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedSaturday) ?? 0;
      learnedOnSaturday(seconds: secondsLearned);
    }
    if (day == 'Sunday') {
      final secondsLearned = _preferences!.getInt(_keyLearnedSunday) ?? 0;
      learnedOnSunday(seconds: secondsLearned);
    }
  }

  static double learnedOnMonday({int seconds = 2}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnTuesday({int seconds = 3}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnWednesday({int seconds = 4}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnThursday({int seconds = 5}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnFriday({int seconds = 6}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnSaturday({int seconds = 7}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static double learnedOnSunday({int seconds = 8}) {
    final minutes = seconds % 60;
    final hours = minutes % 60;
    return minutes.toDouble();
  }

  static int getLearningDuration() => _preferences!.getInt(_keyLearning) ?? 25;

  static int getBreakingDuration() => _preferences!.getInt(_keyBreaking) ?? 5;

  // static Future setBreaking(List<String> ) async =>
  //     await _preferences!.setStringList(_keyBreaking, pets);

  static int getRounds() => _preferences!.getInt(_keyRounds) ?? 5;
}
