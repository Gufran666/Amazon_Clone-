import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/user_profile.dart';
import 'package:amazon_clone/presentation/screens/edit_profile_screen.dart';
import '../../core/services/preference_service.dart';
import 'home_screen.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({super.key});

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> with SingleTickerProviderStateMixin {
  late AnimationController _menuController;
  late UserProfile _currentUser;
  bool _areNotificationsEnabled = true;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _currentUser = UserProfile(
      userId: '1',
      name: 'Arham Gufran',
      email: 'Recordsarham666@gmail.com',
      profilePictureUrl: 'assets/images/profile.jpg',
    );
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      AssetImage('assets/images/profile.jpg'),
      context,
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _menuController.isDismissed
          ? _menuController.forward()
          : _menuController.reverse();
    });
  }

  void _showEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userProfile: _currentUser),
      ),
    );
  }

  void _navigateHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
        icon: const Icon(Icons.menu),
        color: isDarkMode
            ? AppTheme.darkTheme.textTheme.bodyMedium!.color
            : AppTheme.lightTheme.textTheme.bodyMedium!.color,
        onPressed: _toggleMenu,
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
              : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            // Navigate to settings
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPersonalizedGreeting(),
                    const SizedBox(height: 24),
                    _buildUserProfile(),
                    const SizedBox(height: 24),
                    _buildUserInfo(),
                    const SizedBox(height: 24),
                    _buildNotificationSettings(),
                    const SizedBox(height: 24),
                    _buildAccountSwitcher(),
                    const SizedBox(height: 32),
                    _buildBackToHomeButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 250,
          child: AnimatedBuilder(
            animation: _menuController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-250 + (_menuController.value * 250), 0),
                child: _buildSettingsMenu(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizedGreeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Welcome' : hour < 18 ? 'Welcome' : 'Welcome';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              '$greeting, ${_currentUser.name}!',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: isDarkMode
                  ? AppTheme.darkTheme.primaryColor
                  : AppTheme.lightTheme.primaryColor,
              child: CircleAvatar(
                radius: 150,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _currentUser.name,
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                    : AppTheme.lightTheme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentUser.email,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                    : AppTheme.lightTheme.textTheme.bodyMedium!.color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              onPressed: _showEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToHomeButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.primaryColor
            : AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      onPressed: _navigateHome,
      icon: const Icon(Icons.home),
      label: const Text('Back to Home'),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Information',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Member Since', '2023'),
            const SizedBox(height: 12),
            _buildInfoRow('Orders Placed', '42'),
            const SizedBox(height: 12),
            _buildInfoRow('Reviews Written', '15'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDarkMode
                ? AppTheme.darkTheme.primaryColor
                : AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Notifications',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDarkMode
                        ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                        : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                  ),
                ),
                Switch(
                  value: _areNotificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _areNotificationsEnabled = value),
                  activeColor: isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                // Navigate to notification settings
              },
              child: const Text('Manage Notification Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSwitcher() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accounts',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                // Show account switcher
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Switch Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                _toggleMenu();
                // Navigate to account settings
              },
              icon: const Icon(Icons.person),
              label: const Text('Account Settings'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                _toggleMenu();
                // Navigate to privacy settings
              },
              icon: const Icon(Icons.privacy_tip),
              label: const Text('Privacy Settings'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                _toggleMenu();
                // Navigate to help center
              },
              icon: const Icon(Icons.help),
              label: const Text('Help Center'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                textStyle: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 4, // Set to 4 since this is the Profile screen
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