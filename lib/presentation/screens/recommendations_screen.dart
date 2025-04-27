import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/widgets/product_card.dart';

import '../../core/services/preference_service.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;
  late List<Product> recommendedProducts = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 99.99,
      imageUrl: 'assets/images/headphones.jpg',
      category: 'Electronics',
      rating: 4.5,
      description: 'Premium wireless headphones with active noise cancellation and deep bass.',
      brand: 'AudioTech',
      model: 'AT-X100',
      dimensions: '15x8x3 cm',
      weight: 0.5,
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 149.99,
      imageUrl: 'assets/images/smartwatch.jpg',
      category: 'Electronics',
      rating: 4.7,
      description: 'Advanced smartwatch with heart rate monitoring, GPS, and fitness tracking.',
      brand: 'SmartFit',
      model: 'SF-Pro',
      dimensions: '4x4x1 cm',
      weight: 0.1,
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 79.99,
      imageUrl: 'assets/images/speaker.jpg',
      category: 'Electronics',
      rating: 4.3,
      description: 'Portable Bluetooth speaker delivering immersive 360° surround sound.',
      brand: 'SoundWave',
      model: 'SW-360',
      dimensions: '18x10x10 cm',
      weight: 0.8,
    ),
    Product(
      id: '4',
      name: 'Gaming Laptop',
      price: 899.99,
      imageUrl: 'assets/images/laptop.jpg',
      category: 'Electronics',
      rating: 4.8,
      description: 'High-performance gaming laptop with advanced graphics and fast refresh rate.',
      brand: 'GamerTech',
      model: 'GT-5000',
      dimensions: '38x25x2 cm',
      weight: 2.5,
    ),
  ];
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
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
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    try {
      _refreshController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        // Simulate refreshing products
        recommendedProducts = [
          Product(
            id: '1',
            name: 'Wireless Headphones',
            price: 99.99,
            imageUrl: 'assets/images/headphones.jpg',
            category: 'Electronics',
            rating: 4.5,
            description: 'Premium wireless headphones with active noise cancellation and deep bass.',
            brand: 'AudioTech',
            model: 'AT-X100',
            dimensions: '15x8x3 cm',
            weight: 0.5,
          ),
          Product(
            id: '2',
            name: 'Smart Watch',
            price: 149.99,
            imageUrl: 'assets/images/smartwatch.jpg',
            category: 'Electronics',
            rating: 4.7,
            description: 'Advanced smartwatch with heart rate monitoring, GPS, and fitness tracking.',
            brand: 'SmartFit',
            model: 'SF-Pro',
            dimensions: '4x4x1 cm',
            weight: 0.1,
          ),
          Product(
            id: '3',
            name: 'Bluetooth Speaker',
            price: 79.99,
            imageUrl: 'assets/images/speaker.jpg',
            category: 'Electronics',
            rating: 4.3,
            description: 'Portable Bluetooth speaker delivering immersive 360° surround sound.',
            brand: 'SoundWave',
            model: 'SW-360',
            dimensions: '18x10x10 cm',
            weight: 0.8,
          ),
          Product(
            id: '4',
            name: 'Gaming Laptop',
            price: 899.99,
            imageUrl: 'assets/images/laptop.jpg',
            category: 'Electronics',
            rating: 4.8,
            description: 'High-performance gaming laptop with advanced graphics and fast refresh rate.',
            brand: 'GamerTech',
            model: 'GT-5000',
            dimensions: '38x25x2 cm',
            weight: 2.5,
          ),
        ];
      });
    } finally {
      _refreshController.reverse();
    }
  }

  void _loadMoreProducts() {
    setState(() {
      recommendedProducts.addAll([
        Product(
          id: '5',
          name: 'Digital Camera',
          price: 299.99,
          imageUrl: 'assets/images/camera.jpg',
          category: 'Electronics',
          rating: 4.6,
          description: 'High-resolution digital camera with advanced image stabilization and 4K video recording.',
          brand: 'VisionCapture',
          model: 'VC-ProX',
          dimensions: '12x8x6 cm',
          weight: 0.9,
        ),
        Product(
          id: '6',
          name: 'Gaming Mouse',
          price: 49.99,
          imageUrl: 'assets/images/gaming_mouse.jpg',
          category: 'Electronics',
          rating: 4.4,
          description: 'Precision gaming mouse with customizable buttons, RGB lighting, and ergonomic design.',
          brand: 'SpeedClick',
          model: 'SC-500',
          dimensions: '13x7x4 cm',
          weight: 0.2,
        ),
      ]);
    });
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
        'Recommended for You',
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
          icon: const Icon(Icons.refresh),
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
              : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          onPressed: _refreshProducts,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
              : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            // Share recommendations
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPersonalizedGreeting(),
          const SizedBox(height: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              displacement: 20,
              backgroundColor: isDarkMode
                  ? AppTheme.darkTheme.primaryColor
                  : AppTheme.lightTheme.primaryColor,
              color: Colors.white,
              strokeWidth: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];
                  return ProductCard(
                    product: product,
                  );
                },
              ),
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
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
            ),
            onPressed: _loadMoreProducts,
            icon: const Icon(Icons.add),
            label: const Text('Load More'),
          ),
          const SizedBox(height: 32),
        ],
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

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // Set to 1 since this is the Recommendations screen
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