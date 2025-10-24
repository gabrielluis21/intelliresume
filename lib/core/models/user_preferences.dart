import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences {
  @HiveField(0)
  final String? languageCode; // ex: 'en', 'pt'

  @HiveField(1)
  final ThemeMode themeMode; // ThemeMode.system, ThemeMode.light, ThemeMode.dark

  @HiveField(2)
  final bool highContrast;

  @HiveField(3)
  final bool boldText;

  @HiveField(4)
  final double fontSizeScale; // ex: 1.0, 1.2

  UserPreferences({
    this.languageCode,
    this.themeMode = ThemeMode.system,
    this.highContrast = false,
    this.boldText = false,
    this.fontSizeScale = 1.0,
  });

  UserPreferences copyWith({
    String? languageCode,
    ThemeMode? themeMode,
    bool? highContrast,
    bool? boldText,
    double? fontSizeScale,
  }) {
    return UserPreferences(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      highContrast: highContrast ?? this.highContrast,
      boldText: boldText ?? this.boldText,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
    );
  }
}
