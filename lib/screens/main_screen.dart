import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'surah_list_screen.dart';
import 'juz_list_screen.dart';
import 'package:flutter/services.dart';
import 'favourites_page.dart';
import 'surah_detail_screen.dart';
import 'dhikr_dua_screen.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'quran_search_delegate.dart';
import 'dhikr_dua_search_delegate.dart';
import '../main.dart';
import '../data/surahs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'about_us_screen.dart';

class MainScreen extends StatefulWidget {
  final List<Surah> surahs;

  const MainScreen({super.key, required this.surahs});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with RouteAware {
  int _selectedIndex = 0;
  String? lastReadSurah;
  int? lastReadAyat;
  String? randomQuote;
  String? quoteSource;
  final GlobalKey<DhikrDuaScreenState> _dhikrDuaKey =
      GlobalKey<DhikrDuaScreenState>();

  @override
  void initState() {
    super.initState();
    _loadLastRead();
    _loadRandomQuote();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadLastRead();
  }

  Future<void> _loadRandomQuote() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    final List<String> quotes = List<String>.from(json.decode(response));
    final Random random = Random();
    setState(() {
      final selectedQuote = quotes[random.nextInt(quotes.length)];
      final splitQuote = selectedQuote.split('(');
      randomQuote = splitQuote[0].trim();
      quoteSource = '(${splitQuote[1]}'.trim();
    });
  }

  Future<void> _loadLastRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastReadSurah = prefs.getString('lastReadSurah') ?? 'Al-Fatiha';
      lastReadAyat = prefs.getInt('lastReadAyat') ?? 1;
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _continueReading() {
    if (lastReadSurah != null && lastReadAyat != null) {
      int surahIndex =
          widget.surahs.indexWhere((surah) => surah.name == lastReadSurah);
      if (surahIndex != -1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailScreen(
              audioFlag: 'verse',
              surahIndex: surahIndex,
              initialAyat: lastReadAyat!,
              surahs: widget.surahs,
            ),
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showToast('Could not launch $url');
      }
    } catch (e) {
      _showToast('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildQuranScreen(context),
      DhikrDuaScreen(key: _dhikrDuaKey),
      const PrayerTimesScreen(),
      const FavouritesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('📖 Quran')
            : _selectedIndex == 1
                ? const Text('📿 Dhikr & Dua')
                : _selectedIndex == 2
                    ? const Text('🕋 Prayer Times')
                    : const Text('⭐ Favourites'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: _selectedIndex == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.explore),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QiblaScreen()),
                    );
                  },
                ),
              ]
            : _selectedIndex == 0 || _selectedIndex == 1
                ? [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_selectedIndex == 0) {
                          showSearch(
                            context: context,
                            delegate: QuranSearchDelegate(widget.surahs),
                          );
                        } else if (_selectedIndex == 1) {
                          final state = _dhikrDuaKey.currentState;
                          if (state != null) {
                            showSearch(
                              context: context,
                              delegate: DhikrDuaSearchDelegate(state.allDuas),
                            );
                          }
                        }
                      },
                    ),
                  ]
                : [],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple[600],
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Iqra - Quran App',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Our App'),
              onTap: () {
                final box = context.findRenderObject() as RenderBox?;
                Share.share(
                  '''
📱✨ *Iqra App ke saath Qur'an ka Behtareen Tajurba!* ✨📱

Assalamu Alaikum! 🌙 *Iqra* app ke zariye Qur'an ki duniya mein ghus jayiye - yeh app aapko qirā'at, tarjuma, aur rozana yaad-dihaniyon ka behtareen tajurba faraham karti hai.

🚀 *Features jo aapko pasand aayenge*:
🕌 Sahih Namaz ke Auqat
📿 Dhikr aur Duas ka Majmua
🔍 Qur'an ki Asaan Talaash
⭐ Apne Pasandeeda Hifz Karein
🕋 Qibla ka Rukh aur bohot kuch!

Aaj hi download karein aur humare saath apni roohani safar ka aghaz karein! 🌟

🔗 *Download karein yahan se*: https://play.google.com/store/apps/details?id=com.quran.iqra


Aayiye, Qur'an ki roshni ko mil kar phailate hain!
      ''',
                  subject: 'Quran App',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate Us'),
              onTap: () {
                _launchUrl(
                    'https://play.google.com/store/apps/details?id=com.quran.iqra');
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.whatsapp),
              title: const Text('Join Whatsapp'),
              subtitle: const Text(
                'For daily Hadith/reminders',
                style: TextStyle(fontSize: 10),
              ),
              onTap: () {
                _launchUrl(
                    'https://whatsapp.com/channel/0029Vak4FIf6hENwiYUdmq1I');
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.instagram),
                    onPressed: () {
                      _launchUrl('https://instagram.com/itsamanmaqsood');
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.xTwitter),
                    onPressed: () {
                      _launchUrl('https://x.com/amanmaqsood');
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.telegramPlane),
                    onPressed: () {
                      _launchUrl('https://t.me/iqraJourney');
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp),
                    onPressed: () {
                      _launchUrl(
                          'https://whatsapp.com/channel/0029Vak4FIf6hENwiYUdmq1I');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0 &&
              randomQuote != null) // Only show on Quran page
            _buildQuoteContainer(randomQuote!, quoteSource!),
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Quran',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Dhikr & Dua',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Prayer Times',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.purple[600],
            unselectedItemColor: Colors.purple[100],
            backgroundColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteContainer(String quote, String source) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[300]!, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              source,
              style: TextStyle(
                fontSize: 12,
                color: Colors.purple[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranScreen(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last Read: $lastReadSurah, Ayat $lastReadAyat'),
              Row(
                children: [
                  TextButton(
                    onPressed: _continueReading,
                    child: const Text('Continue Reading'),
                  ),
                  const Icon(Icons.bookmark),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Surahs'),
                    Tab(text: 'Juzs'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SurahListScreen(
                          audioFlag: 'surah', surahs: widget.surahs),
                      JuzListScreen(surahs: widget.surahs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
