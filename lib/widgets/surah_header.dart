// lib/widgets/surah_header.dart
import 'package:flutter/material.dart';

class SurahHeader extends StatelessWidget {
  final String name;
  final int number;
  final String type;
  final int verses;
  final VoidCallback onPlay;

  const SurahHeader({
    super.key,
    required this.name,
    required this.number,
    required this.type,
    required this.verses,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    // Define the colors
    const Color lightViolet = Color(0xFFE6E6FA);
    const Color darkViolet = Color(0xFF4B0082);

    return Container(
      color: lightViolet,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkViolet,
                    ),
                  ),
                  Text(
                    'Surah $number',
                    style: const TextStyle(
                      fontSize: 18,
                      color: darkViolet,
                    ),
                  ),
                  Text(
                    '$type - $verses Verses',
                    style: const TextStyle(
                      fontSize: 16,
                      color: darkViolet,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: darkViolet),
                onPressed: onPlay,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
