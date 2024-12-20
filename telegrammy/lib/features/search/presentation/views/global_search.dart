import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/styles/styles.dart';

import '../../../../cores/constants/app_colors.dart';
import '../../../../cores/routes/route_names.dart';

class GlobalSearchView extends StatefulWidget {
  @override
  _GlobalSearchViewState createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends State<GlobalSearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  // Filter options
  String _selectedCategory = 'Global';
  String? _selectedSubCategory = 'user';
  final Map<String, List<String>> _categories = {
    'Global': ['user', 'group', 'channel', 'message'],
    'Messages': ['all', 'text', 'image', 'video', 'link'],
  };

  // Mock function to simulate searching
  void search(String query) {
    // Replace this with your actual search logic
    final allItems = [
      "Apple",
      "Banana",
      "Cherry",
      "Date",
      "Elderberry",
      "Fig",
      "Grape",
      "Honeydew",
    ];

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    } else {
      setState(() {
        _searchResults = allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('ProfileSettingsBackButton'),
          onPressed: () => context.goNamed(RouteNames.chats),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Global Search Page',
          style: textStyle17.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Search results
          // Filter buttons
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Row(
              children: [
                // First filter: Category
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories.keys
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _selectedSubCategory =
                            _categories[value]!.first; // Reset subcategory
                      });
                    },
                  ),
                ),
                SizedBox(width: 30),
                // Second filter: Subcategory
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubCategory,
                    items: (_categories[_selectedCategory] ?? [])
                        .map((subCategory) => DropdownMenuItem(
                              value: subCategory,
                              child: Text(subCategory),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
