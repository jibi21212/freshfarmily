// What the product is


class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String company;
  final DateTime posted;
  final String description;
  final String category;
  final int quantity;
  final DateTime? harvestDate;
  final DateTime? expiryDate;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.company,
    required this.posted,
    this.description = '',
    this.category = '',
    this.quantity = 0,
    this.harvestDate,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'company': company,
      'posted': posted.toIso8601String(),
      'description': description,
      'category': category,
      'quantity': quantity,
      'harvestDate': harvestDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      company: json['company'] as String,
      posted: DateTime.parse(json['posted'] as String),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      harvestDate: json['harvestDate'] != null
          ? DateTime.parse(json['harvestDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
    );
  }
}