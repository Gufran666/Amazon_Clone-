import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/presentation/screens/payment_method_screen.dart';

import '../../core/services/preference_service.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _continueButtonController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetAddressController;
  late TextEditingController _apartmentController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _countryController;
  late TextEditingController _phoneNumberController;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;

  @override
  void initState() {
    super.initState();
    _continueButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _streetAddressController = TextEditingController();
    _apartmentController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _countryController = TextEditingController();
    _phoneNumberController = TextEditingController();
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
    _continueButtonController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetAddressController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void _continueToPayment() async {
    if (_validateForm()) {
      try {
        await HapticFeedback.lightImpact();
        _continueButtonController.forward();
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentMethodScreen(),
          ),
        );
      } finally {
        _continueButtonController.reverse();
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
        'Shipping Address',
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPersonalizedGreeting(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
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
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                      : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
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
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                      : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetAddressController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
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
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                      : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController,
                      decoration: InputDecoration(
                        labelText: 'Apt/Suite',
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
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                            : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
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
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                            : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
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
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                            : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
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
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                            : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ZIP code';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Country',
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
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                      : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyLarge!.color
                      : AppTheme.lightTheme.textTheme.bodyLarge!.color,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _buildContinueButton(),
            ],
          ),
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
              '$greeting!',
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

  Widget _buildContinueButton() {
    return FadeTransition(
      opacity: _continueButtonController,
      child: ScaleTransition(
        scale: _continueButtonController,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode
                ? AppTheme.darkTheme.primaryColor
                : AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
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
          onPressed: _continueToPayment,
          child: AnimatedBuilder(
            animation: _continueButtonController,
            builder: (context, child) {
              return _continueButtonController.isAnimating
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Continue to Payment');
            },
          ),
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