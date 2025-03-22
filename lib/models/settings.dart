import 'package:animexhub/models/ani_pic.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
enum Mode {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}

@immutable
@HiveType(typeId: 2)
class Settings {
  @HiveField(0)
  final bool shouldRemember;
  @HiveField(1)
  final Mode themeMode;
  @HiveField(2)
  final Rating rating;
  @HiveField(3)
  final List<String> tags;

  const Settings({
    required this.shouldRemember,
    required this.themeMode,
    required this.rating,
    required this.tags,
  });

  Settings copyWith({
    bool? shouldRemember,
    Mode? themeMode,
    Rating? rating,
    List<String>? tags,
  }) {
    return Settings(
      shouldRemember: shouldRemember ?? this.shouldRemember,
      themeMode: themeMode ?? this.themeMode,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
    );
  }

  // Converts `Mode` to Flutter's `ThemeMode`
  ThemeMode get themeModeAsFlutterThemeMode {
    switch (themeMode) {
      case Mode.system:
        return ThemeMode.system;
      case Mode.light:
        return ThemeMode.light;
      case Mode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  String toString() {
    return 'Settings {shouldRemember: $shouldRemember, themeMode: $themeMode, rating: $rating, tags: $tags}';
  }
}
