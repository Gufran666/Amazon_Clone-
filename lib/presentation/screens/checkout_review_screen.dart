import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/screens/order_confirmation_screen.dart';
import 'package:amazon_clone/presentation/screens/payment_method_screen.dart';
import 'package:amazon_clone/presentation/screens/shipping_address_screen.dart';
import 'package:amazon_clone/presentation/widgets/order_item_card.dart';
import 'package:amazon_clone/core/services/preference_service.dart';

class CheckoutReviewScreen extends StatefulWidget {
  const CheckoutReviewScreen({super.key});

  @override
  State<CheckoutReviewScreen> createState() => _CheckoutReviewScreenState();
}

class _CheckoutReviewScreenState extends State<CheckoutReviewScreen> with TickerProviderStateMixin {
  late AnimationController _confirmationDialogController;
  late AnimationController _editButtonController;
  late final PreferenceService _preferenceService;
  bool isDarkMode = true;
  bool _isProcessingOrder = false;
  bool _showShippingDetails = false;
  bool _showPaymentDetails = false;

  List<Product> cartItems = [
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 149.99,
      imageUrl: 'assets/images/smartwatch.jpeg',
      category: 'Electronics',
      rating: 4.7,
      quantity: 1,
      description: 'Advanced smartwatch with heart rate monitoring, GPS, and fitness tracking.',
      brand: 'SmartFit',
      model: 'SF-Pro',
      dimensions: '4x4x1 cm',
      weight: 0.1,
    ),
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

  double taxRate = 0.08;
  double shippingFee = 5.99;

  @override
  void initState() {
    super.initState();
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
    _confirmationDialogController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _editButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  void dispose() {
    _confirmationDialogController.dispose();
    _editButtonController.dispose();
    super.dispose();
  }

  Widget _buildPlaceOrderButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(128),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
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
            textStyle: const TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          onPressed: _placeOrder,
          child: _isProcessingOrder
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text('Place Order'),
        ),
      ),
    );
  }


  void _placeOrder() async {
    setState(() {
      _isProcessingOrder = true;
    });

    try {
      await HapticFeedback.heavyImpact();
      _confirmationDialogController.forward();
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to order confirmation screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderConfirmationScreen(),
        ),
      );
    } finally {
      setState(() {
        _isProcessingOrder = false;
      });
      _confirmationDialogController.reverse();
    }
  }

  double _calculateTotal() {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));
    double tax = subtotal * taxRate;
    return subtotal + tax + shippingFee;
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
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? AppTheme.darkTheme.scaffoldBackgroundColor
              : AppTheme.lightTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                : AppTheme.lightTheme.textTheme.bodyMedium?.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Order Review',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                  : AppTheme.lightTheme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildItemList(),
                const SizedBox(height: 24),
                _buildSummarySection(),
                const SizedBox(height: 24),
                _buildShippingDetails(),
                const SizedBox(height: 24),
                _buildPaymentDetails(),
                const SizedBox(height: 32),
                _buildPlaceOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Order Items',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return OrderItemCard(
                    product: cartItems[index],
                    onEdit: () {
                      _showEditOptions(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
            _buildSummaryRow('Tax (${(taxRate * 100).toStringAsFixed(0)}%)', '\$${tax.toStringAsFixed(2)}'),
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
                ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                : AppTheme.lightTheme.textTheme.bodyMedium?.color,
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
                ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                : AppTheme.lightTheme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingDetails() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping Details',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showShippingDetails ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isDarkMode
                        ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                        : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _showShippingDetails = !_showShippingDetails;
                    });
                  },
                ),
              ],
            ),
            if (_showShippingDetails) const SizedBox(height: 16),
            if (_showShippingDetails)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '123 Main Street',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Apt 4B',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'New York, NY 10001',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(555) 123-4567',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
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
                      _showEditAnimation(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShippingAddressScreen(),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Shipping'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showPaymentDetails ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isDarkMode
                        ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                        : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPaymentDetails = !_showPaymentDetails;
                    });
                  },
                ),
              ],
            ),
            if (_showPaymentDetails) const SizedBox(height: 16),
            if (_showPaymentDetails)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ending in 4567',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Digital Wallet',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                          : AppTheme.lightTheme.textTheme.bodyMedium?.color,
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
                      _showEditAnimation(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodScreen(),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Payment'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showEditAnimation(VoidCallback onEdit) async {
    try {
      await HapticFeedback.lightImpact();
      _editButtonController.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      onEdit();
    } finally {
      _editButtonController.reverse();
    }
  }

  void _showEditOptions(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Edit Item',
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                : AppTheme.lightTheme.textTheme.bodyLarge?.color,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cartItems[index].name,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                    : AppTheme.lightTheme.textTheme.bodyMedium?.color,
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
                Navigator.pop(context);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Change Quantity'),
            ),
            const SizedBox(height: 12),
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
                _showEditAnimation(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShippingAddressScreen(),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Shipping'),
            ),
          ],
        ),
      ),
    );
  }
}