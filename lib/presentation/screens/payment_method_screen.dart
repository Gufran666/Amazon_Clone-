import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/services/preference_service.dart';
import 'wish_list_screen.dart';
import 'checkout_review_screen.dart';
import 'home_screen.dart';
import 'no_internet_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_map_screen.dart';
import 'profile_overview_screen.dart';
import 'search_screen.dart';
import 'server_error_screen.dart';
import 'shipping_address_screen.dart';
import 'shopping_cart_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _securityIconController;
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;
  String _selectedPaymentMethod = 'credit_card';
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;
  bool _isCardValid = false;
  bool _isDateValid = false;
  bool _isCvvValid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _securityIconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
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
  void dispose() {
    _tabController.dispose();
    _securityIconController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _validateCreditCard() {
    final cardNumber = _cardNumberController.text;
    final expiryDate = _expiryDateController.text;
    final cvv = _cvvController.text;

    setState(() {
      _isCardValid = cardNumber.length == 16;
      _isDateValid = expiryDate.length == 5;
      _isCvvValid = cvv.length == 3;
    });
  }

  void _continueToReview() async {
    if ((_selectedPaymentMethod == 'credit_card' && _isCardValid && _isDateValid && _isCvvValid) ||
        _selectedPaymentMethod == 'digital_wallet') {
      try {
        await HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutReviewScreen(),
          ),
        );
      } catch (e) {
        // Handle navigation error
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
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCreditCardTab(),
            _buildDigitalWalletsTab(),
          ],
        ),
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
        '/order/tracking': (context) => const OrderTrackingMapScreen(),
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
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: isDarkMode
            ? AppTheme.darkTheme.primaryColor
            : AppTheme.lightTheme.primaryColor,
        labelColor: isDarkMode
            ? AppTheme.darkTheme.primaryColor
            : AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: isDarkMode
            ? AppTheme.darkTheme.textTheme.bodyMedium!.color
            : AppTheme.lightTheme.textTheme.bodyMedium!.color,
        labelStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: 'Credit Card'),
          Tab(text: 'Digital Wallets'),
        ],
      ),
      title: Text(
        'Payment Method',
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

  Widget _buildCreditCardTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                              : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(127)
                                : AppTheme.lightTheme.textTheme.bodyMedium!.color!.withAlpha(127),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? AppTheme.darkTheme.primaryColor
                                : AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        prefixIcon: const Icon(Icons.credit_card),
                        prefixIconColor: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                            : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                            : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _validateCreditCard();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 16) {
                          return 'Please enter a valid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date (MM/YY)',
                              labelStyle: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: isDarkMode
                                    ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                                    : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(127)
                                      : AppTheme.lightTheme.textTheme.bodyMedium!.color!.withAlpha(127),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? AppTheme.darkTheme.primaryColor
                                      : AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              prefixIcon: const Icon(Icons.calendar_month),
                              prefixIconColor: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                                  : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                            ),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                                  : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _validateCreditCard();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length != 5) {
                                return 'Please enter a valid expiry date';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              labelStyle: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: isDarkMode
                                    ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                                    : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(127)
                                      : AppTheme.lightTheme.textTheme.bodyMedium!.color!.withAlpha(127),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? AppTheme.darkTheme.primaryColor
                                      : AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              prefixIconColor: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                                  : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                            ),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                                  : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _validateCreditCard();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length != 3) {
                                return 'Please enter a valid CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.shield,
                          color: isDarkMode
                              ? AppTheme.darkTheme.primaryColor
                              : AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Your payment information is protected with encryption',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                          ),
                        ),
                        const Spacer(),
                        ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _securityIconController,
                            curve: const Interval(0, 1, curve: Curves.easeInOut),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: isDarkMode
                                ? AppTheme.darkTheme.primaryColor
                                : AppTheme.lightTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildContinueButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalWalletsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text(
                        'Apple Pay',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      value: 'apple_pay',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                          HapticFeedback.lightImpact();
                        });
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkTheme.primaryColor
                          : AppTheme.lightTheme.primaryColor,
                      secondary: const Icon(Icons.apple),
                    ),
                    RadioListTile(
                      title: Text(
                        'Google Pay',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      value: 'google_pay',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                          HapticFeedback.lightImpact();
                        });
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkTheme.primaryColor
                          : AppTheme.lightTheme.primaryColor,
                      secondary: const Icon(Icons.android),
                    ),
                    RadioListTile(
                      title: Text(
                        'Samsung Pay',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      value: 'samsung_pay',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                          HapticFeedback.lightImpact();
                        });
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkTheme.primaryColor
                          : AppTheme.lightTheme.primaryColor,
                      secondary: const Icon(Icons.smartphone),
                    ),
                    RadioListTile(
                      title: Text(
                        'PayPal',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      value: 'paypal',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                          HapticFeedback.lightImpact();
                        });
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkTheme.primaryColor
                          : AppTheme.lightTheme.primaryColor,
                      secondary: const Icon(Icons.paypal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  Icons.shield,
                  color: isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment information is protected with encryption',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                          : AppTheme.lightTheme.textTheme.bodyMedium!.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _securityIconController,
                    curve: const Interval(0, 1, curve: Curves.easeInOut),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: isDarkMode
                        ? AppTheme.darkTheme.primaryColor
                        : AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? AppTheme.darkTheme.primaryColor
              : AppTheme.lightTheme.primaryColor,
          foregroundColor: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyLarge!.color
              : AppTheme.lightTheme.textTheme.bodyLarge!.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          textStyle: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        onPressed: _continueToReview,
        child: const Text('Continue to Review'),
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