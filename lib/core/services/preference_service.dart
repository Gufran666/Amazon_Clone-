import 'dart:convert';
import 'package:amazon_clone/core/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger();

abstract class PreferenceService {
  Future<void> saveUserProfile(UserProfile userProfile);
  Future<UserProfile?> loadUserProfile();
  Future<bool> checkIfOnboarded();
  Future<void> setOnboarded(bool value);
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool isDarkMode);
}

class SecurePreferenceService implements PreferenceService {
  static const String _userProfileKey = 'userProfile';
  static const String _onboardedKey = 'hasOnboarded';
  static const String _isDarkModeKey = 'isDarkMode';

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = userProfile.toJson();
      await prefs.setString(_userProfileKey, jsonEncode(json));
      logger.i('User profile saved successfully.');
    } catch (e) {
      logger.e('Error saving user profile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile?> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? json = prefs.getString(_userProfileKey);

      if (json == null) {
        logger.w('No user profile found in preferences.');
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(json);
      logger.i('User profile loaded successfully.');
      return UserProfile.fromJson(data);
    } catch (e) {
      logger.e('Error loading user profile: $e');
      rethrow;
    }
  }

  @override
  Future<bool> checkIfOnboarded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isOnboarded = prefs.getBool(_onboardedKey) ?? false;
      logger.i('Onboarding status checked: $isOnboarded');
      return isOnboarded;
    } catch (e) {
      logger.e('Error checking onboarding status: $e');
      rethrow;
    }
  }

  @override
  Future<void> setOnboarded(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardedKey, value);
      logger.i('Onboarding status updated to: $value');
    } catch (e) {
      logger.e('Error setting onboarding status: $e');
      rethrow;
    }
  }

  @override
  Future<bool> getIsDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isDarkMode = prefs.getBool(_isDarkModeKey) ?? true;
      logger.i('Theme preference loaded: $isDarkMode');
      return isDarkMode;
    } catch (e) {
      logger.e('Error loading theme preference: $e');
      rethrow;
    }
  }

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, isDarkMode);
      logger.i('Theme preference updated to: $isDarkMode');
    } catch (e) {
      logger.e('Error setting theme preference: $e');
      rethrow;
    }
  }
}

class PreferenceServiceFactory {
  static PreferenceService create() {
    return SecurePreferenceService();
  }
}