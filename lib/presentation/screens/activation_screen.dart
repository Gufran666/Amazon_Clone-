import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/authentication_provider.dart';

class AccountActivationScreen extends ConsumerStatefulWidget {
  const AccountActivationScreen({super.key});

  @override
  ConsumerState<AccountActivationScreen> createState() => _AccountActivationScreenState();
}

class _AccountActivationScreenState extends ConsumerState<AccountActivationScreen> {
  late ConfettiController _confettiController;
  bool _isActivated = false;
  bool _isCountdownFinished = false;
  final _isProcessing = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    _startCountdown();
  }

  void _startCountdown() {
    CountdownTimer(
      endTime: DateTime.now().millisecondsSinceEpoch + 180000, // 3 minutes from now
      onEnd: () {
        setState(() {
          _isCountdownFinished = true;
        });
      },
    );
  }

  void _activateAccount() async {
    _isProcessing.value = true;
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user != null && user.emailVerified) {
        await ref.read(authenticationProvider.notifier).activateAccount();
        setState(() {
          _isActivated = true;
        });
        _confettiController.play();
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to activate account')),
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  void _resendActivationLink() async {
    _isProcessing.value = true;
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New activation link sent')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send activation link')),
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _isProcessing.dispose();
    super.dispose();
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
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Account Activation',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isProcessing,
                            builder: (_, isProcessing, __) {
                              return isProcessing
                                  ? const Center(child: CircularProgressIndicator())
                                  : _buildContentBasedOnState();
                            },
                          ),
                          const SizedBox(height: 40),
                        ],
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
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  maxBlastForce: 50,
                  minBlastForce: 20,
                  emissionFrequency: 0.05,
                  numberOfParticles: 100,
                  gravity: 0.05,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnState() {
    if (_isActivated) {
      return _buildSuccessContent();
    } else if (_isCountdownFinished) {
      return _buildExpiredContent();
    } else {
      return _buildActivationContent();
    }
  }

  Widget _buildActivationContent() {
    return Column(
      children: [
        const Text(
          'Activate your account',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'We have sent an activation link to your email. Please click on the link to activate your account.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 30),
        CountdownTimer(
          endTime: DateTime.now().millisecondsSinceEpoch + 180000,
          onEnd: () {
            setState(() {
              _isCountdownFinished = true;
            });
          },
          widgetBuilder: (context, time) {
            if (time == null) {
              return const Text('Activation link expired');
            }
            return Text(
              'This link will expire in ${time.min}:${time.sec.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            );
          },
        ),
        const SizedBox(height: 30),
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
          onPressed: _activateAccount,
          child: const Text(
            'ACTIVATE ACCOUNT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiredContent() {
    return Column(
      children: [
        const Icon(
          Icons.warning,
          size: 80,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        const Text(
          'Activation link expired',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'This activation link has expired. Please request a new activation link.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 30),
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
          onPressed: _resendActivationLink,
          child: const Text(
            'Request New Link',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        const Text(
          'Account Activated Successfully',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your account has been activated successfully. You can now login to your account.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.green.withAlpha(128),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text(
            'PROCEED TO LOGIN',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}