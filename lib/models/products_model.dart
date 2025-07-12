class Product {
  final String id;
  final String image;
  final String name;
  final String description;
  final String brand;
  final double price;
  final Map<String, dynamic> specs;
  final double rating;
  final int stock;
  final List<String> categories;
  final bool isBestSeller;
  final bool isPopular;




  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.brand,
    required this.price,
    required this.specs,
    required this.rating,
    required this.stock,
    required this.categories,
    required this.isBestSeller,
    required this.isPopular,

  });

  // ✅ fromFirestore constructor
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    print("📄 Firestore data: $data"); // ✅ Add this also
    return Product(
      id: id,
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      brand: data['brands'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      specs: Map<String, dynamic>.from(data['specs'] ?? {}),
      rating: double.tryParse(data['rating'].toString()) ?? 0.0,
      stock: data['stock'] ?? 0,
      categories: List<String>.from(data['categories'] ?? []),
      isBestSeller: data['isBestSeller'] ?? false,
      isPopular: data['isPopular'] ?? false,

    );
  }
}
