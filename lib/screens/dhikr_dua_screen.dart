import 'package:Iqra/provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/dua.dart'; // Correct import
import 'dua_list_screen.dart';

class DhikrDuaScreen extends StatefulWidget {
  @override
  const DhikrDuaScreen({super.key});

  @override
  DhikrDuaScreenState createState() => DhikrDuaScreenState();
}

class DhikrDuaScreenState extends State<DhikrDuaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _duas;
  List<Dua> _allDuas = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDuas();
  }

  Future<void> _loadDuas() async {
    final String response = await rootBundle.loadString('assets/duas.json');
    final data = json.decode(response);
    setState(() {
      _duas = data;
      _allDuas = (data['main'] as List).expand((category) {
        String categoryName = category['category'];
        return (category['duas'] as List)
            .map((dua) => Dua.fromJson(dua, categoryName))
            .toList();
      }).toList();
      _allDuas.addAll((data['other'] as List).expand((category) {
        String categoryName = category['category'];
        return (category['duas'] as List)
            .map((dua) => Dua.fromJson(dua, categoryName))
            .toList();
      }).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Main'),
            Tab(text: 'Other'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _duas != null
                  ? _buildDuaGrid(_duas!['main'])
                  : const Center(child: CircularProgressIndicator()),
              _duas != null
                  ? _buildDuaGrid(_duas!['other'])
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDuaGrid(List<dynamic> duas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: duas.length,
        itemBuilder: (context, index) {
          final category =
              duas[index]['category'] ?? 'No Category'; // Handle null value
          final image = duas[index]['image'] ?? ''; // Handle null value
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DuaListScreen(
                    categoryTitle: category,
                    duas: (duas[index]['duas'] as List<dynamic>)
                        .map((e) => Dua.fromJson(e, category))
                        .toList(),
                  ),
                ),
              );
            },
            child: Card(
              child: image.isNotEmpty
                  ? Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Container(),
            ),
          );
        },
      ),
    );
  }

  List<Dua> get allDuas => _allDuas;
}
