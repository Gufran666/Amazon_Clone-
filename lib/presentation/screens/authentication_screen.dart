import 'package:amazon_clone/presentation/screens/activation_screen.dart';
import 'package:amazon_clone/presentation/screens/password_recovery_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/authentication_provider.dart';
import '../widgets/enums.dart';
import '../widgets/form_widgets.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/social_buttons.dart';
import 'home_screen.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  final bool isSignUp;
  const AuthenticationScreen({super.key, required this.isSignUp});

  @override
  ConsumerState<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordVisibility = ValueNotifier<bool>(false);
  final _passwordStrength = ValueNotifier<PasswordStrength?>(null);
  bool _shakeError = false;
  final _isProcessing = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisibility.dispose();
    _passwordStrength.dispose();
    _isProcessing.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _shakeError = false);
      _isProcessing.value = true;

      try {
        if (widget.isSignUp) {
          await ref.read(authenticationProvider.notifier).signUpWithEmail(
              _emailController.text.trim(),
              _passwordController.text.trim()
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountActivationScreen()),
          );
        } else {
          await ref.read(authenticationProvider.notifier).signInWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text.trim()
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(e.code))),
        );
      } finally {
        _isProcessing.value = false;
      }
    } else {
      setState(() => _shakeError = true);
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password': return 'Password is too weak';
      case 'email-already-in-use': return 'Email already registered';
      case 'invalid-email': return 'Invalid email address';
      case 'user-not-found': return 'User not found';
      case 'wrong-password': return 'Incorrect password';
      default: return 'Authentication failed';
    }
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      _passwordStrength.value = null;
      return;
    }

    var strength = PasswordStrength.weak;
    var hasNumber = password.contains(RegExp(r'[0-9]'));
    var hasUpper = password.contains(RegExp(r'[A-Z]'));
    var hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    var length = password.length;

    if (length >= 8 && (hasNumber || hasUpper || hasSpecial)) {
      strength = PasswordStrength.medium;
    }
    if (length >= 12 && hasNumber && hasUpper && hasSpecial) {
      strength = PasswordStrength.strong;
    }

    _passwordStrength.value = strength;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF0000),
              Color(0xFFFFFF00),
              Color(0xFF00FFFF),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'Amazon Clone',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => EmailValidator.validate(value ?? '')
                                  ? null
                                  : 'Please enter a valid email',
                              errorText: _shakeError ? 'Please enter a valid email' : null,
                              hintText: 'example@email.com',
                              prefixIconColor: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            ValueListenableBuilder<bool>(
                              valueListenable: _passwordVisibility,
                              builder: (context, isVisible, child) {
                                return CustomTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  icon: Icons.lock,
                                  isPassword: true,
                                  obscureText: !isVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isVisible ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _passwordVisibility.value = !isVisible,
                                  ),
                                  validator: (value) =>
                                  value!.length < 8
                                      ? 'Password must be at least 8 characters'
                                      : null,
                                  onChanged: (value) => _checkPasswordStrength(value),
                                  errorText: _shakeError
                                      ? 'Password must be at least 8 characters'
                                      : null,
                                  hintText: '••••••••••••',
                                  prefixIconColor: Colors.grey,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            PasswordStrengthIndicator(passwordStrength: _passwordStrength.value),
                            if (widget.isSignUp) const SizedBox(height: 20),
                            if (widget.isSignUp)
                              CustomTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                icon: Icons.lock,
                                isPassword: true,
                                obscureText: !_passwordVisibility.value,
                                validator: (value) =>
                                value != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                                errorText: _shakeError ? 'Passwords do not match' : null,
                                hintText: '••••••••••••',
                                prefixIconColor: Colors.grey,
                              ),
                            const SizedBox(height: 30),
                            ValueListenableBuilder<bool>(
                              valueListenable: _isProcessing,
                              builder: (_, isProcessing, __) {
                                return isProcessing
                                    ? const Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.blue.withAlpha(128),
                                  ),
                                  onPressed: _submitForm,
                                  child: const Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthenticationScreen(
                                    isSignUp: !widget.isSignUp,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.isSignUp
                                    ? 'Already have an account? Sign In'
                                    : "Don't have an account? Sign Up",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (!widget.isSignUp)
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PasswordRecoveryScreen(),
                                  ),
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 30),
                            const SocialAuthButtons(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -80,
                      right: -80,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      left: -60,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}