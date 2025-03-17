class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final String category; // e.g., "Fruits", "Vegetables", "Meat", etc.

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl = 'https://via.placeholder.com/150',
    this.rating = 0.0,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      rating: json['rating']?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Others',
    );
  }
}