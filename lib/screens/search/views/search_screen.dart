import 'package:flutter/material.dart';

import '../../business/views/business_screen.dart';
import '../../gaming/views/gaming_screen.dart';
import '../../on_sale/views/on_sale_screen.dart';
import '../../student/views/student_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> fixedCategories = [
    "business",
    "gaming",
    "on_sale",
    "student",
  ];

  void _navigateToCategory(String categoryName) {
    Widget screen;

    switch (categoryName.toLowerCase()) {
      case 'business':
        screen = const BusinessScreen();
        break;
      case 'gaming':
        screen = const GamingProductsSlider();
        break;
      case 'on_sale':
        screen = const OnSaleScreen();
        break;
      case 'student':
        screen = const StudentScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No matching category found")),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _handleSearchSubmit(String value) {
    final query = value.trim().toLowerCase();
    _navigateToCategory(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: _handleSearchSubmit,
        ),
      ),
    );
  }
}
