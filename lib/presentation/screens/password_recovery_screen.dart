import 'dart:async';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone/presentation/widgets/form_widgets.dart';

class PasswordRecoveryScreen extends ConsumerStatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  ConsumerState<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

enum RecoveryStep { email, verify, reset }

class _PasswordRecoveryScreenState extends ConsumerState<PasswordRecoveryScreen> {
  RecoveryStep currentStep = RecoveryStep.email;
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isResendTimerActive = false;
  int _resendTimer = 60;
  Timer? _timer;
  bool _shakeError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _isResendTimerActive = true;
    _resendTimer = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendTimer--;
      });

      if (_resendTimer <= 0) {
        setState(() {
          _isResendTimerActive = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _resetPassword() async {
    if (_newPasswordController.text.isNotEmpty &&
        _confirmNewPasswordController.text.isNotEmpty) {

      if (_newPasswordController.text == _confirmNewPasswordController.text) {
        // Simulate password reset
        await Future.delayed(const Duration(seconds: 2));

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful!')),
        );

        // Navigate back to authentication screen
        Navigator.pop(context);
      } else {
        setState(() => _shakeError = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
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
              Color(0xFFFF0000), // Red
              Color(0xFFFFFF00), // Yellow
              Color(0xFF00FFFF), // Cyan
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
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'Password Recovery',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildCurrentStep(),
                            const SizedBox(height: 30),
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

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case RecoveryStep.email:
        return _buildEmailStep();
      case RecoveryStep.verify:
        return _buildVerificationStep();
      case RecoveryStep.reset:
        return _buildResetStep();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      children: [
        const Text(
          'Enter your email address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.blue.withAlpha(128),
          ),
          onPressed: () {
            if (EmailValidator.validate(_emailController.text)) {
              setState(() {
                currentStep = RecoveryStep.verify;
                _startResendTimer();
              });
            } else {
              setState(() => _shakeError = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid email')),
              );
            }
          },
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      children: [
        const Text(
          'Verification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'We have sent a verification code to your email',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _verificationCodeController,
          labelText: 'Verification Code',
          icon: Icons.verified,
          keyboardType: TextInputType.number,
          hintText: 'Enter verification code',
        ),
        const SizedBox(height: 20),
        if (_isResendTimerActive)
          Text('Resend code in $_resendTimer seconds')
        else
          TextButton(
            onPressed: () {
              setState(() {
                _startResendTimer();
              });
            },
            child: const Text('Resend Verification Code'),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.blue.withAlpha(128),
          ),
          onPressed: () {
            setState(() {
              currentStep = RecoveryStep.reset;
            });
          },
          child: const Text(
            'Verify',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => setState(() => currentStep = RecoveryStep.email),
          child: const Text(
            'Back',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetStep() {
    return Column(
      children: [
        const Text(
          'Reset Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _newPasswordController,
          labelText: 'New Password',
          icon: Icons.lock,
          isPassword: true,
          obscureText: true,
          hintText: '••••••••••••',
          prefixIconColor: Colors.grey,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _confirmNewPasswordController,
          labelText: 'Confirm New Password',
          icon: Icons.lock,
          isPassword: true,
          obscureText: true,
          hintText: '••••••••••••',
          prefixIconColor: Colors.grey,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.blue.withAlpha(128),
          ),
          onPressed: _resetPassword,
          child: const Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => setState(() => currentStep = RecoveryStep.verify),
          child: const Text(
            'Back',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}