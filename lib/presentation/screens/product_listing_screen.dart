import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'wish_list_screen.dart';
import '../../core/services/preference_service.dart';
import 'checkout_review_screen.dart';
import 'home_screen.dart';
import 'no_internet_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_map_screen.dart';
import 'payment_method_screen.dart';
import 'profile_overview_screen.dart';
import 'search_screen.dart';
import 'server_error_screen.dart';
import 'shipping_address_screen.dart';
import 'shopping_cart_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String category;
  final List<Product> products;
  final Widget Function() buildPersonalizedGreeting;
  final Widget Function(List<Product>) buildFeaturedCarousel;
  final Widget Function(List<Product>) buildDealsOfTheDay;
  final Widget Function(List<Product>) buildTrendingSection;
  final Widget Function(List<Product>) buildGridView;

  const ProductListingScreen({
    super.key,
    required this.category,
    required this.products,
    required this.buildPersonalizedGreeting,
    required this.buildFeaturedCarousel,
    required this.buildDealsOfTheDay,
    required this.buildTrendingSection,
    required this.buildGridView,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String selectedFilter = 'All';
  bool isFavorite = false;
  String searchQuery = '';
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    List<Product> filteredProducts = applyFilter(widget.products, searchQuery, selectedFilter);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.buildPersonalizedGreeting(),
                widget.buildFeaturedCarousel(filteredProducts),
                widget.buildDealsOfTheDay(filteredProducts),
                widget.buildTrendingSection(filteredProducts),
                widget.buildGridView(filteredProducts),
              ],
            ),
          ),
        ),
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
      title: Text(
        widget.category,
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
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              selectedFilter = value;
            });
          },
          icon: Icon(
            Icons.filter_list,
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'All',
              child: Text('All'),
            ),
            const PopupMenuItem(
              value: 'Price: Low to High',
              child: Text('Price: Low to High'),
            ),
            const PopupMenuItem(
              value: 'Price: High to Low',
              child: Text('Price: High to Low'),
            ),
            const PopupMenuItem(
              value: 'Rating: High to Low',
              child: Text('Rating: High to Low'),
            ),
          ],
        ),
      ],
    );
  }
}



List<Product> applyFilter(List<Product> products, String searchQuery, String selectedFilter) {
  List<Product> filtered = products
      .where((product) =>
  searchQuery.isEmpty || product.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  switch (selectedFilter) {
    case 'Price: Low to High':
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case 'Price: High to Low':
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
    case 'Rating: High to Low':
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    default:
      break;
  }

  return filtered;
}




