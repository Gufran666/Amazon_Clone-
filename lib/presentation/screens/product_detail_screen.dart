import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: CustomScrollView(
          slivers: [
            _buildImageSection(),
            _buildProductDetailsSection(),
            _buildSpecificationsSection(),
            _buildReviewsSection(),
            _buildRelatedProductsSection(),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _buildIconActionButton(Icons.share),
        _buildIconActionButton(Icons.favorite_border),
      ],
    );
  }

  Widget _buildIconActionButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {},
      ),
    );
  }

  Widget _buildImageSection() {
    return SliverAppBar(
      expandedHeight: 400,
      collapsedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              product.imageUrl ?? 'assets/images/placeholder.png',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(180),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              _buildFavoriteButton(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkTheme.primaryColor,
                  fontFamily: 'OpenSans',
                ),
              ),
              const Spacer(),
              _buildRatingBadge(),
            ],
          ),
          const SizedBox(height: 24),
          _buildFeatureGrid(),
          const SizedBox(height: 24),
          _buildExpandableDescription(),
          const SizedBox(height: 24),
          _buildVideoPreview(),
        ]),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.redAccent.withAlpha(51),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.favorite, color: Colors.redAccent),
        onPressed: () {},
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildFeatureItem(Icons.local_shipping, 'Free Shipping'),
        _buildFeatureItem(Icons.assignment_return, '30-Day Returns'),
        _buildFeatureItem(Icons.verified_user, '2-Year Warranty'),
        _buildFeatureItem(Icons.inventory, 'In Stock'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(51),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildExpandableDescription() {
    return ExpansionTile(
      title: const Text('Product Description',
          style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Text(
          product.description,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/video.jpg',
            fit: BoxFit.cover,
          ),
          const Center(
            child: Icon(
              Icons.play_circle,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Specifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
            children: [
              _buildTableRow('Brand', product.brand),
              _buildTableRow('Model', product.model),
              _buildTableRow('Dimensions', product.dimensions),
              _buildTableRow('Weight', product.weight.toString()),
            ],
          ),
        ]),
      ),
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: TextStyle(color: Colors.grey.shade400)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              const Text('Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          _buildReviewItem('Excellent product!', 5),
          _buildReviewItem('Good quality', 4),
          _buildReviewItem('Not as expected', 3),
        ]),
      ),
    );
  }

  Widget _buildReviewItem(String comment, int rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star,
              color: index < rating ? Colors.amber : Colors.grey,
              size: 16,
            )),
          ),
          const SizedBox(height: 8),
          Text(comment),
        ],
      ),
    );
  }

  Widget _buildRelatedProductsSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Related Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 150,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Related Product $index',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${(product.price * 0.8).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppTheme.darkTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton('Add to Cart', Icons.shopping_cart, onPressed: () {}),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              'Buy Now',
              Icons.payment,
              onPressed: () {},
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, {
    required VoidCallback onPressed, bool isPrimary = false
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppTheme.darkTheme.primaryColor
            : Colors.grey.shade800,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      icon: Icon(icon, size: 20),
      label: Text(text),
      onPressed: onPressed,
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text('(1.2k)', style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}