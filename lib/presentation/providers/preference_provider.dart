
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceServiceProvider = Provider<PreferenceService>((ref) {
  return PreferenceService();
});

class PreferenceService {
  Future<bool> getOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarded') ?? false;
  }

  Future<void> setOnboarded(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', value);
  }
}