import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's chosen app language locally and exposes it to MaterialApp.
/// Only the locale tag is persisted here.
class LanguageController extends ChangeNotifier {
  LanguageController();

  static const String _storageKey = 'deglitch.appLocale';

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('kri'),
    Locale('ru'),
    Locale('fr'),
    Locale('es'),
  ];

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTag = prefs.getString(_storageKey);
    final savedLocale = savedTag == null ? null : localeFromTag(savedTag);
    if (savedLocale != null) {
      _locale = savedLocale;
      notifyListeners();
    }
  }

  /// Applies the new locale immediately and saves it for the next launch.
  Future<void> setLocale(Locale locale) async {
    final normalised = _normaliseSupportedLocale(locale);
    if (normalised == null) {
      throw ArgumentError.value(
        locale,
        'locale',
        'Unsupported DēGlitch locale',
      );
    }
    if (_locale == normalised) return;

    _locale = normalised;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, localeTag(normalised));
  }

  static Locale? localeFromTag(String tag) {
    switch (tag) {
      case 'en':
        return const Locale('en');
      case 'zh-Hans':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      case 'kri':
        return const Locale('kri');
      case 'ru':
        return const Locale('ru');
      case 'fr':
        return const Locale('fr');
      case 'es':
        return const Locale('es');
      default:
        return null;
    }
  }

  static String localeTag(Locale locale) {
    if (locale.languageCode == 'zh') return 'zh-Hans';
    return locale.languageCode;
  }

  static Locale? _normaliseSupportedLocale(Locale locale) {
    return localeFromTag(localeTag(locale));
  }

  static String languageLabel(Locale locale) {
    switch (localeTag(locale)) {
      case 'en':
        return 'English';
      case 'zh-Hans':
        return '简体中文';
      case 'kri':
        return 'Krio';
      case 'ru':
        return 'Russian';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }
}
