class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String category;
  final double rating;
  final int quantity;
  final String description;
  final String brand;
  final String model;
  final String dimensions;
  final double weight;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.rating,
    this.quantity = 1,
    required this.description,
    required this.brand,
    required this.model,
    required this.dimensions,
    required this.weight,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? quantity,
    String? description,
    String? brand,
    String? model,
    String? dimensions,
    double? weight,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
    );
  }
}
