import 'package:flutter/material.dart';
import '../data/surahs.dart';
import 'surah_detail_screen.dart';

class JuzListScreen extends StatelessWidget {
  final List<Surah> surahs;

  JuzListScreen({super.key, required this.surahs});

  final List<Map<String, dynamic>> juzData = [
    {
      'juz': 1,
      'surahs': [
        {'name': 'Al-Fatiha', 'surahIndex': 0, 'startVerse': 1, 'endVerse': 7},
        {
          'name': 'Al-Baqarah',
          'surahIndex': 1,
          'startVerse': 1,
          'endVerse': 141
        },
      ],
    },
    {
      'juz': 2,
      'surahs': [
        {
          'name': 'Al-Baqarah',
          'surahIndex': 1,
          'startVerse': 142,
          'endVerse': 252
        },
      ],
    },
    {
      'juz': 3,
      'surahs': [
        {
          'name': 'Al-Baqarah',
          'surahIndex': 1,
          'startVerse': 253,
          'endVerse': 286
        },
        {
          'name': 'Aal-E-Imran',
          'surahIndex': 2,
          'startVerse': 1,
          'endVerse': 92
        },
      ],
    },
    {
      'juz': 4,
      'surahs': [
        {
          'name': 'Aal-E-Imran',
          'surahIndex': 2,
          'startVerse': 93,
          'endVerse': 200
        },
        {'name': 'An-Nisa', 'surahIndex': 3, 'startVerse': 1, 'endVerse': 23},
      ],
    },
    {
      'juz': 5,
      'surahs': [
        {'name': 'An-Nisa', 'surahIndex': 3, 'startVerse': 24, 'endVerse': 147},
      ],
    },
    {
      'juz': 6,
      'surahs': [
        {
          'name': 'An-Nisa',
          'surahIndex': 3,
          'startVerse': 148,
          'endVerse': 176
        },
        {
          'name': 'Al-Ma\'idah',
          'surahIndex': 4,
          'startVerse': 1,
          'endVerse': 81
        },
      ],
    },
    {
      'juz': 7,
      'surahs': [
        {
          'name': 'Al-Ma\'idah',
          'surahIndex': 4,
          'startVerse': 82,
          'endVerse': 120
        },
        {
          'name': 'Al-An\'am',
          'surahIndex': 5,
          'startVerse': 1,
          'endVerse': 110
        },
      ],
    },
    {
      'juz': 8,
      'surahs': [
        {
          'name': 'Al-An\'am',
          'surahIndex': 5,
          'startVerse': 111,
          'endVerse': 165
        },
        {'name': 'Al-A\'raf', 'surahIndex': 6, 'startVerse': 1, 'endVerse': 87},
      ],
    },
    {
      'juz': 9,
      'surahs': [
        {
          'name': 'Al-A\'raf',
          'surahIndex': 6,
          'startVerse': 88,
          'endVerse': 206
        },
        {'name': 'Al-Anfal', 'surahIndex': 7, 'startVerse': 1, 'endVerse': 40},
      ],
    },
    {
      'juz': 10,
      'surahs': [
        {'name': 'Al-Anfal', 'surahIndex': 7, 'startVerse': 41, 'endVerse': 75},
        {'name': 'At-Tawbah', 'surahIndex': 8, 'startVerse': 1, 'endVerse': 92},
      ],
    },
    {
      'juz': 11,
      'surahs': [
        {
          'name': 'At-Tawbah',
          'surahIndex': 8,
          'startVerse': 93,
          'endVerse': 129
        },
        {'name': 'Yunus', 'surahIndex': 9, 'startVerse': 1, 'endVerse': 109},
      ],
    },
    {
      'juz': 12,
      'surahs': [
        {'name': 'Hud', 'surahIndex': 10, 'startVerse': 1, 'endVerse': 123},
        {'name': 'Yusuf', 'surahIndex': 11, 'startVerse': 1, 'endVerse': 52},
      ],
    },
    {
      'juz': 13,
      'surahs': [
        {'name': 'Yusuf', 'surahIndex': 11, 'startVerse': 53, 'endVerse': 111},
        {'name': 'Ar-Ra\'d', 'surahIndex': 12, 'startVerse': 1, 'endVerse': 43},
        {'name': 'Ibrahim', 'surahIndex': 13, 'startVerse': 1, 'endVerse': 52},
      ],
    },
    {
      'juz': 14,
      'surahs': [
        {'name': 'Al-Hijr', 'surahIndex': 14, 'startVerse': 1, 'endVerse': 99},
        {'name': 'An-Nahl', 'surahIndex': 15, 'startVerse': 1, 'endVerse': 128},
      ],
    },
    {
      'juz': 15,
      'surahs': [
        {'name': 'Al-Isra', 'surahIndex': 16, 'startVerse': 1, 'endVerse': 111},
        {'name': 'Al-Kahf', 'surahIndex': 17, 'startVerse': 1, 'endVerse': 74},
      ],
    },
    {
      'juz': 16,
      'surahs': [
        {
          'name': 'Al-Kahf',
          'surahIndex': 17,
          'startVerse': 75,
          'endVerse': 110
        },
        {'name': 'Maryam', 'surahIndex': 18, 'startVerse': 1, 'endVerse': 98},
        {'name': 'Ta-Ha', 'surahIndex': 19, 'startVerse': 1, 'endVerse': 135},
      ],
    },
    {
      'juz': 17,
      'surahs': [
        {
          'name': 'Al-Anbiya',
          'surahIndex': 20,
          'startVerse': 1,
          'endVerse': 112
        },
        {'name': 'Al-Hajj', 'surahIndex': 21, 'startVerse': 1, 'endVerse': 78},
      ],
    },
    {
      'juz': 18,
      'surahs': [
        {
          'name': 'Al-Mu\'minun',
          'surahIndex': 22,
          'startVerse': 1,
          'endVerse': 118
        },
        {'name': 'An-Nur', 'surahIndex': 23, 'startVerse': 1, 'endVerse': 64},
      ],
    },
    {
      'juz': 19,
      'surahs': [
        {
          'name': 'Al-Furqan',
          'surahIndex': 24,
          'startVerse': 1,
          'endVerse': 77
        },
        {
          'name': 'Ash-Shu\'ara',
          'surahIndex': 25,
          'startVerse': 1,
          'endVerse': 227
        },
      ],
    },
    {
      'juz': 20,
      'surahs': [
        {'name': 'An-Naml', 'surahIndex': 26, 'startVerse': 1, 'endVerse': 93},
        {'name': 'Al-Qasas', 'surahIndex': 27, 'startVerse': 1, 'endVerse': 88},
      ],
    },
    {
      'juz': 21,
      'surahs': [
        {
          'name': 'Al-Ankabut',
          'surahIndex': 28,
          'startVerse': 1,
          'endVerse': 69
        },
        {'name': 'Ar-Rum', 'surahIndex': 29, 'startVerse': 1, 'endVerse': 60},
        {'name': 'Luqman', 'surahIndex': 30, 'startVerse': 1, 'endVerse': 34},
        {'name': 'As-Sajda', 'surahIndex': 31, 'startVerse': 1, 'endVerse': 30},
      ],
    },
    {
      'juz': 22,
      'surahs': [
        {'name': 'Al-Ahzab', 'surahIndex': 32, 'startVerse': 1, 'endVerse': 73},
        {'name': 'Saba', 'surahIndex': 33, 'startVerse': 1, 'endVerse': 54},
        {'name': 'Fatir', 'surahIndex': 34, 'startVerse': 1, 'endVerse': 45},
        {'name': 'Ya-Sin', 'surahIndex': 35, 'startVerse': 1, 'endVerse': 83},
      ],
    },
    {
      'juz': 23,
      'surahs': [
        {
          'name': 'As-Saffat',
          'surahIndex': 36,
          'startVerse': 1,
          'endVerse': 182
        },
        {'name': 'Sad', 'surahIndex': 37, 'startVerse': 1, 'endVerse': 88},
        {'name': 'Az-Zumar', 'surahIndex': 38, 'startVerse': 1, 'endVerse': 31},
      ],
    },
    {
      'juz': 24,
      'surahs': [
        {
          'name': 'Az-Zumar',
          'surahIndex': 38,
          'startVerse': 32,
          'endVerse': 75
        },
        {'name': 'Ghafir', 'surahIndex': 39, 'startVerse': 1, 'endVerse': 85},
        {'name': 'Fussilat', 'surahIndex': 40, 'startVerse': 1, 'endVerse': 46},
      ],
    },
    {
      'juz': 25,
      'surahs': [
        {
          'name': 'Fussilat',
          'surahIndex': 40,
          'startVerse': 47,
          'endVerse': 54
        },
        {
          'name': 'Ash-Shura',
          'surahIndex': 41,
          'startVerse': 1,
          'endVerse': 53
        },
        {
          'name': 'Az-Zukhruf',
          'surahIndex': 42,
          'startVerse': 1,
          'endVerse': 89
        },
        {
          'name': 'Ad-Dukhan',
          'surahIndex': 43,
          'startVerse': 1,
          'endVerse': 59
        },
        {
          'name': 'Al-Jathiya',
          'surahIndex': 44,
          'startVerse': 1,
          'endVerse': 37
        },
      ],
    },
    {
      'juz': 26,
      'surahs': [
        {'name': 'Al-Ahqaf', 'surahIndex': 45, 'startVerse': 1, 'endVerse': 35},
        {'name': 'Muhammad', 'surahIndex': 46, 'startVerse': 1, 'endVerse': 38},
        {'name': 'Al-Fath', 'surahIndex': 47, 'startVerse': 1, 'endVerse': 29},
        {
          'name': 'Al-Hujurat',
          'surahIndex': 48,
          'startVerse': 1,
          'endVerse': 18
        },
        {'name': 'Qaf', 'surahIndex': 49, 'startVerse': 1, 'endVerse': 45},
      ],
    },
    {
      'juz': 27,
      'surahs': [
        {
          'name': 'Adh-Dhariyat',
          'surahIndex': 50,
          'startVerse': 1,
          'endVerse': 60
        },
        {'name': 'At-Tur', 'surahIndex': 51, 'startVerse': 1, 'endVerse': 49},
        {'name': 'An-Najm', 'surahIndex': 52, 'startVerse': 1, 'endVerse': 62},
        {'name': 'Al-Qamar', 'surahIndex': 53, 'startVerse': 1, 'endVerse': 55},
        {
          'name': 'Ar-Rahman',
          'surahIndex': 54,
          'startVerse': 1,
          'endVerse': 78
        },
        {'name': 'Al-Waqia', 'surahIndex': 55, 'startVerse': 1, 'endVerse': 96},
        {'name': 'Al-Hadid', 'surahIndex': 56, 'startVerse': 1, 'endVerse': 29},
      ],
    },
    {
      'juz': 28,
      'surahs': [
        {
          'name': 'Al-Mujadila',
          'surahIndex': 57,
          'startVerse': 1,
          'endVerse': 22
        },
        {'name': 'Al-Hashr', 'surahIndex': 58, 'startVerse': 1, 'endVerse': 24},
        {
          'name': 'Al-Mumtahina',
          'surahIndex': 59,
          'startVerse': 1,
          'endVerse': 13
        },
        {'name': 'As-Saff', 'surahIndex': 60, 'startVerse': 1, 'endVerse': 14},
        {'name': 'Al-Jumua', 'surahIndex': 61, 'startVerse': 1, 'endVerse': 11},
        {
          'name': 'Al-Munafiqun',
          'surahIndex': 62,
          'startVerse': 1,
          'endVerse': 11
        },
        {
          'name': 'At-Taghabun',
          'surahIndex': 63,
          'startVerse': 1,
          'endVerse': 18
        },
        {'name': 'At-Talaq', 'surahIndex': 64, 'startVerse': 1, 'endVerse': 12},
        {
          'name': 'At-Tahrim',
          'surahIndex': 65,
          'startVerse': 1,
          'endVerse': 12
        },
      ],
    },
    {
      'juz': 29,
      'surahs': [
        {'name': 'Al-Mulk', 'surahIndex': 66, 'startVerse': 1, 'endVerse': 30},
        {'name': 'Al-Qalam', 'surahIndex': 67, 'startVerse': 1, 'endVerse': 52},
        {
          'name': 'Al-Haqqah',
          'surahIndex': 68,
          'startVerse': 1,
          'endVerse': 52
        },
        {
          'name': 'Al-Maarij',
          'surahIndex': 69,
          'startVerse': 1,
          'endVerse': 44
        },
        {'name': 'Nuh', 'surahIndex': 70, 'startVerse': 1, 'endVerse': 28},
        {'name': 'Al-Jinn', 'surahIndex': 71, 'startVerse': 1, 'endVerse': 28},
        {
          'name': 'Al-Muzzammil',
          'surahIndex': 72,
          'startVerse': 1,
          'endVerse': 20
        },
        {
          'name': 'Al-Muddaththir',
          'surahIndex': 73,
          'startVerse': 1,
          'endVerse': 56
        },
        {
          'name': 'Al-Qiyama',
          'surahIndex': 74,
          'startVerse': 1,
          'endVerse': 40
        },
        {'name': 'Al-Insan', 'surahIndex': 75, 'startVerse': 1, 'endVerse': 31},
        {
          'name': 'Al-Mursalat',
          'surahIndex': 76,
          'startVerse': 1,
          'endVerse': 50
        },
      ],
    },
    {
      'juz': 30,
      'surahs': [
        {'name': 'An-Naba', 'surahIndex': 77, 'startVerse': 1, 'endVerse': 40},
        {
          'name': 'An-Naziat',
          'surahIndex': 78,
          'startVerse': 1,
          'endVerse': 46
        },
        {'name': 'Abasa', 'surahIndex': 79, 'startVerse': 1, 'endVerse': 42},
        {
          'name': 'At-Takwir',
          'surahIndex': 80,
          'startVerse': 1,
          'endVerse': 29
        },
        {
          'name': 'Al-Infitar',
          'surahIndex': 81,
          'startVerse': 1,
          'endVerse': 19
        },
        {
          'name': 'Al-Mutaffifin',
          'surahIndex': 82,
          'startVerse': 1,
          'endVerse': 36
        },
        {
          'name': 'Al-Inshiqaq',
          'surahIndex': 83,
          'startVerse': 1,
          'endVerse': 25
        },
        {'name': 'Al-Buruj', 'surahIndex': 84, 'startVerse': 1, 'endVerse': 22},
        {'name': 'At-Tariq', 'surahIndex': 85, 'startVerse': 1, 'endVerse': 17},
        {'name': 'Al-Ala', 'surahIndex': 86, 'startVerse': 1, 'endVerse': 19},
        {
          'name': 'Al-Ghashiya',
          'surahIndex': 87,
          'startVerse': 1,
          'endVerse': 26
        },
        {'name': 'Al-Fajr', 'surahIndex': 88, 'startVerse': 1, 'endVerse': 30},
        {'name': 'Al-Balad', 'surahIndex': 89, 'startVerse': 1, 'endVerse': 20},
        {
          'name': 'Ash-Shams',
          'surahIndex': 90,
          'startVerse': 1,
          'endVerse': 15
        },
        {'name': 'Al-Lail', 'surahIndex': 91, 'startVerse': 1, 'endVerse': 21},
        {'name': 'Ad-Duha', 'surahIndex': 92, 'startVerse': 1, 'endVerse': 11},
        {'name': 'Ash-Sharh', 'surahIndex': 93, 'startVerse': 1, 'endVerse': 8},
        {'name': 'At-Tin', 'surahIndex': 94, 'startVerse': 1, 'endVerse': 8},
        {'name': 'Al-Alaq', 'surahIndex': 95, 'startVerse': 1, 'endVerse': 19},
        {'name': 'Al-Qadr', 'surahIndex': 96, 'startVerse': 1, 'endVerse': 5},
        {
          'name': 'Al-Bayyina',
          'surahIndex': 97,
          'startVerse': 1,
          'endVerse': 8
        },
        {
          'name': 'Az-Zalzalah',
          'surahIndex': 98,
          'startVerse': 1,
          'endVerse': 8
        },
        {
          'name': 'Al-Adiyat',
          'surahIndex': 99,
          'startVerse': 1,
          'endVerse': 11
        },
        {
          'name': 'Al-Qariah',
          'surahIndex': 100,
          'startVerse': 1,
          'endVerse': 11
        },
        {
          'name': 'At-Takathur',
          'surahIndex': 101,
          'startVerse': 1,
          'endVerse': 8
        },
        {'name': 'Al-Asr', 'surahIndex': 102, 'startVerse': 1, 'endVerse': 3},
        {
          'name': 'Al-Humaza',
          'surahIndex': 103,
          'startVerse': 1,
          'endVerse': 9
        },
        {'name': 'Al-Fil', 'surahIndex': 104, 'startVerse': 1, 'endVerse': 5},
        {'name': 'Quraish', 'surahIndex': 105, 'startVerse': 1, 'endVerse': 4},
        {'name': 'Al-Maun', 'surahIndex': 106, 'startVerse': 1, 'endVerse': 7},
        {
          'name': 'Al-Kawthar',
          'surahIndex': 107,
          'startVerse': 1,
          'endVerse': 3
        },
        {
          'name': 'Al-Kafirun',
          'surahIndex': 108,
          'startVerse': 1,
          'endVerse': 6
        },
        {'name': 'An-Nasr', 'surahIndex': 109, 'startVerse': 1, 'endVerse': 3},
        {'name': 'Al-Masad', 'surahIndex': 110, 'startVerse': 1, 'endVerse': 5},
        {
          'name': 'Al-Ikhlas',
          'surahIndex': 111,
          'startVerse': 1,
          'endVerse': 4
        },
        {'name': 'Al-Falaq', 'surahIndex': 112, 'startVerse': 1, 'endVerse': 5},
        {'name': 'An-Nas', 'surahIndex': 113, 'startVerse': 1, 'endVerse': 6},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: juzData.length,
      itemBuilder: (context, index) {
        final juz = juzData[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Juz ${juz['juz']}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...juz['surahs'].map<Widget>((surahData) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailScreen(
                        audioFlag: 'verse',
                        surahIndex: surahData['surahIndex'],
                        surahs: surahs,
                        initialAyat: surahData['startVerse'],
                        flag: 'start',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${surahData['name']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Verse ${surahData['startVerse']} - ${surahData['endVerse']}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const Divider(height: 20, color: Colors.grey),
          ],
        );
      },
    );
  }
}
