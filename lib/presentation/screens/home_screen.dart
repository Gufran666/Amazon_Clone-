import 'package:amazon_clone/presentation/screens/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/screens/product_detail_screen.dart';
import 'package:amazon_clone/core/services/preference_service.dart';
import 'no_internet_screen.dart';
import 'server_error_screen.dart';
import 'wish_list_screen.dart';
import 'checkout_review_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_map_screen.dart';
import 'payment_method_screen.dart';
import 'profile_overview_screen.dart';
import 'search_screen.dart';
import 'shipping_address_screen.dart';
import 'shopping_cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  late final List<String> categories;
  late final List<Product> mockProducts;
  late final PreferenceService _preferenceService;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();

    // Initialize categories first
    categories = [
      'All',
      'Electronics',
      'Clothing',
      'Home',
      'Books',
      'Computers',
      'Accessories',
      'Furniture',
      'Sports & Fitness',
      'Health & Wellness',
      'Fashion',
    ];
    _tabController = TabController(length: categories.length, vsync: this);

    mockProducts = _initializeMockProducts();
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
    super.dispose();
  }

  List<Product> _initializeMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Stainless Steel Water Bottle',
        price: 24.99,
        imageUrl: 'assets/images/bottle.PNG',
        category: 'Accessories',
        rating: 4.6,
        description: 'Durable stainless steel water bottle with insulation for temperature retention.',
        brand: 'HydroPro',
        model: 'HP-Insulated',
        dimensions: '25x8x8 cm',
        weight: 0.6,
      ),
      Product(
        id: '2',
        name: 'Action Camera',
        price: 249.99,
        imageUrl: 'assets/images/camera.jpg',
        category: 'Electronics',
        rating: 4.8,
        description: 'Compact action camera with 4K resolution and waterproof design.',
        brand: 'AdventureCam',
        model: 'AC-Pro4K',
        dimensions: '8x6x4 cm',
        weight: 0.3,
      ),
      Product(
        id: '3',
        name: 'Ergonomic Office Chair',
        price: 149.99,
        imageUrl: 'assets/images/chair.jpeg',
        category: 'Furniture',
        rating: 4.4,
        description: 'Comfortable office chair with lumbar support for extended work sessions.',
        brand: 'ErgoPro',
        model: 'EP-Comfort',
        dimensions: '120x60x60 cm',
        weight: 12.0,
      ),
      Product(
        id: '4',
        name: 'Non-Stick Cookware Set',
        price: 99.99,
        imageUrl: 'assets/images/cookware.jpg',
        category: 'Home & Kitchen',
        rating: 4.7,
        description: 'Premium non-stick cookware set designed for efficient cooking.',
        brand: 'ChefMaster',
        model: 'CM-Deluxe',
        dimensions: '40x30x20 cm',
        weight: 5.0,
      ),
      Product(
        id: '5',
        name: 'Fiction Novel',
        price: 19.99,
        imageUrl: 'assets/images/fiction_novel.jpeg',
        category: 'Books',
        rating: 4.8,
        description: 'A captivating fiction novel filled with mystery and suspense.',
        brand: 'Mystic Reads',
        model: 'Edition 2',
        dimensions: '21x14x2 cm',
        weight: 0.3,
      ),
      Product(
        id: '6',
        name: 'Stylish Sunglasses with UV Protection',
        price: 89.99,
        imageUrl: 'assets/images/glasses.jpeg',
        category: 'Fashion',
        rating: 4.5,
        description: 'Premium sunglasses designed for UV protection and style.',
        brand: 'VisionLux',
        model: 'VL-Shade',
        dimensions: '15x5x3 cm',
        weight: 0.25,
      ),
      Product(
        id: '7',
        name: 'Wireless Headphones',
        price: 99.99,
        imageUrl: 'assets/images/headphones.jpeg',
        category: 'Electronics',
        rating: 4.5,
        description: 'Premium wireless headphones with active noise cancellation and deep bass.',
        brand: 'AudioTech',
        model: 'AT-X100',
        dimensions: '15x8x3 cm',
        weight: 0.5,
      ),
      Product(
        id: '8',
        name: 'Electric Kettle',
        price: 39.99,
        imageUrl: 'assets/images/kettle.jpg',
        category: 'Home & Kitchen',
        rating: 4.3,
        description: 'Fast-boiling electric kettle with auto shut-off and temperature control.',
        brand: 'KitchenEase',
        model: 'KE-FastBoil',
        dimensions: '25x15x15 cm',
        weight: 1.0,
      ),
      Product(
        id: '9',
        name: 'Gaming Laptop',
        price: 1299.99,
        imageUrl: 'assets/images/laptop.jpeg',
        category: 'Computers',
        rating: 4.6,
        description: 'High-performance gaming laptop with advanced graphics and fast refresh rate.',
        brand: 'GamerTech',
        model: 'GT-5000',
        dimensions: '38x25x2 cm',
        weight: 2.5,
      ),
      Product(
        id: '10',
        name: 'Running Shoes',
        price: 79.99,
        imageUrl: 'assets/images/running shoes.jpg',
        category: 'Clothing',
        rating: 4.3,
        description: 'Lightweight and breathable running shoes for long-distance comfort.',
        brand: 'SpeedStride',
        model: 'SS-Runner',
        dimensions: '30x15x10 cm',
        weight: 0.8,
      ),
      Product(
        id: '11',
        name: 'Smartphone with Advanced Camera Features',
        price: 799.99,
        imageUrl: 'assets/images/smartphone.jpg',
        category: 'Electronics',
        rating: 4.7,
        description: 'Flagship smartphone equipped with a high-resolution camera and ultra-fast processor.',
        brand: 'TechNova',
        model: 'TN-Ultra',
        dimensions: '16x7x0.8 cm',
        weight: 0.3,
      ),
      Product(
        id: '12',
        name: 'Smart Watch',
        price: 149.99,
        imageUrl: 'assets/images/smartwatch.jpeg',
        category: 'Electronics',
        rating: 4.7,
        description: 'Advanced smartwatch with heart rate monitoring, GPS, and fitness tracking.',
        brand: 'SmartFit',
        model: 'SF-Pro',
        dimensions: '4x4x1 cm',
        weight: 0.1,
      ),
      Product(
        id: '13',
        name: 'Bluetooth Speaker',
        price: 59.99,
        imageUrl: 'assets/images/speaker.jpg',
        category: 'Electronics',
        rating: 4.7,
        description: 'Portable Bluetooth speaker delivering immersive 360° surround sound.',
        brand: 'SoundWave',
        model: 'SW-360',
        dimensions: '18x10x10 cm',
        weight: 0.8,
      ),
      Product(
        id: '14',
        name: 'Organic Green Tea',
        price: 14.99,
        imageUrl: 'assets/images/tea.jpg',
        category: 'Health & Wellness',
        rating: 4.8,
        description: 'Premium organic green tea known for its calming effects and rich antioxidants.',
        brand: 'NatureBrew',
        model: 'NB-GreenTea',
        dimensions: '10x10x15 cm',
        weight: 0.5,
      ),
      Product(
        id: '15',
        name: 'Graphic T-Shirt',
        price: 19.99,
        imageUrl: 'assets/images/tshirt.jpeg',
        category: 'Clothing',
        rating: 4.5,
        description: 'Stylish cotton graphic T-shirt with a trendy design.',
        brand: 'FashionWear',
        model: 'FW-PrintX',
        dimensions: '30x25x1 cm',
        weight: 0.2,
      ),
      Product(
        id: '16',
        name: 'Premium Leather Wallet',
        price: 39.99,
        imageUrl: 'assets/images/wallet.PNG',
        category: 'Accessories',
        rating: 4.4,
        description: 'Elegant leather wallet designed with RFID protection for security.',
        brand: 'LuxWallet',
        model: 'LW-RFID',
        dimensions: '11x9x2 cm',
        weight: 0.2,
      ),
      Product(
        id: '17',
        name: 'Wireless Mouse',
        price: 29.99,
        imageUrl: 'assets/images/wireless.jpeg',
        category: 'Computers',
        rating: 4.6,
        description: 'Ergonomic wireless mouse with customizable buttons and fast response time.',
        brand: 'ClickMaster',
        model: 'CM-X200',
        dimensions: '12x6x4 cm',
        weight: 0.15,
      ),
      Product(
        id: '18',
        name: 'Yoga Mat',
        price: 34.99,
        imageUrl: 'assets/images/yogamat.jpeg',
        category: 'Sports & Fitness',
        rating: 4.5,
        description: 'Durable and cushioned yoga mat designed for superior grip and comfort.',
        brand: 'FlexFlow',
        model: 'FF-MatX',
        dimensions: '180x60x0.6 cm',
        weight: 1.2,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode ? AppTheme.darkTheme.scaffoldBackgroundColor : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _buildTabBarView(),
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
            setState(() {
              isDarkMode = !isDarkMode;
              _preferenceService.setIsDarkMode(isDarkMode);
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() => _currentIndex = 1);
            Navigator.pushNamed(context, '/search');
          },
          color: _currentIndex == 1
              ? isDarkMode ? AppTheme.darkTheme.primaryColor : AppTheme.lightTheme.primaryColor
              : isDarkMode ? AppTheme.darkTheme.textTheme?.bodyLarge?.color : AppTheme.lightTheme.textTheme?.bodyLarge?.color,
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            setState(() => _currentIndex = 2);
            Navigator.pushNamed(context, '/cart');
          },
          color: _currentIndex == 2
              ? isDarkMode ? AppTheme.darkTheme.primaryColor : AppTheme.lightTheme.primaryColor
              : isDarkMode ? AppTheme.darkTheme.textTheme?.bodyLarge?.color : AppTheme.lightTheme.textTheme?.bodyLarge?.color,
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border), // Wishlist icon
          onPressed: () {
            Navigator.pushNamed(context, '/wishlist');
          },
          color: isDarkMode ? AppTheme.darkTheme.textTheme?.bodyLarge?.color : AppTheme.lightTheme.textTheme?.bodyLarge?.color,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
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

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: categories.map((category) {
        final filteredProducts = _filterProductsByCategory(category);
        return ProductListingScreen(
          products: filteredProducts,
          category: category,
          buildPersonalizedGreeting: _buildPersonalizedGreeting,
          buildFeaturedCarousel: _buildFeaturedCarousel,
          buildDealsOfTheDay: _buildDealsOfTheDay,
          buildTrendingSection: _buildTrendingSection,
          buildGridView: _buildGridView,
        );
      }).toList(),
    );
  }



  List<Product> _filterProductsByCategory(String category) {
    return category == 'All'
        ? mockProducts
        : mockProducts.where((p) => p.category == category).toList();
  }

  Widget _buildGridView(List<Product> products) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.57,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppTheme.darkTheme.textTheme?.bodyMedium?.color,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => _currentIndex = index);
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

Widget _buildFeaturedCarousel(List<Product> products) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Featured Products',
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200,
                child: ProductCard(
                  product: products[index],
                  isHorizontal: true,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDealsOfTheDay(List<Product> products) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Deals of the Day',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 210,
                child: ProductCard(
                  product: products[index],
                  isHorizontal: true,
                  showDealTimer: true,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTrendingSection(List<Product> products) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                'Trending Products',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 330,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 210,
                child: ProductCard(
                  product: products[index],
                  isHorizontal: true,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
          ),
        ),
      ],
    ),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;
  final bool showDealTimer;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
    this.showDealTimer = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 450,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: isHorizontal ? 200 : 220,
                  child: Image.asset(
                    product.imageUrl ?? 'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  ),
                ),
                if (showDealTimer)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          'Ends in: 23:59:59',
                          style: const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          product.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                                : AppTheme.lightTheme.textTheme.bodyLarge?.color,
                          ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPlaceholderImage() {
  return Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const Text(
      'Image not available',
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    ),
  );
}