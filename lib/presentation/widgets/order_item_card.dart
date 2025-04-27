import 'package:flutter/material.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/products.dart';

class OrderItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;

  const OrderItemCard({
    super.key,
    required this.product,
    required this.onEdit,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(
              product.imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)} x ${product.quantity}',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                    ),
                  )
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: onEdit,
            )
          ],
        ),
      ),
    );
  }
}