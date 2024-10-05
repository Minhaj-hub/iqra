// lib/data/surahs.dart
import 'dart:convert';


class Surah {
  final String name;
  final int numberOfVerses;
  final String arabicName;
  final List<Verse> verses;
  final bool isMeccan; // Add this field to your Surah class

  Surah({
    required this.name,
    required this.numberOfVerses,
    required this.arabicName,
    required this.verses,
    required this.isMeccan, // Initialize this field
    
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var list = json['verses'] as List;
    List<Verse> verseList = list.map((i) => Verse.fromJson(i)).toList();

    return Surah(
      name: json['name'] as String,
      numberOfVerses: json['numberOfVerses'] as int,
      arabicName: json['arabicName'] as String,
      verses: verseList,
      isMeccan: json['isMeccan'] as bool, // Parse this field from JSON
    );
  }
}

class Verse {
  final String arabic;
  final String transliteration;
  final String translation;
  final int juz;
  bool deepMeaningExpanded; // Add this field to your Verse class
  final int? audioTimestamp;  // Make this nullable if the field might be missing
  final String? deepMeaning; // Make this nullable if the field might be missing

  Verse({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.juz,
    this.deepMeaning = '', // Initialize this field with an empty string
    this.deepMeaningExpanded = false, // Initialize this field with false
    required this.audioTimestamp, // Initialize this field
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      juz: json['juz'] as int,
      deepMeaning: json['deepMeaning'] as String? ?? '', // Parse this field from JSON
      deepMeaningExpanded: false, // Initialize this field with false
      audioTimestamp: json['audioTimestamp']?.toInt(),  // Cast to int, can be null
    );
  }
}
// Example JSON parsing function
void loadSurahs(String jsonString) {
  final Map<String, dynamic> data = jsonDecode(jsonString);
  
  final List<dynamic> versesJson = data['verses'] ?? [];
  final List<Verse> verses = versesJson.map((json) => Verse.fromJson(json)).toList();
  
  // Your further processing
}
