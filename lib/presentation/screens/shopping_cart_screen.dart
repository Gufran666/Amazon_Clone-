import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/widgets/cart_item_card.dart';
import 'package:amazon_clone/presentation/widgets/empty_cart_illustration.dart';

import '../../core/services/preference_service.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _checkoutButtonController;
  List<Product> cartItems = [];
  final double taxRate = 0.08;
  final double shippingFee = 5.99;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;


  List<Product> mockProducts = [
    Product(
      id: '7',
      name: 'Smartphone with Advanced Camera Features',
      price: 799.99,
      imageUrl: 'assets/images/smartphone.jpg',
      category: 'Electronics',
      rating: 4.7,
      quantity: 1,
      description: 'Flagship smartphone with a high-resolution camera, ultra-fast processor, and stunning display.',
      brand: 'TechNova',
      model: 'TN-Ultra',
      dimensions: '16x7x0.8 cm',
      weight: 0.3,
    ),
    Product(
      id: '10',
      name: 'High-Quality Yoga Mat with Extra Cushioning',
      price: 34.99,
      imageUrl: 'assets/images/yogamat.jpeg',
      category: 'Sports & Fitness',
      rating: 4.5,
      quantity: 1,
      description: 'Durable and cushioned yoga mat designed for superior grip and comfort.',
      brand: 'FlexFlow',
      model: 'FF-MatX',
      dimensions: '180x60x0.6 cm',
      weight: 1.2,
    ),
    Product(
      id: '12',
      name: 'Bluetooth Speaker with 360° Surround Sound',
      price: 59.99,
      imageUrl: 'assets/images/speaker.jpg',
      category: 'Electronics',
      rating: 4.7,
      quantity: 1,
      description: 'Portable Bluetooth speaker delivering immersive 360° surround sound.',
      brand: 'SoundWave',
      model: 'SW-360',
      dimensions: '18x10x10 cm',
      weight: 0.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkoutButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
    // Initialize cartItems with mock products
    cartItems = List.from(mockProducts);
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  void dispose() {
    _checkoutButtonController.dispose();
    super.dispose();
  }

  void _removeItemFromCart(int index) {
    final removedItem = cartItems[index];
    setState(() {
      cartItems.removeAt(index);
    });
    _showSnackbar('${removedItem.name} removed from Cart');
  }

  void _adjustQuantity(int index, int value) async {
    if (value < 1) return;
    setState(() {
      cartItems[index] = cartItems[index].copyWith(quantity: value);
    });
    await HapticFeedback.lightImpact();
  }

  double _calculateTotal() {
    final subtotal = cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));
    final tax = subtotal * taxRate;
    return subtotal + tax + shippingFee;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
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
        body: cartItems.isEmpty
            ? const EmptyCartIllustration()
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(
                      product: cartItems[index],
                      onRemove: () => _removeItemFromCart(index),
                      onQuantityChanged: (value) => _adjustQuantity(index, value),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSummarySection(),
              const SizedBox(height: 16),
              _buildCheckoutButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
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
      title: Text(
        'Shopping Cart',
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
          icon: const Icon(Icons.delete),
          color: isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
              : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            setState(() {
              cartItems.clear();
            });
            _showSnackbar('All items removed from cart');
          },
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    final subtotal = cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));
    final tax = subtotal * taxRate;

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
            const SizedBox(height: 12),
            _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow('Tax (${(taxRate * 100).toStringAsFixed(2)}%)', '\$${tax.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow('Shipping', '\$${shippingFee.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Total',
              '\$${_calculateTotal().toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: isTotal ? 18 : 16,
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
            fontSize: isTotal ? 18 : 16,
            color: isTotal
                ? isDarkMode
                ? AppTheme.darkTheme.primaryColor
                : AppTheme.lightTheme.primaryColor
                : isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.primaryColor
            : AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        textStyle: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        try {
          await HapticFeedback.heavyImpact();
          Navigator.pushNamed(context, '/checkout');
        } catch (e) {
          // Handle error
        }
      },
      child: const Text('Proceed to Checkout'),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
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