import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/presentation/screens/onboarding_screen.dart';
import 'package:amazon_clone/presentation/providers/preference_provider.dart';
import 'package:amazon_clone/presentation/providers/authentication_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late String _loadingText = "";
  int _messageIndex = 0;
  Timer? _textTimer;
  final List<String> _loadingMessages = [
    "Launching experience...",
    "Preparing magic...",
    "Connecting to the future...",
    "Loading innovation...",
    "Getting ready for greatness...",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _animateText();

    Future.delayed(const Duration(seconds: 5), _initializeApp);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  void _initializeApp() async {
    HapticFeedback.lightImpact();

    final prefService = ref.read(preferenceServiceProvider);
    bool? isFirstTime = await prefService.getOnboarded();

    if (isFirstTime == null || !isFirstTime!) {
      _navigateToOnboarding();
    } else {
      final authProvider = ref.read(authenticationProvider.notifier);
      await authProvider.initAuthStatus();

      if (ref.read(authenticationProvider) == AuthState.success) {
        _navigateToHomeScreen();
      } else {
        _navigateToAuthentication();
      }
    }
  }


  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _navigateToAuthentication() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/authentication');
    }
  }

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _animateText() {
    _textTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_messageIndex < _loadingMessages.length) {
        setState(() {
          _loadingText = _loadingMessages[_messageIndex];
          _messageIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF0000), Color(0xFFFFFF00), Color(0xFF00FFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 3),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Lottie.asset(
                        'assets/animations/splash.json',
                        width: 300,
                        height: 300,
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment(0, 0.8),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Amazon Clone',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _loadingText,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.9),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 3),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: const SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}