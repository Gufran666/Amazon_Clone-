import 'package:amazon_clone/core/models/products.dart';
import 'package:amazon_clone/core/models/user_profile.dart';
import 'package:logger/logger.dart';

final logger = Logger();

abstract class RecommendationService {
  Future<List<Product>> getRecommendations(UserProfile userProfile);
}

class MockRecommendationService implements RecommendationService {
  @override
  Future<List<Product>> getRecommendations(UserProfile userProfile) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return [
        Product(
          id: '1',
          name: 'Wireless Headphones',
          price: 99.99,
          imageUrl: 'assets/images/headphones.jpeg',
          category: 'Electronics',
          rating: 4.5,
          description: 'Premium wireless headphones with active noise cancellation and deep bass.',
          brand: 'AudioTech',
          model: 'AT-X100',
          dimensions: '15x8x3 cm',
          weight: 0.5,
        ),
        Product(
          id: '2',
          name: 'Smart Watch',
          price: 149.99,
          imageUrl: 'assets/images/smartwatch.jpeg',
          category: 'Electronics',
          rating: 4.7,
          description: 'Advanced smartwatch with heart rate monitoring, GPS, and fitness tracking.',
          brand: 'SmartFit',
          model: 'SF-Pro',
          dimensions: '4x4x1 cm',
          weight: 0.1,
        ),
        Product(
          id: '3',
          name: 'Bluetooth Speaker',
          price: 79.99,
          imageUrl: 'assets/images/speaker.jpg',
          category: 'Electronics',
          rating: 4.2,
          description: 'Portable Bluetooth speaker delivering immersive 360° surround sound.',
          brand: 'SoundWave',
          model: 'SW-360',
          dimensions: '18x10x10 cm',
          weight: 0.8,
        ),
      ];

    } catch (e, stackTrace) {
      logger.e('Error getting recommendations: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}

class RecommendationServiceFactory {
  static RecommendationService create() {
    return MockRecommendationService();
  }
}
