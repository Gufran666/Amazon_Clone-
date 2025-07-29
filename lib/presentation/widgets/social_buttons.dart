import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/authentication_provider.dart';
import '../screens/home_screen.dart';

class SocialAuthButtons extends ConsumerStatefulWidget {
  const SocialAuthButtons({super.key});

  @override
  ConsumerState<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends ConsumerState<SocialAuthButtons> {
  bool _isFacebookLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  void _handleSocialSignIn(String provider) async {
    setState(() {
      if (provider == 'facebook') _isFacebookLoading = true;
      if (provider == 'google') _isGoogleLoading = true;
      if (provider == 'apple') _isAppleLoading = true;
    });

    print("Starting $provider authentication...");

    final authNotifier = ref.read(authenticationProvider.notifier);

    try {
      if (provider == 'google') {
        await authNotifier.signInWithGoogle();
      } else if (provider == 'facebook') {
        await authNotifier.signInWithFacebook();
      } else if (provider == 'apple') {
        await authNotifier.signInWithApple();
      }
    } catch (e) {
      print("Error during $provider authentication: $e");
    }

    bool isAuthenticated = ref.read(authenticationProvider) == AuthState.success;
    print("$provider authentication successful: $isAuthenticated");

    setState(() {
      _isFacebookLoading = false;
      _isGoogleLoading = false;
      _isAppleLoading = false;
    });

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$provider authentication failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 20),
        const Text(
          'Or continue with',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: 'assets/images/Facebook.jpeg',
              color: Colors.blue,
              isLoading: _isFacebookLoading,
              onPressed: () => _handleSocialSignIn('facebook'),
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: 'assets/images/google.png',
              color: Colors.transparent,
              isLoading: _isGoogleLoading,
              onPressed: () => _handleSocialSignIn('google'),
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: 'assets/images/apple.png',
              color: Colors.transparent,
              isLoading: _isAppleLoading,
              onPressed: () => _handleSocialSignIn('apple'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          elevation: 5,
          shadowColor: Colors.black.withAlpha(80),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: onPressed,
        onHover: (value) {
          // Add hover effect animation
          setState(() {});
        },
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Image.asset(
          icon,
          width: 24,
          height: 24,
          color: color == Colors.white ? Colors.black : null,
        ),
      ),
    );
  }
}