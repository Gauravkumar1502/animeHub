import 'package:animexhub/models/ani_pic.dart';
import 'package:animexhub/models/settings.dart';
import 'package:animexhub/services/hive_service_factory.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings = const Settings(
    shouldRemember: false,
    themeMode: Mode.system,
    rating: Rating.safe,
    tags: [],
  );

  late final Box<Settings> _settingsBoxFuture;
  bool isLoading = true;
  bool _isVisible = true;

  bool get isVisible => _isVisible;
  void setIsVisible(bool isVisible) {
    _isVisible = isVisible;
    notifyListeners();
  }

  Settings get settings => _settings;
  ThemeMode get themeMode => _settings.themeModeAsFlutterThemeMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settingsBoxFuture = await HiveServiceFactory.getBox<Settings>(
      'settingsBox',
    );
    _settings = _settingsBoxFuture.get('settings') ?? _settings;
    debugPrint('Settings: ${_settings.shouldRemember}');
    debugPrint('Settings: ${_settings.rating}');
    debugPrint('Settings: ${_settings.tags}');
    debugPrint('Settings: ${_settings.themeMode}');
    Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> setShouldRemember(bool shouldRemember) async {
    _settings = _settings.copyWith(shouldRemember: shouldRemember);
    await _settingsBoxFuture.put('settings', _settings);
    notifyListeners();
  }

  Future<void> setThemeMode(Mode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _settingsBoxFuture.put('settings', _settings);
    notifyListeners();
  }

  Future<void> setRating(Rating rating) async {
    _settings = _settings.copyWith(rating: rating);
    if (_settings.shouldRemember) {
      await _settingsBoxFuture.put('settings', _settings);
    }
    notifyListeners();
  }

  Future<void> setTags(List<String> tags) async {
    _settings = _settings.copyWith(tags: tags);
    if (_settings.shouldRemember) {
      await _settingsBoxFuture.put('settings', _settings);
    }
    notifyListeners();
  }

  Future<void> resetSettings() async {
    _settings = const Settings(
      shouldRemember: false,
      themeMode: Mode.system,
      rating: Rating.safe,
      tags: [],
    );
    await _settingsBoxFuture.put('settings', _settings);
    notifyListeners();
  }
}
