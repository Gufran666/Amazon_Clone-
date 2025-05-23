import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/services/preference_service.dart';
import 'package:amazon_clone/presentation/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final PreferenceService _preferenceService;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'image': 'assets/animations/Animation - 1744747986365.json',
      'title': 'Welcome to Amazon Clone',
      'description': 'Your shopping experience, reimagined with modern design and intuitive navigation.',
      'bgColor': const Color(0xFFFF0000), // Red
    },
    {
      'image': 'assets/animations/discover.json',
      'title': 'Discover Products',
      'description': 'Browse thousands of products with advanced search and filtering options.',
      'bgColor': const Color(0xFFF9A825),
    },
    {
      'image': 'assets/animations/Animation - 1744748264562.json',
      'title': 'Personalized Recommendations',
      'description': 'Get tailored suggestions based on your browsing and purchase history.',
      'bgColor': const Color(0xFF0097A7), // Cyan
    },
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _preferenceService = PreferenceServiceFactory.create();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Stack(
          children: [
            _buildBackgroundGradient(),
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _buildOnboardingPage(onboardingData[index]);
              },
            ),
            _buildSkipButton(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            onboardingData[_currentPage]['bgColor'],
            onboardingData[_currentPage]['bgColor'].withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          data['image'],
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          controller: _animationController,
          onLoaded: (composition) {
            _animationController.duration = composition.duration;
            _animationController.forward();
          },
        ),
        const SizedBox(height: 40),
        Text(
          data['title'],
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            data['description'],
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 40,
      right: 20,
      child: TextButton(
        onPressed: () async {
          await _preferenceService.setOnboarded(true);
          _navigateToHome();
        },
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          Row(
            children: List.generate(
              onboardingData.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8,
                  width: index == _currentPage ? 24 : 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          if (_currentPage == onboardingData.length - 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await _preferenceService.setOnboarded(true);
                _navigateToHome();
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(scale: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }
}