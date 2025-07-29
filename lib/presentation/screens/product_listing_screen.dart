import 'package:amazon_clone/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone/presentation/providers/home_providers.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';


class ProductListingScreen extends ConsumerWidget {
  final String category;
  final List<Product> products;

  const ProductListingScreen({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.darkTheme.scaffoldBackgroundColor
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPersonalizedGreeting(context, isDarkMode),
              const SizedBox(height: 20),
              _buildFeaturedCarousel(products, isDarkMode),
              const SizedBox(height: 20),
              _buildDealsOfTheDay(products, isDarkMode),
              const SizedBox(height: 20),
              _buildTrendingSection(products, isDarkMode),
              const SizedBox(height: 20),
              _buildGridView(products, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPersonalizedGreeting(BuildContext context, bool isDarkMode) {
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
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _buildFeaturedCarousel(List<Product> products, bool isDarkMode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Featured Products',
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: isDarkMode ? Colors.white : Colors.black,
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
  );
}

Widget _buildDealsOfTheDay(List<Product> products, bool isDarkMode) {
  return Column(
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
              color: isDarkMode ? Colors.white : Colors.black,
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
  );
}

Widget _buildTrendingSection(List<Product> products, bool isDarkMode) {
  return Column(
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
                color: isDarkMode ? Colors.white : Colors.black,
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
  );
}

Widget _buildGridView(List<Product> products, bool isDarkMode) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.55,
      crossAxisSpacing: 16,
      mainAxisSpacing: 26,
    ),
    itemCount: products.length,
    itemBuilder: (context, index) {
      return ProductCard(product: products[index]);
    },
  );
}

class ProductCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    final Color backgroundColor = isDarkMode ? Colors.cyan.shade800 : Colors.yellowAccent;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return SizedBox(
      width: 400,
      height: 400,
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
          color: backgroundColor,
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
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
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
                            style: TextStyle(
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