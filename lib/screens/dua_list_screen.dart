import 'package:flutter/material.dart';
import 'dua_detail_screen.dart';
import '../data/dua.dart'; 

class DuaListScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Dua> duas;

  const DuaListScreen({super.key, required this.categoryTitle, required this.duas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemCount: duas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index + 1}. ${duas[index].title}'),
            onTap: () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DuaDetailScreen(
      duas: duas,   // Pass the entire list of duas
      index: index, // Pass the index of the selected dua
    ),
  ),
);
            },
          );
        },
      ),
    );
  }
}
