import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/presentation/screens/home_screen.dart';

import '../../core/services/preference_service.dart';

class ServerErrorScreen extends StatefulWidget {
  const ServerErrorScreen({super.key});

  @override
  State<ServerErrorScreen> createState() => _ServerErrorScreenState();
}

class _ServerErrorScreenState extends State<ServerErrorScreen> with SingleTickerProviderStateMixin {
  bool isRetrying = false;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;

  @override
  void initState() {
    super.initState();
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  Future<void> handleRetry() async {
    setState(() {
      isRetrying = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRetrying = false;
    });

    Navigator.pop(context);
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
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppTheme.darkTheme.scaffoldBackgroundColor
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: isDarkMode
            ? AppTheme.darkTheme.textTheme.bodyMedium!.color
            : AppTheme.lightTheme.textTheme.bodyMedium!.color,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Server Error',
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRetrying)
              const CircularProgressIndicator(
                color: Colors.white,
              )
            else
              Image.asset(
                'assets/images/server.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.cloud_off,
                  size: 100,
                  color: isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor,
                ),
              ),
            const SizedBox(height: 32),
            Text(
              'Server Error',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                    : AppTheme.lightTheme.textTheme.bodyLarge!.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We encountered a server error. Please try again later or contact support.',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                    : AppTheme.lightTheme.textTheme.bodyMedium!.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: handleRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const HomeScreen();
                  }),
                      (route) => false,
                );
              },
              child: Text(
                'Contact Support',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: isDarkMode
          ? AppTheme.darkTheme.textTheme.bodyMedium!.color
          : AppTheme.lightTheme.textTheme.bodyMedium!.color,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0: Navigator.pushNamed(context, '/home'); break;
          case 1: Navigator.pushNamed(context, '/search'); break;
          case 2: Navigator.pushNamed(context, '/cart'); break;
          case 3: Navigator.pushNamed(context, '/orders'); break;
          case 4: Navigator.pushNamed(context, '/profile'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}