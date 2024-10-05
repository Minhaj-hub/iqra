import 'package:flutter/material.dart';
import '../data/dua.dart'; // Correct import
import 'dua_detail_screen.dart';

class DhikrDuaSearchDelegate extends SearchDelegate<Dua?> {
  final List<Dua> allDuas;

  DhikrDuaSearchDelegate(this.allDuas) : super(searchFieldLabel: "Search by Dhikr or Dua");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allDuas.where((dua) {
      return dua.title.toLowerCase().contains(query.toLowerCase()) ||
          dua.category.toLowerCase().contains(query.toLowerCase()) ||
          dua.translation.toLowerCase().contains(query.toLowerCase()) ||
          dua.transliteration.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildResultList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allDuas.where((dua) {
      return dua.title.toLowerCase().contains(query.toLowerCase()) ||
          dua.category.toLowerCase().contains(query.toLowerCase()) ||
          dua.translation.toLowerCase().contains(query.toLowerCase()) ||
          dua.transliteration.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildResultList(context, suggestions);
  }

  Widget _buildResultList(BuildContext context, List<Dua> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final Dua result = results[index];
        return ListTile(
          title: Text(result.title),
          subtitle: Text(result.category),
          onTap: () {
            close(context, result); // Return the selected Dua
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DuaDetailScreen(
      duas: [result], // Pass the search result in a list
      index: 0,       // Single dua, so the index is 0
    ),
  ),
);
          },
        );
      },
    );
  }
}
