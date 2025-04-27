import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isPulsing = false;

  @override
  void initState() {
    super.initState();
    _removeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _startPulseAnimation();
  }

  @override
  void dispose() {
    _removeController.dispose();
    super.dispose();
  }

  void _startPulseAnimation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _isPulsing = !_isPulsing;
        });
      }
    });
  }

  void _removeItem() {
    _removeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onRemove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _removeController,
      builder: (context, child) {
        return Opacity(
          opacity: 1 - _removeController.value,
          child: Transform(
            transform: Matrix4.identity()..translate(0, _removeController.value * 50),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Image.network(
                      widget.product.imageUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
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
                                scale: _isPulsing
                                    ? Tween<double>(begin: 0.9, end: 1.1).animate(
                                  CurvedAnimation(
                                    parent: _removeController,
                                    curve: const Interval(0, 1, curve: Curves.easeInOut),
                                  ),
                                )
                                    : Tween<double>(begin: 1.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _removeController,
                                    curve: const Interval(0, 1, curve: Curves.easeInOut),
                                  ),
                                ),
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
      },
    );
  }
}