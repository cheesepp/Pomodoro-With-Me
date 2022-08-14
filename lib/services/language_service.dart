import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/language/en.dart';
import '../utils/language/vi.dart';

class I18nService extends Translations {
  static SharedPreferences? _preference;
  String _languageKey = 'lang';
  String _langTextKey = 'vi';
  static const fallbackLocale = Locale('en', 'US');

  static final Map<String, Locale> locales = {
    'vi': const Locale('vi', 'VN'),
    'en': const Locale('en', 'US'),
  };

  static Future init() async {
    _preference = await SharedPreferences.getInstance();
  }

  Locale get locale => _loadFromStorage();

  Locale _loadFromStorage() {
    String? value = _preference!.getString(_languageKey);

    value ??= Get.deviceLocale?.languageCode;

    return locales[value] ?? fallbackLocale;
  }

  setTextLang(String text) => _preference!.setString(_langTextKey, text);
  getTextLang() => _preference!.getString(_langTextKey);

  Future setLanguage(String lang) async {
    await _preference!.setString(_languageKey, lang);
  }

  void changeLocale(String lang) {
    final locale = locales[lang] ?? fallbackLocale;

    Get.updateLocale(locale);

    setLanguage(lang);
  }

  void syncToSystem() {
    String? systemLanguageCode = Get.deviceLocale?.languageCode;

    if (systemLanguageCode != null) {
      changeLocale(systemLanguageCode);
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'vi_VN': vi,
    'en_US': en,
  };
}
