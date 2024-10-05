import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'surah_detail_screen.dart';
import 'dua_detail_screen.dart';
import '../data/dua.dart';
import '../data/surahs.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Set<String> _favoriteVerses = {};
  Set<int> _favoriteSurahs = {};
  Set<String> _favoriteDuas = {};
  List<Dua> allDuas = [];
  List<Surah> allSurahs = [];

  bool _showFavoriteSurahs = false;
  bool _showFavoriteVerses = false;
  bool _showFavoriteDuas = true; // Show Duas by default

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadDuas();
    _loadSurahs();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteVerses = prefs.getStringList('favoriteVerses')?.toSet() ?? {};
      _favoriteSurahs =
          prefs.getStringList('favoriteSurahs')?.map(int.parse).toSet() ?? {};
      _favoriteDuas = prefs.getStringList('favoriteDuas')?.toSet() ?? {};
    });
  }

  Future<void> _loadDuas() async {
    try {
      final String response = await rootBundle.loadString('assets/duas.json');
      final data = json.decode(response) as Map<String, dynamic>;
      setState(() {
        allDuas = (data['main'] as List).expand((category) {
          String categoryName = category['category'];
          return (category['duas'] as List)
              .map((dua) => Dua.fromJson(dua, categoryName));
        }).toList();
        allDuas.addAll((data['other'] as List).expand((category) {
          String categoryName = category['category'];
          return (category['duas'] as List)
              .map((dua) => Dua.fromJson(dua, categoryName));
        }).toList());
      });
    } catch (e) {
      print("Error loading Duas: $e");
    }
  }

  Future<void> _loadSurahs() async {
    try {
      final String response =
          await rootBundle.loadString('assets/quran_data.json');
      setState(() {
        allSurahs = parseSurahs(response);
      });
    } catch (e) {
      print("Error loading Surahs: $e");
    }
  }

  Dua? _findDuaByTitle(String title) {
    try {
      return allDuas.firstWhere((dua) => dua.title == title);
    } catch (e) {
      print("Dua with title $title not found.");
      return null;
    }
  }

  Surah? _findSurahByIndex(int index) {
    if (index >= 0 && index < allSurahs.length) {
      return allSurahs[index];
    }
    return null;
  }

  Surah? _findSurahByName(String surahName) {
    try {
      return allSurahs.firstWhere((s) => s.name == surahName);
    } catch (e) {
      return null;
    }
  }

  void _showSurahs() {
    setState(() {
      _showFavoriteSurahs = true;
      _showFavoriteVerses = false;
      _showFavoriteDuas = false;
    });
  }

  void _showVerses() {
    setState(() {
      _showFavoriteSurahs = false;
      _showFavoriteVerses = true;
      _showFavoriteDuas = false;
    });
  }

  void _showDuas() {
    setState(() {
      _showFavoriteSurahs = false;
      _showFavoriteVerses = false;
      _showFavoriteDuas = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20), // Add space between AppBar and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDuas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showFavoriteDuas ? Colors.purple : Colors.grey[300],
                    foregroundColor:
                        _showFavoriteDuas ? Colors.white : Colors.black,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child:
                      const Text('Favourite Duas', textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showVerses,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showFavoriteVerses ? Colors.purple : Colors.grey[300],
                    foregroundColor:
                        _showFavoriteVerses ? Colors.white : Colors.black,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Favourite Verses',
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showSurahs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showFavoriteSurahs ? Colors.purple : Colors.grey[300],
                    foregroundColor:
                        _showFavoriteSurahs ? Colors.white : Colors.black,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Favourite Surahs',
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _showFavoriteSurahs
                  ? _favoriteSurahs.length
                  : _showFavoriteVerses
                      ? _favoriteVerses.length
                      : _favoriteDuas.length,
              itemBuilder: (context, index) {
                if (_showFavoriteSurahs) {
                  int favoriteSurah = _favoriteSurahs.elementAt(index);
                  Surah? surah = _findSurahByIndex(favoriteSurah - 1);
                  return _buildFavoriteItem(
                    context,
                    surah != null ? surah.name : 'Unknown Surah $favoriteSurah',
                    Icons.delete,
                    () {
                      setState(() {
                        _favoriteSurahs.remove(favoriteSurah);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setStringList(
                              'favoriteSurahs',
                              _favoriteSurahs
                                  .map((e) => e.toString())
                                  .toList());
                        });
                      });
                    },
                    onTap: surah != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurahDetailScreen(
                                  audioFlag: 'verse',
                                  surahIndex: favoriteSurah - 1,
                                  initialAyat: 1,
                                  surahs: allSurahs,
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                } else if (_showFavoriteVerses) {
                  String favoriteVerse = _favoriteVerses.elementAt(index);
                  return _buildFavoriteItem(
                    context,
                    favoriteVerse,
                    Icons.delete,
                    () {
                      setState(() {
                        _favoriteVerses.remove(favoriteVerse);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setStringList(
                              'favoriteVerses', _favoriteVerses.toList());
                        });
                      });
                    },
                    onTap: () {
                      final surahName = favoriteVerse.split(" Verse ")[0];
                      final verseNumber =
                          int.parse(favoriteVerse.split(" Verse ")[1]);
                      Surah? surah = _findSurahByName(surahName);
                      if (surah != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailScreen(
                              audioFlag: 'verse',
                              surahIndex: allSurahs.indexOf(surah),
                              initialAyat: verseNumber,
                              surahs: allSurahs,
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  String favoriteDua = _favoriteDuas.elementAt(index);
                  Dua? dua = _findDuaByTitle(favoriteDua);
                  if (dua == null) {
                    return ListTile(
                      title: Text(favoriteDua),
                      subtitle: const Text("Dua not found."),
                    );
                  }
                  return _buildFavoriteItem(
                    context,
                    favoriteDua,
                    Icons.delete,
                    () {
                      setState(() {
                        _favoriteDuas.remove(favoriteDua);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setStringList(
                              'favoriteDuas', _favoriteDuas.toList());
                        });
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DuaDetailScreen(
                            duas: [dua], // Pass the favorite dua in a list
                            index: 0, // Since it's a single dua, the index is 0
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(
      BuildContext context, String title, IconData icon, VoidCallback onDelete,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        trailing: IconButton(
          icon: Icon(icon),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }

  List<Surah> parseSurahs(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Surah>((json) {
      try {
        return Surah.fromJson(json);
      } catch (e) {
        print('Error parsing surah: $e');
        return Surah(
          name: 'Error',
          numberOfVerses: 0,
          arabicName: 'Error',
          verses: [],
          isMeccan: false,
        );
      }
    }).toList();
  }
}
