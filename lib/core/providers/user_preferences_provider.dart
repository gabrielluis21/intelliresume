import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/models/user_preferences.dart';
import 'package:intelliresume/core/repositories/user_preferences_repository.dart';

final userPreferencesRepositoryProvider = Provider((ref) => UserPreferencesRepository());

final userPreferencesNotifierProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier(ref.read(userPreferencesRepositoryProvider));
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final UserPreferencesRepository _repository;

  UserPreferencesNotifier(this._repository) : super(UserPreferences()) {
    _loadInitialPreferences();
  }

  Future<void> _loadInitialPreferences() async {
    state = await _repository.loadPreferences();
  }

  Future<void> setLanguage(String? languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _repository.savePreferences(state);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _repository.savePreferences(state);
  }

  Future<void> setHighContrast(bool highContrast) async {
    state = state.copyWith(highContrast: highContrast);
    await _repository.savePreferences(state);
  }

  Future<void> setBoldText(bool boldText) async {
    state = state.copyWith(boldText: boldText);
    await _repository.savePreferences(state);
  }

  Future<void> setFontSizeScale(double scale) async {
    state = state.copyWith(fontSizeScale: scale);
    await _repository.savePreferences(state);
  }
}
