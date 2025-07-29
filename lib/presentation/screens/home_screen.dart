import 'package:amazon_clone/presentation/screens/payment_method_screen.dart';
import 'package:amazon_clone/presentation/screens/profile_overview_screen.dart';
import 'package:amazon_clone/presentation/screens/search_screen.dart';
import 'package:amazon_clone/presentation/screens/server_error_screen.dart';
import 'package:amazon_clone/presentation/screens/shipping_address_screen.dart';
import 'package:amazon_clone/presentation/screens/shopping_cart_screen.dart';
import 'package:amazon_clone/presentation/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone/presentation/providers/home_providers.dart';
import 'package:amazon_clone/presentation/screens/product_listing_screen.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';

import 'checkout_review_screen.dart';
import 'no_internet_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_map_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late final List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = [
      'All',
      'Electronics',
      'Clothing',
      'Books',
      'Computers',
      'Accessories',
      'Furniture',
      'Sports & Fitness',
      'Health & Wellness',
      'Fashion',
    ];
    Future.microtask(() {
      ref.read(tabProvider.notifier).initializeTabs(this, categories);
    });
    Future.microtask(() {
      ref.read(isDarkModeProvider.notifier).loadThemePreference();
    });
  }

  @override
  void dispose() {
    ref.read(tabProvider.notifier).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TabController? tabController = ref.watch(tabProvider);
    final int currentIndex = ref.watch(currentIndexProvider);
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final List<Product> products = ref.watch(productProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode ? AppTheme.darkTheme.scaffoldBackgroundColor : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, isDarkMode, currentIndex),
        body: TabBarView(
          controller: tabController,
          children: categories.map((category) {
            final filteredProducts = _filterProductsByCategory(category, products);
            return ProductListingScreen(
              category: category,
              products: filteredProducts,
            );
          }).toList(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context, currentIndex, isDarkMode),
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

  AppBar _buildAppBar(BuildContext context, bool isDarkMode, int currentIndex) {
    return AppBar(
      backgroundColor: isDarkMode ? AppTheme.darkTheme.scaffoldBackgroundColor : AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        'Amazon Clone',
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: isDarkMode ? AppTheme.darkTheme.textTheme?.bodyLarge?.color : AppTheme.lightTheme.textTheme?.bodyLarge?.color,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.brightness_4 : Icons.brightness_7,
          ),
          onPressed: () {
            ref.read(isDarkModeProvider.notifier).toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            ref.read(currentIndexProvider.notifier).update((state) => 1);
            Navigator.pushNamed(context, '/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            ref.read(currentIndexProvider.notifier).update((state) => 2);
            Navigator.pushNamed(context, '/cart');
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            Navigator.pushNamed(context, '/wishlist');
          },
        ),
      ],
      bottom: TabBar(
        controller: ref.watch(tabProvider),
        isScrollable: true,
        indicatorColor: isDarkMode ? AppTheme.darkTheme.primaryColor : AppTheme.lightTheme.primaryColor,
        labelColor: isDarkMode ? AppTheme.darkTheme.primaryColor : AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: isDarkMode ? AppTheme.darkTheme.textTheme?.bodyMedium?.color : AppTheme.lightTheme.textTheme?.bodyMedium?.color,
        labelStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        tabs: categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  List<Product> _filterProductsByCategory(String category, List<Product> products) {
    return category == 'All' ? products : products.where((p) => p.category == category).toList();
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context, int currentIndex, bool isDarkMode) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppTheme.darkTheme.textTheme?.bodyMedium?.color,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        ref.read(currentIndexProvider.notifier).update((state) => index);
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