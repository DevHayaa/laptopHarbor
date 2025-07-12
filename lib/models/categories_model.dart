class Category {
  final String id;
  final String name;
  final String description;
  final String image;

  Category({required this.id, required this.name, required this.description, required this.image});

  factory Category.fromMap(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'],
      description: data['description'],
      image: data['image'],
    );
  }
}
