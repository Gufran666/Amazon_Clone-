import 'package:amazon_clone/core/models/user_profile.dart';

extension PersonalizedGreeting on UserProfile {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning, $name!';
    } else if (hour < 18) {
      return 'Good afternoon, $name!';
    } else {
      return 'Good Evening, $name!';
    }
  }
}