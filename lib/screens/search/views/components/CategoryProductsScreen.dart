import 'package:flutter/material.dart';

import '../../../../models/categories_model.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Center(
        child: Text("Products under '${category.name}' category will be shown here."),
      ),
    );
  }
}
