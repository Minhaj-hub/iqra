import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/surahs.dart';
import '../provider/general_provider.dart';
import 'surah_detail_screen.dart';
import '../widgets/audio_control_bar.dart';

class SurahListScreen extends StatefulWidget {
  final List<Surah> surahs;
  final String audioFlag;

  const SurahListScreen(
      {super.key, required this.surahs, required this.audioFlag});

  @override
  _SurahListScreenState createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  Set<int> _favoriteSurahs = {};
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  int _playingSurah = -1;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  String _currentSurahName = '';
  int _currentVerseNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadFavorites();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() => _duration = d);
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _position = p;
          _updateCurrentVerse();
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (!_isPlaying) {
            _isLoading = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _favoriteSurahs =
            prefs.getStringList('favoriteSurahs')?.map(int.parse).toSet() ?? {};
      });
    }
  }

  _toggleFavorite(int surahIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        if (_favoriteSurahs.contains(surahIndex + 1)) {
          _favoriteSurahs.remove(surahIndex + 1);
        } else {
          _favoriteSurahs.add(surahIndex + 1);
        }
      });
      prefs.setStringList(
          'favoriteSurahs', _favoriteSurahs.map((e) => e.toString()).toList());
    }
  }

  Future<String> _getAudioUrl(int surahIndex) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = 'surah_${surahIndex + 1}.mp3';
    try {
      String url = await storage.ref('audio/$fileName').getDownloadURL();
      print('Fetched URL: $url'); // Debug print
      return url;
    } catch (e) {
      print('Error getting audio URL: $e');
      return '';
    }
  }

  _playAudio(int surahIndex) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    String url = await _getAudioUrl(surahIndex);
    if (url.isNotEmpty) {
      if (_isPlaying && _playingSurah == surahIndex) {
        await _audioPlayer.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingSurah = -1;
            _isLoading = false;
          });
        }
      } else {
        await _audioPlayer.play(UrlSource(url));
        if (mounted) {
          setState(() {
            _isPlaying = true;
            _playingSurah = surahIndex;
            _currentSurahName = widget.surahs[surahIndex].name;
            _currentVerseNumber = 1;
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _updateCurrentVerse() {
    if (_playingSurah != -1) {
      final surah = widget.surahs[_playingSurah];
      for (int i = 0; i < surah.verses.length; i++) {
        if (i < surah.verses.length - 1) {
          if (_position.inSeconds >= surah.verses[i].audioTimestamp! &&
              _position.inSeconds < surah.verses[i + 1].audioTimestamp!) {
            if (mounted) {
              setState(() {
                _currentVerseNumber = i + 1;
              });
            }
            break;
          }
        } else {
          if (_position.inSeconds >= surah.verses[i].audioTimestamp!) {
            if (mounted) {
              setState(() {
                _currentVerseNumber = i + 1;
              });
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GeneralProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: widget.surahs.length,
        itemBuilder: (context, index) {
          bool isFavorite = _favoriteSurahs.contains(index + 1);
          Surah surah = widget.surahs[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: IconButton(
                icon: Icon(_isPlaying && _playingSurah == index
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  provider.manageSurahPlayer(true);
                  _playAudio(index);
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ${surah.name}'),
                  Text('${surah.numberOfVerses} verses',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    surah.arabicName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IndoPak'),
                    textDirection: TextDirection.rtl,
                  ),
                  IconButton(
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      _toggleFavorite(index);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahDetailScreen(
                      surahIndex: index,
                      surahs: widget.surahs,
                      flag: 'start',
                      audioFlag: 'verse',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: provider.openSurahPlayer
          ? AudioControlBar(
              flag: widget.audioFlag,
              audioPlayer: _audioPlayer,
              duration: _duration,
              position: _position,
              onPause: () {
                _audioPlayer.pause();
                setState(() {
                  _isPlaying = false;
                });
              },
              onResume: () {
                _audioPlayer.resume();
                setState(() {
                  _isPlaying = true;
                });
              },
              onSeekBackward: () {
                _audioPlayer.seek(Duration(seconds: _position.inSeconds - 10));
              },
              onSeekForward: () {
                _audioPlayer.seek(Duration(seconds: _position.inSeconds + 10));
              },
              surahName: _currentSurahName,
              verseNumber: _currentVerseNumber,
              isLoading: _isLoading,
            )
          : const SizedBox.shrink(),
    );
  }
}
