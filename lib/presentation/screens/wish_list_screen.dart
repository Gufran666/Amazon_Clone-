import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/presentation/widgets/wish_list_item_card.dart';

import '../../core/services/preference_service.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shareButtonController;
  List<Product> wishListItems = [];

  bool _isSharing = false;
  bool isDarkMode = true;
  late final PreferenceService _preferenceService;
  String _selectedSortOption = 'Newest';

  @override
  void initState() {
    super.initState();
    wishListItems = [];
    _shareButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    _shareButtonController.dispose();
    super.dispose();
  }

  void _shareWishList() async {
    try {
      await HapticFeedback.lightImpact();
      setState(() {
        _isSharing = true;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      // Implement sharing logic here
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  void _sortWishList(String option) {
    setState(() {
      _selectedSortOption = option;
      switch (option) {
        case 'Price: Low to High':
          wishListItems.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          wishListItems.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Rating':
          wishListItems.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        default: // Newest
        // No sorting needed for "Newest"
          break;
      }
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
        'Wish List',
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
          onSelected: _sortWishList,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Newest',
              child: Row(
                children: [
                  Text('Newest'),
                  if (_selectedSortOption == 'Newest')
                    const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Price: Low to High',
              child: Row(
                children: [
                  Text('Price: Low to High'),
                  if (_selectedSortOption == 'Price: Low to High')
                    const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Price: High to Low',
              child: Row(
                children: [
                  Text('Price: High to Low'),
                  if (_selectedSortOption == 'Price: High to Low')
                    const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Rating',
              child: Row(
                children: [
                  Text('Rating'),
                  if (_selectedSortOption == 'Rating')
                    const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
          ],
          icon: Icon(
            Icons.sort,
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          ),
        ),
        IconButton(
          icon: _isSharing
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Icon(
            Icons.share,
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium!.color
                : AppTheme.lightTheme.textTheme.bodyMedium!.color,
          ),
          onPressed: _shareWishList,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),

          wishListItems.isEmpty
              ? const Expanded(child: EmptyWishListIllustration()) // ✅ Displays empty state when list is empty
              : Expanded(
            child: ListView.builder(
              itemCount: wishListItems.length,
              itemBuilder: (context, index) {
                return WishListItemCard(
                  product: wishListItems[index],
                  onRemove: () => setState(() => wishListItems.removeAt(index)),
                );
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }



  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 4,
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

class EmptyWishListIllustration extends StatelessWidget {
  const EmptyWishListIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/wishlist.jpg',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Your wish list is empty',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Browse products and add them to your wish list',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
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
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}