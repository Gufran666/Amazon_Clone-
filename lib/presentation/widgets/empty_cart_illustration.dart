import 'package:flutter/material.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';

class EmptyCartIllustration extends StatelessWidget {
  const EmptyCartIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Browse products and add them to your cart to see them here.',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkTheme.primaryColor,
              foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              textStyle: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}