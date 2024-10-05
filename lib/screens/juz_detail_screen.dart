import 'package:flutter/material.dart';
import '../data/surahs.dart';
import 'surah_detail_screen.dart';

class JuzDetailScreen extends StatelessWidget {
  final int juzIndex;
  final List<Surah> surahs;

  const JuzDetailScreen(
      {super.key, required this.juzIndex, required this.surahs});

  @override
  Widget build(BuildContext context) {
    List<Verse> verses = [];
    for (var surah in surahs) {
      for (var verse in surah.verses) {
        if (verse.juz == juzIndex + 1) {
          verses.add(verse);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${juzIndex + 1}'),
      ),
      body: ListView.builder(
        itemCount: verses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(verses[index].arabic),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(verses[index].transliteration),
                  Text(verses[index].translation),
                ],
              ),
              onTap: () {
                Surah surah =
                    surahs.firstWhere((s) => s.verses.contains(verses[index]));
                int surahIndex = surahs.indexOf(surah);
                int verseIndex = surah.verses.indexOf(verses[index]);
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
            ),
          );
        },
      ),
    );
  }
}
