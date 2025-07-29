import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone/core/services/preference_service.dart';


final preferenceServiceProvider = Provider<PreferenceService>((ref) {
  return PreferenceServiceFactory.create();
});

final onboardingPageIndexProvider = StateProvider<int>((ref) => 0);