import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone/core/services/preference_service.dart';

class TabNotifier extends StateNotifier<TabController?> {
  TabNotifier() : super(null);

  void initializeTabs(TickerProvider vsync, List<String> categories) {
    state = TabController(length: categories.length, vsync: vsync);
  }

  void disposeController() {
    state?.dispose();
  }
}

class ThemeNotifier extends StateNotifier<bool> {
  final PreferenceService _preferenceService;

  ThemeNotifier(this._preferenceService) : super(false);

  Future<void> loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    state = isDark;
  }

  void toggleTheme() {
    state = !state;
    _preferenceService.setIsDarkMode(state);
  }
}