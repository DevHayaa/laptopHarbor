class Brand {
  final String id;
  final String name;
  final String description;
  final String logo;

  Brand({required this.id, required this.name, required this.description, required this.logo});

  factory Brand.fromMap(String id, Map<String, dynamic> data) {
    return Brand(
      id: id,
      name: data['name'],
      description: data['description'],
      logo: data['logo'],
    );
  }
}
