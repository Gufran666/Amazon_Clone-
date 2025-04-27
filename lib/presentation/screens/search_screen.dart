import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/screens/product_detail_screen.dart';
import 'package:amazon_clone/core/services/preference_service.dart';
import 'package:amazon_clone/presentation/screens/empty_search_results_screen.dart';

import 'checkout_review_screen.dart';
import 'home_screen.dart';
import 'no_internet_screen.dart';
import 'order_confirmation_screen.dart';
import 'order_history_screen.dart';
import 'order_tracking_map_screen.dart';
import 'payment_method_screen.dart';
import 'profile_overview_screen.dart';
import 'server_error_screen.dart';
import 'shipping_address_screen.dart';
import 'shopping_cart_screen.dart';
import 'wish_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final PreferenceService _preferenceService;
  bool isDarkMode = true;
  late TextEditingController _searchController;
  late List<Product> mockProducts;
  late List<Product> filteredProducts;
  bool isLoading = false;
  String selectedCategory = 'All';
  double minPrice = 0.0;
  double maxPrice = 1000.0;

  @override
  void initState() {
    super.initState();
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
    _searchController = TextEditingController();
    mockProducts = _initializeMockProducts();
    filteredProducts = List.from(mockProducts);
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  List<Product> _initializeMockProducts() {
    return [
      Product(
        id: '1',
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
        id: '2',
        name: 'Smartphone',
        price: 699.99,
        imageUrl: 'assets/images/smartphone.jpg',
        category: 'Electronics',
        rating: 4.8,
        description: 'High-performance smartphone with an advanced camera and powerful processor.',
        brand: 'TechNova',
        model: 'TN-Ultra',
        dimensions: '16x7x0.8 cm',
        weight: 0.3,
      ),
      Product(
        id: '3',
        name: 'Laptop',
        price: 899.99,
        imageUrl: 'assets/images/laptop.jpeg',
        category: 'Electronics',
        rating: 4.7,
        description: 'Lightweight and powerful laptop with a high refresh rate display.',
        brand: 'GamerTech',
        model: 'GT-5000',
        dimensions: '38x25x2 cm',
        weight: 2.5,
      ),
      Product(
        id: '4',
        name: 'Graphic T-Shirt',
        price: 29.99,
        imageUrl: 'assets/images/tshirt.jpeg',
        category: 'Clothing',
        rating: 4.2,
        description: 'Stylish cotton graphic T-shirt with a trendy design.',
        brand: 'FashionWear',
        model: 'FW-PrintX',
        dimensions: '30x25x1 cm',
        weight: 0.2,
      ),
      Product(
        id: '5',
        name: 'Classic Blue Jeans',
        price: 49.99,
        imageUrl: 'assets/images/jeans.jpeg',
        category: 'Clothing',
        rating: 4.0,
        description: 'Durable denim jeans with a comfortable fit and timeless style.',
        brand: 'DenimEdge',
        model: 'DE-Classic',
        dimensions: '100x40x2 cm',
        weight: 0.8,
      ),
      Product(
        id: '6',
        name: 'Modern Coffee Table',
        price: 149.99,
        imageUrl: 'assets/images/coffee table.jpeg',
        category: 'Furniture',
        rating: 4.3,
        description: 'Elegant coffee table with a wooden finish and sturdy build.',
        brand: 'HomeStyle',
        model: 'HS-WoodX',
        dimensions: '90x60x40 cm',
        weight: 15.0,
      ),
    ];
  }

  void _performSearch(String query) {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      List<Product> results = mockProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) &&
            (selectedCategory == 'All' || product.category == selectedCategory) &&
            product.price >= minPrice &&
            product.price <= maxPrice;
      }).toList();

      setState(() {
        isLoading = false;
        filteredProducts.clear();
        filteredProducts.addAll(results);
      });

      if (results.isEmpty && query.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmptySearchResultsScreen(searchQuery: query),
          ),
        );
      }
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                filteredProducts.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                )
                    : const Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products',
          hintStyle: TextStyle(
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme?.bodyMedium?.color
                : AppTheme.lightTheme.textTheme?.bodyMedium?.color,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                filteredProducts = [];
              });
            },
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        ),
        style: TextStyle(
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme?.bodyLarge?.color
              : AppTheme.lightTheme.textTheme?.bodyLarge?.color,
        ),
        onSubmitted: (value) {
          _performSearch(value);
        },
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
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
              items: [
                'All',
                'Electronics',
                'Clothing',
                'Furniture',
              ].map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Min Price'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() => minPrice = double.tryParse(value) ?? 0.0);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Max Price'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() => maxPrice = double.tryParse(value) ?? 1000.0);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performSearch(_searchController.text);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }



  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // Set to 1 since this is the Search screen
      selectedItemColor: Colors.white,
      unselectedItemColor: AppTheme.darkTheme.textTheme?.bodyMedium?.color,
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

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                height: 200,
                child: Image.asset(
                  product.imageUrl ?? 'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                ),
              ),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
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
              ),
            ],
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