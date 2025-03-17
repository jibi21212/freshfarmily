import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart' as custom;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Dummy product list with a defined category.
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Fresh Apples',
      price: 3.99,
      description: 'Crisp, fresh apples from local orchards.',
      imageUrl: 'https://via.placeholder.com/300x150?text=Apples',
      rating: 4.5,
      category: 'Fruits',
    ),
    Product(
      id: '2',
      name: 'Organic Bananas',
      price: 2.50,
      description: 'Ripe organic bananas, packed with nutrients.',
      imageUrl: 'https://via.placeholder.com/300x150?text=Bananas',
      rating: 4.0,
      category: 'Fruits',
    ),
    Product(
      id: '3',
      name: 'Crunchy Carrots',
      price: 1.99,
      description: 'Sweet and crunchy carrots perfect for a snack.',
      imageUrl: 'https://via.placeholder.com/300x150?text=Carrots',
      rating: 3.5,
      category: 'Vegetables',
    ),
    Product(
      id: '4',
      name: 'Grass-fed Beef',
      price: 8.99,
      description: 'High-quality beef from grass-fed cattle.',
      imageUrl: 'https://via.placeholder.com/300x150?text=Beef',
      rating: 4.2,
      category: 'Meat',
    ),
    Product(
      id: '5',
      name: 'Organic Milk',
      price: 4.50,
      description: 'Fresh organic milk from grass-fed cows.',
      imageUrl: 'https://via.placeholder.com/300x150?text=Milk',
      rating: 4.0,
      category: 'Dairy',
    ),
  ];

  String _searchQuery = '';

  // Price filter variables – adjust these min and max bounds as needed.
  double _priceFilterStart = 0.0;
  double _priceFilterEnd = 10.0;

  // A set to hold the selected categories. If empty, no category filtering is applied.
  final Set<String> _selectedCategories = {};

  // Predefined available categories.
  final List<String> _availableCategories = ['Fruits', 'Vegetables', 'Meat', 'Dairy'];

  // Get filtered products based on search query, price, and selected categories.
  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesText = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPrice =
          product.price >= _priceFilterStart && product.price <= _priceFilterEnd;
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains(product.category);
      return matchesText && matchesPrice && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          // Centralized dynamic SearchBar widget.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: custom.SearchBar(
              role: custom.UserRole.buyer, // Assuming this is for buyers.
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Filter section combining price filter and category selection.
          ExpansionTile(
            title: const Text("Filters"),
            initiallyExpanded: true,
            children: [
              // Price range filter.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price Range",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: RangeValues(_priceFilterStart, _priceFilterEnd),
                      min: 0,
                      max: 10,
                      divisions: 20,
                      labels: RangeLabels(
                        "\$${_priceFilterStart.toStringAsFixed(2)}",
                        "\$${_priceFilterEnd.toStringAsFixed(2)}",
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceFilterStart = values.start;
                          _priceFilterEnd = values.end;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Category selection using FilterChips.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  children: _availableCategories.map((cat) {
                    final selected = _selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            _selectedCategories.add(cat);
                          } else {
                            _selectedCategories.remove(cat);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          // List of filtered products.
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: _filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}