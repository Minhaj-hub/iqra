import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkPurple = Colors.purple[800]!;
    final Color lightPurple = Colors.purple[200]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: darkPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Light background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bismillah_calligraphy.png', // Ensure this image is available in assets
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    _buildAnimatedText(
                      'Bismillahir Rahmanir Raheem',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('🌟 Gratitude to Allah 🌟', darkPurple),
              _buildSectionText(
                'First and foremost, all praises and thanks are due to Allah, the Most High, for allowing me to be a means (jariya) in developing this app. Without His guidance and mercy, this would not have been possible.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('🤲 A Humble Servant 🤲', darkPurple),
              _buildSectionText(
                'I am but a sinner who constantly seeks Allah\'s mercy and forgiveness. My greatest fear is being away from His mercy even for the blink of an eye. I believe that the most profitable business is the spreading of knowledge, and the best investment is that which is made for the Aakhirah (Hereafter) because that is our true saving. The Prophet ﷺ emphasized the great importance of spreading knowledge, even if it is a single verse from the Qur\'an. He said, "Convey from me, even if it is one ayah." (Sahih al-Bukhari)',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('📖 The Inspiration 📖', darkPurple),
              _buildSectionText(
                'I prayed to Allah to make me a means (jariya) to serve the Ummah in any way possible. I noticed that many young Muslims lacked access to a Quran app that could help them read and understand the Quran in Roman Hindi-Urdu. This app was born out of that need, offering features such as:',
              ),
              _buildFeatureList(),
              const SizedBox(height: 20),
              _buildSectionTitle('📚 Sources 📚', darkPurple),
              _buildSectionText(
                '- Quran Content: From "Ahsanul Kalaam".\n- Dhikr/Dua: From "Hisnul Muslim".',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('❤️ Special Thanks ❤️', darkPurple),
              _buildSectionText(
                'I extend my heartfelt thanks to my brother Azim for his invaluable help in updating the Quranic verses and my brother Anas for designing the graphics. Please remember them in your dua.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('❗ Corrections and Feature Requests ❗', darkPurple),
              _buildSectionText(
                'If you find any mistakes or have suggestions for new features, please do not hesitate to reach out to me on X (Twitter) or Instagram @amanmaqsood. I am committed to making this app as accurate and beneficial as possible.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('💖 A Prayer 💖', darkPurple),
              _buildSectionText(
                'May Allah be pleased with this effort, and may this app benefit the Ummah. I ask Allah to accept it as a means of goodness for all who use it. Ameen.',
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // White background
                          side: const BorderSide(color: Colors.black), // Black border
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(FontAwesomeIcons.xTwitter, color: Colors.black),
                        label: const Text(
                          'Follow on X',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        onPressed: () => _launchUrl('https://twitter.com/amanmaqsood'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink, // Instagram logo theme color
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
                        label: const Text(
                          'Follow on Instagram',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        onPressed: () => _launchUrl('https://instagram.com/itsamanmaqsood'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text, {required TextStyle style}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double val, Widget? child) {
        return Opacity(
          opacity: val,
          child: Padding(
            padding: EdgeInsets.only(top: val * 10),
            child: child,
          ),
        );
      },
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildFeatureList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem('Arabic Text & Transliteration'),
          _buildFeatureItem('Translation & Deep Meaning'),
          _buildFeatureItem('Surah and Verse Audio'),
          _buildFeatureItem('Dhikr and Duas'),
          _buildFeatureItem('Prayer Times with Notifications'),
          _buildFeatureItem('Tasbeeh Counter'),
          _buildFeatureItem('Qibla Finder'),
          _buildFeatureItem('Favourite Section'),
          _buildFeatureItem('Daily Hadith on WhatsApp'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.purple),
          const SizedBox(width: 8),
          Text(
            feature,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
