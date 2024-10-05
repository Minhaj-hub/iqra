import 'package:Iqra/provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'data/surahs.dart';
import 'data_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  var initializationSettingsAndroid = const AndroidInitializationSettings(
      'app_icon'); // Ensure 'mipmap/app_icon' is correct
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  DataManager().clearData(); // Clear data on app start

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
      ],
      child: const MyApp(),
    ),
  );
  ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp'); // Debug print
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Surah>>(
        future: loadSurahs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading Surahs...'); // Debug print
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Debug print
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            print('Surahs loaded: ${snapshot.data!.length}'); // Debug print
            return MainScreen(surahs: snapshot.data!);
          } else {
            print('No data found'); // Debug print
            return const Scaffold(
              body: Center(child: Text('No data found')),
            );
          }
        },
      ),
      navigatorObservers: [routeObserver],
    );
  }
}

Future<List<Surah>> loadSurahs() async {
  try {
    String data = await rootBundle.loadString('assets/quran_data.json');
    return parseSurahs(data);
  } catch (e) {
    print('Error loading surahs: $e'); // Debug print
    return [];
  }
}

List<Surah> parseSurahs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Surah>((json) {
    try {
      return Surah.fromJson(json);
    } catch (e) {
      print('Error parsing surah: $e'); // Debug print
      return Surah(
        name: 'Error', // Provide default error value
        numberOfVerses: 0,
        arabicName: 'Error',
        verses: [], // Empty list for verses
        isMeccan: false, // Default value
      );
    }
  }).toList();
}

Future<Position> _getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<Map<String, dynamic>> _fetchPrayerTimes(
    double latitude, double longitude) async {
  final response = await http.get(Uri.parse(
      'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'));

  if (response.statusCode == 200) {
    return json.decode(response.body)['data']['timings'];
  } else {
    throw Exception('Failed to load prayer times');
  }
}

Future<void> _scheduleNotifications(Map<String, dynamic> prayerTimes) async {
  for (var entry in prayerTimes.entries) {
    var time = entry.value.split(':');
    var hour = int.parse(time[0]);
    var minute = int.parse(time[1]);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      entry.key.hashCode,
      'Adhaan Reminder',
      '${entry.key} prayer time',
      _nextInstanceOfTime(hour, minute),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
