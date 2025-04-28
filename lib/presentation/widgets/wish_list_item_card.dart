import 'package:flutter/material.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';

class WishListItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;

  const WishListItemCard({
    super.key,
    required this.product,
    required this.onRemove,
  });

  @override
  State<WishListItemCard> createState() => _WishListItemCardState();
}

class _WishListItemCardState extends State<WishListItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _removeController;
  late AnimationController _pulseController; // Declare late variable

  @override
  void initState() {
    super.initState();

    // Initialize remove animation
    _removeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // ✅ Initialize pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _removeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _removeItem() {
    _removeController.forward().then((_) {
      if (mounted) {
        widget.onRemove();
        _removeController.reset(); // Reset for next item
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1 - _removeController.value,
      duration: const Duration(milliseconds: 300),
      child: Transform.translate(
        offset: Offset(0, _removeController.value * 50), // Slide effect on removal
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  widget.product.imageUrl ?? 'assets/images/placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                            onPressed: _removeItem,
                          ),
                          const Spacer(),
                          ScaleTransition(
                            scale: _pulseController,
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: AppTheme.darkTheme.primaryColor,
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
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
}
