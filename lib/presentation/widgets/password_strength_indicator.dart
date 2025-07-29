// password_strength_indicator.dart
import 'package:flutter/material.dart';
import 'package:amazon_clone/presentation/widgets/enums.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength? passwordStrength;
  const PasswordStrengthIndicator({super.key, required this.passwordStrength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: passwordStrength == PasswordStrength.weak ? 0.33 :
              passwordStrength == PasswordStrength.medium ? 0.66 :
              passwordStrength == PasswordStrength.strong ? 1 : 0,
              color: passwordStrength == PasswordStrength.weak ? Colors.red :
              passwordStrength == PasswordStrength.medium ? Colors.orange :
              passwordStrength == PasswordStrength.strong ? Colors.green : Colors.grey,
              backgroundColor: Colors.grey[300],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            passwordStrength == PasswordStrength.weak ? 'Weak' :
            passwordStrength == PasswordStrength.medium ? 'Medium' :
            passwordStrength == PasswordStrength.strong ? 'Strong' : '',
            style: TextStyle(
              color: passwordStrength == PasswordStrength.weak ? Colors.red :
              passwordStrength == PasswordStrength.medium ? Colors.orange :
              passwordStrength == PasswordStrength.strong ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}