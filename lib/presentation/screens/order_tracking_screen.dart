import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';

import '../../core/services/preference_service.dart';
import 'checkout_review_screen.dart';
import 'home_screen.dart';
import 'no_internet_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'payment_method_screen.dart';
import 'profile_overview_screen.dart';
import 'search_screen.dart';
import 'server_error_screen.dart';
import 'shipping_address_screen.dart';
import 'shopping_cart_screen.dart';
import 'wish_list_screen.dart';
class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _timelineController;
  late List<Map<String, dynamic>> _orderStatuses;
  late Timer _countdownTimer;
  int _remainingHours = 48;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;

  @override
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _orderStatuses = [
      {'status': 'Order Placed', 'date': '2023-11-10', 'isCompleted': true},
      {'status': 'Processing', 'date': '2023-11-10', 'isCompleted': true},
      {'status': 'Shipped', 'date': '2023-11-11', 'isCompleted': true},
      {'status': 'Out for Delivery', 'date': '2023-11-12', 'isCompleted': true},
      {'status': 'Delivered', 'date': '2023-11-13', 'isCompleted': false},
    ];
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
    _startCountdownTimer();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  void dispose() {
    _timelineController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingHours > 0) {
          _remainingHours--;
        } else {
          _updateOrderStatus();
        }
      });
    });
  }

  void _updateOrderStatus() {
    for (int i = 0; i < _orderStatuses.length; i++) {
      if (!_orderStatuses[i]['isCompleted']) {
        setState(() {
          _orderStatuses[i]['isCompleted'] = true;
          _timelineController.forward(from: 0);
          _remainingHours = 48;
        });
        break;
      }
    }
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
      routes: {
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/cart': (context) => const ShoppingCartScreen(),
        '/orders': (context) => const OrderHistoryScreen(),
        '/profile': (context) => const ProfileOverviewScreen(),
        '/checkout': (context) => const CheckoutReviewScreen(),
        '/payment': (context) => const PaymentMethodScreen(),
        '/order/confirmation': (context) => const OrderConfirmationScreen(),
        '/order/tracking': (context) => const OrderTrackingScreen(),
        '/shipping': (context) => const ShippingAddressScreen(),
        '/wishlist': (context) => const WishListScreen(),
        '/no-internet': (context) => const NoInternetScreen(),
        '/server-error': (context) => const ServerErrorScreen(),
      },
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
        'Order Tracking',
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
          icon: Icon(
            isDarkMode ? Icons.brightness_4 : Icons.brightness_7,
          ),
          onPressed: () {
            setState(() {
              isDarkMode = !isDarkMode;
              _preferenceService.setIsDarkMode(isDarkMode);
            });
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildPersonalizedGreeting(),
            const SizedBox(height: 24),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildTimeline(),
            const SizedBox(height: 24),
            _buildMapPreview(),
            const SizedBox(height: 24),
            _buildDeliveryInfo(),
            const SizedBox(height: 32),
            _buildCustomerSupport(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedGreeting() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 18 ? 'Good afternoon' : 'Good evening';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              '$greeting, User!',
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

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Order ID', 'ORD-2023-123456'),
            const SizedBox(height: 12),
            _buildSummaryRow('Order Date', '2023-11-10'),
            const SizedBox(height: 12),
            _buildSummaryRow('Estimated Delivery', '2023-11-13'),
            const SizedBox(height: 12),
            _buildSummaryRow('Delivery Address', '123 Main Street, New York, NY 10001'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
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
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                  : AppTheme.lightTheme.textTheme.bodyLarge!.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
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
              'Order Status',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _orderStatuses.length,
              itemBuilder: (context, index) {
                return _buildTimelineItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(int index) {
    final status = _orderStatuses[index];
    final isCompleted = status['isCompleted'] as bool;
    final isLast = index == _orderStatuses.length - 1;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor
                    : isDarkMode
                    ? AppTheme.darkTheme.scaffoldBackgroundColor
                    : AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCompleted
                      ? isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor
                      : isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(77)
                      : AppTheme.lightTheme.textTheme.bodyMedium!.color!.withAlpha(77),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check : Icons.hourglass_empty,
                  color: isCompleted
                      ? Colors.white
                      : isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                      : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['status'],
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isCompleted
                          ? isDarkMode
                          ? AppTheme.darkTheme.primaryColor
                          : AppTheme.lightTheme.primaryColor
                          : isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                          : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status['date'],
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                          : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          const SizedBox(height: 20),
        if (!isLast)
          Container(
            height: 2,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? isDarkMode
                  ? AppTheme.darkTheme.primaryColor
                  : AppTheme.lightTheme.primaryColor
                  : isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(77)
                  : AppTheme.lightTheme.textTheme.bodyMedium!.color!.withAlpha(77),
            ),
          ),
      ],
    );
  }

  Widget _buildMapPreview() {
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
              'Delivery Location',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Currently en route',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                                : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                          ),
                        ),
                        Text(
                          '${_remainingHours ~/ 24} days, ${_remainingHours % 24} hours left',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDarkMode
                                ? AppTheme.darkTheme.primaryColor
                                : AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
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
              'Delivery Information',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your package is on its way and should arrive within the estimated delivery window. You\'ll receive a notification when it\'s out for delivery.',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
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
              onPressed: () {
                HapticFeedback.lightImpact();
                // Handle track with carrier
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Track with Carrier'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSupport() {
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
              'Need Help?',
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
                HapticFeedback.lightImpact();
                // Handle contact support
              },
              icon: const Icon(Icons.headset_mic),
              label: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3, // Set to 3 since this is the Orders screen
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