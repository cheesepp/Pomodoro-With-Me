import 'package:shared_preferences/shared_preferences.dart';

class SavingDataLocally {
  static SharedPreferences? _preferences;

  static const _isLogin = "isLogin";
  static const _logOutType = "logout";

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

  static Future setAuthMethods(String logoutType) async =>
      await _preferences!.setString(_logOutType, logoutType);

  static getAuthMethods() => _preferences!.getString(_logOutType);

  static Future setLogin({bool isLogin = true}) async =>
      await _preferences!.setBool(_isLogin, isLogin);
  static bool? getLogin() => _preferences!.getBool(_isLogin);

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
