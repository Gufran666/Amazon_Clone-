import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/core/models/products.dart';

class CartItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _removeController;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _removeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _quantity = (widget.product.quantity ?? 1).clamp(1, 9999);
  }

  @override
  void dispose() {
    _removeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _removeController,
      builder: (context, child) {
        return Opacity(
          opacity: 1 - _removeController.value,
          child: Transform.translate(
            offset: Offset(0, _removeController.value * 50),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildProductImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name ?? 'Unnamed Product',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${(widget.product.price ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          color: Colors.grey,
                          tooltip: 'Decrease quantity',
                          onPressed: () async {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                              await HapticFeedback.lightImpact();
                              widget.onQuantityChanged(_quantity);
                            }
                          },
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.grey,
                          tooltip: 'Increase quantity',
                          onPressed: () async {
                            setState(() {
                              _quantity++;
                            });
                            await HapticFeedback.lightImpact();
                            widget.onQuantityChanged(_quantity);
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.grey,
                          tooltip: 'Remove from cart',
                          onPressed: () async {
                            await _removeController.forward();
                            await Future.delayed(const Duration(milliseconds: 50));
                            widget.onRemove();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty) {
      return Image.asset(
        widget.product.imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.grey,
          );
        },
      );
    } else {
      return const Icon(
        Icons.image_not_supported,
        size: 80,
        color: Colors.grey,
      );
    }
  }
}
