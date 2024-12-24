import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/services/global_search_api_service.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/features/search/data/models/global_search_model.dart';

import '../../../../cores/constants/app_colors.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/service_locator.dart';

class GlobalSearchView extends StatefulWidget {
  @override
  _GlobalSearchViewState createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends State<GlobalSearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> results = [];

  // Filter options
  String _selectedCategory = 'Global';
  String _selectedSubCategory = 'user';
  final Map<String, List<String>> _categories = {
    'Global': ['user', 'group', 'channel', 'message'],
    'Messages': ['all', 'text', 'image', 'video', 'link'],
  };
  final Map<String, String> _globalAttributes = {
    'user': 'uuid',
    'group': 'name',
    'channel': 'name',
    'message': 'message'
  };

  void search(String category, String subCategory, String query) async {
    if (category == 'Global') {
      String attribute = _globalAttributes[subCategory]!;
      final response = await getit
          .get<GlobalSearchApiService>()
          .globalSearch(subCategory, attribute, query);

      setState(() {
        results = response.results;
      });
    } else {
      final respone = await getit
          .get<GlobalSearchApiService>()
          .searchMessages(query, subCategory);
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
              onChanged: (query) {
                search(_selectedCategory, _selectedSubCategory, query);
              },
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
                        _selectedSubCategory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // backgroundImage: !hasPhoto
                    //     ? AssetImage(userPhoto)
                    //     : NetworkImage(userPhoto) as ImageProvider,
                    backgroundImage: (results[index].picture != null)
                        ? NetworkImage(results[index].picture!) as ImageProvider
                        : AssetImage('assets/images/logo.png'),
                  ),
                  title: Text(
                    results[index].title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    results[index].subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
