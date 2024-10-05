import 'package:flutter/material.dart';
import 'surah_detail_screen.dart';
import 'search_results_screen.dart';
import 'juz_detail_screen.dart';
import '../data/surahs.dart';

class QuranSearchDelegate extends SearchDelegate {
  final List<Surah> surahs;

  QuranSearchDelegate(this.surahs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultsScreen(query: query, surahs: surahs);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = surahs.where((surah) {
      return surah.name.toLowerCase().contains(query.toLowerCase()) ||
          surah.arabicName.contains(query) ||
          surah.numberOfVerses.toString().contains(query) ||
          surah.verses.any((verse) =>
              verse.arabic.contains(query) ||
              verse.transliteration
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              verse.translation.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    final juzSuggestions = query.isNotEmpty &&
            (query.toLowerCase().startsWith('juz') ||
                query.toLowerCase().startsWith('para'))
        ? List.generate(30, (index) => 'Juz ${index + 1}')
            .where((juz) => juz.toLowerCase().contains(query.toLowerCase()))
            .toList()
        : [];

    return ListView(
      children: [
        const ListTile(
          title: Text('Search by surah name, number, verse or juz'),
        ),
        ...juzSuggestions.map((juz) {
          int juzNumber = int.parse(juz.split(' ')[1]);
          return ListTile(
            title: Text(juz),
            onTap: () {
              close(context, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JuzDetailScreen(juzIndex: juzNumber - 1, surahs: surahs),
                ),
              );
            },
          );
        }),
        ...suggestions.map((surah) {
          return ListTile(
            title: Text(surah.name),
            subtitle: Text(surah.arabicName),
            onTap: () {
              int surahIndex = surahs.indexOf(surah);
              query = surah.name;
              close(context, null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    audioFlag: 'verse',
                    surahIndex: surahIndex,
                    surahs: surahs,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
