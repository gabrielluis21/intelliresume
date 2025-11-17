import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelliresume/core/models/user_preferences.dart';

class UserPreferencesRepository {
  static const String _boxName = 'userPreferencesBox';
  static const String _preferencesKey = 'userPreferences';

  Future<Box<UserPreferences>> _openBox() async {
    if (!Hive.isAdapterRegistered(UserPreferencesAdapter().typeId)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
    return await Hive.openBox<UserPreferences>(_boxName);
  }

  Future<UserPreferences> loadPreferences() async {
    final box = await _openBox();
    return box.get(_preferencesKey) ??
        UserPreferences(); // Return default if not found
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    final box = await _openBox();
    await box.put(_preferencesKey, preferences);
  }
}
