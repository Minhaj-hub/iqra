class Dua {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String hadith;
  final String category;

  Dua({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.hadith,
    required this.category,
  });

  factory Dua.fromJson(Map<String, dynamic> json, String category) {
    return Dua(
      title: json['title'] ?? '',
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      hadith: json['hadith'] ?? '',
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'hadith': hadith,
      'category': category,
    };
  }
}
