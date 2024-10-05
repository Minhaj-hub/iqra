import 'package:flutter/material.dart';
import '../data/surahs.dart';
import 'surah_detail_screen.dart';
import 'juz_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final List<Surah> surahs;

  const SearchResultsScreen(
      {super.key, required this.query, required this.surahs});

  @override
  Widget build(BuildContext context) {
    List<Surah> surahResults = surahs.where((surah) {
      return surah.name.toLowerCase().contains(query.toLowerCase()) ||
          surah.arabicName.contains(query) ||
          surah.numberOfVerses.toString().contains(query);
    }).toList();

    List<Verse> verseResults = [];
    for (var surah in surahs) {
      for (var verse in surah.verses) {
        if (verse.arabic.contains(query) ||
            verse.transliteration.toLowerCase().contains(query.toLowerCase()) ||
            verse.translation.toLowerCase().contains(query.toLowerCase())) {
          verseResults.add(verse);
        }
      }
    }

    List<String> juzResults = [];
    if (query.toLowerCase().startsWith('juz') ||
        query.toLowerCase().startsWith('para')) {
      int juzNumber = int.tryParse(query.split(' ')[1]) ?? -1;
      if (juzNumber > 0 && juzNumber <= 30) {
        juzResults.add('Juz $juzNumber');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView(
        children: [
          if (surahResults.isNotEmpty) ...[
            const ListTile(
              title: Text('Surah Results'),
            ),
            ...surahResults.map((surah) {
              return ListTile(
                title: Text(surah.name),
                subtitle: Text(surah.arabicName),
                onTap: () {
                  int surahIndex = surahs.indexOf(surah);
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
          if (verseResults.isNotEmpty) ...[
            const ListTile(
              title: Text('Verse Results'),
            ),
            ...verseResults.map((verse) {
              Surah surah = surahs.firstWhere((s) => s.verses.contains(verse));
              int surahIndex = surahs.indexOf(surah);
              int verseIndex = surah.verses.indexOf(verse);
              return ListTile(
                title: Text(verse.arabic),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(verse.transliteration),
                    Text(verse.translation),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailScreen(
                        audioFlag: 'verse',
                        surahIndex: surahIndex,
                        initialAyat: verseIndex + 1,
                        surahs: surahs,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
          if (juzResults.isNotEmpty) ...[
            const ListTile(
              title: Text('Juz Results'),
            ),
            ...juzResults.map((juz) {
              int juzNumber = int.parse(juz.split(' ')[1]);
              return ListTile(
                title: Text(juz),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JuzDetailScreen(
                        juzIndex: juzNumber - 1,
                        surahs: surahs,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ],
      ),
    );
  }
}
