import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mars/models/prefs.dart';
import 'package:mars/services/theme_manager.dart';

class PreferencesManager extends StateNotifier<Prefs> {
  PreferencesManager()
      : super(Prefs(
          theme: ThemeManager().lightTheme,
        )) {
    readPrefs();
  }

  Future<void> readPrefs() async {
    Box settings = Hive.box('settings');
    bool darkMode = settings.get('darkMode', defaultValue: false);

    state = Prefs(
      theme: darkMode ? ThemeManager().darkTheme : ThemeManager().lightTheme,
    );
  }

  void setDarkMode() async {
    state = state.copyWith(theme: ThemeManager().darkTheme);
    final settings = Hive.box('settings');
    settings.put('darkMode', true);
  }

  void setLightMode() async {
    state = state.copyWith(theme: ThemeManager().lightTheme);
    final settings = Hive.box('settings');
    settings.put('darkMode', false);
  }
}
