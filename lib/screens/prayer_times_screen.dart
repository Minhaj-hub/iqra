// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:uuid/uuid.dart';
// import '../data_manager.dart'; // Import DataManager

// class PrayerTimesScreen extends StatefulWidget {
//   const PrayerTimesScreen({super.key});

//   @override
//   _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
// }

// class _PrayerTimesScreenState extends State<PrayerTimesScreen>
//     with WidgetsBindingObserver {
//   Map<String, String> prayerTimes = {
//     'Fajr': 'Loading...',
//     'Sunrise': 'Loading...',
//     'Zuhr': 'Loading...',
//     'Asr': 'Loading...',
//     'Maghrib': 'Loading...',
//     'Isha': 'Loading...',
//     'Tahajjud': 'Loading...', // Added Tahajjud
//   };
//   bool isLoading = true;
//   String errorMessage = '';
//   String currentLocation = 'New Delhi, Delhi, India';
//   String currentCountry = 'India';
//   DateTime selectedDate = DateTime.now();
//   bool locationServiceEnabled = false;
//   bool locationPermissionGranted = false;
//   bool isFetchingLocation = false;

//   final List<String> prayerNames = [
//     'Fajr',
//     'Sunrise',
//     'Zuhr',
//     'Asr',
//     'Maghrib',
//     'Isha',
//     'Tahajjud', // Added Tahajjud
//   ];
//   AudioPlayer audioPlayer = AudioPlayer();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   Map<String, String> reminderTypeMap = {}; // To store reminder types
//   Map<String, bool> customReminderEnabledMap =
//       {}; // To store custom reminder states
//   Map<String, String> reminderTimeMap = {}; // To store reminder time states
//   Map<String, int> reminderMinutesMap = {}; // To store reminder minutes

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeNotifications();
//     _checkLocationServices();
//     _loadSavedLocation();
//     _loadNotificationSettings(); // Load saved notification settings
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _checkLocationServices();
//     }
//   }

//   Future<void> _initializeNotifications() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _checkLocationServices() async {
//     locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     locationPermissionGranted = await _checkPermission();
//     setState(() {});

//     if (locationServiceEnabled && locationPermissionGranted) {
//       if (DataManager().position == null) {
//         _getCurrentPosition();
//       }
//     }
//   }

//   Future<bool> _checkPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }

//   Future<void> _enableLocationServices() async {
//     await Geolocator.openLocationSettings();
//     _checkLocationServices();
//   }

//   Future<void> _loadSavedLocation() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       currentLocation =
//           prefs.getString('savedLocation') ?? 'New Delhi, Delhi, India';
//       currentCountry = prefs.getString('savedCountry') ?? 'India';
//     });
//     _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
//   }

//   Future<void> _fetchPrayerTimes(
//       String location, String country, DateTime date) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       final year = date.year;
//       final month = date.month;
//       final day = date.day;

//       // Check if we already have the data for the current date
//       if (DataManager().isCachedDataValid(location, country, date)) {
//         setState(() {
//           prayerTimes = DataManager().prayerTimes!;
//           isLoading = false;
//         });
//         print('Using cached prayer times');
//         return;
//       }

//       final response = await http.get(Uri.parse(
//           'http://api.aladhan.com/v1/calendarByCity/$year/$month?city=${Uri.encodeComponent(location)}&country=${Uri.encodeComponent(country)}&method=2'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body)['data'];
//         print('Fetched prayer times data: ${json.encode(data)}');

//         // Correctly parse the day from the response to ensure matching
//         final dayData = data.firstWhere((dayData) {
//           String responseDay = dayData['date']['gregorian']['day'];
//           print(
//               'Checking response day: $responseDay against day: ${day.toString().padLeft(2, '0')}');
//           return responseDay == day.toString().padLeft(2, '0');
//         }, orElse: () => null);

//         if (dayData != null) {
//           final timings = dayData['timings'] as Map<String, dynamic>;

//           setState(() {
//             prayerTimes = {
//               'Fajr': timings['Fajr'].toString(),
//               'Sunrise': timings['Sunrise'].toString(),
//               'Zuhr': timings['Dhuhr'].toString(), // Map Zuhr to Dhuhr
//               'Asr': timings['Asr'].toString(),
//               'Maghrib': timings['Maghrib'].toString(),
//               'Isha': timings['Isha'].toString(),
//               'Tahajjud':
//                   timings['Lastthird'].toString(), // Map Tahajjud to Lastthird
//             };
//             isLoading = false;
//           });

//           // Store the data in DataManager
//           DataManager().setPrayerTimes(prayerTimes, date); // Pass date here
//           DataManager().setLocation(location);
//           DataManager().setCountry(country);
//         } else {
//           throw Exception('No data for the selected date');
//         }
//       } else {
//         throw Exception('Failed to load prayer times');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load prayer times. Please try again later.';
//       });
//       print('Error: $e');
//     }
//   }

//   Future<void> _getCurrentPosition() async {
//     setState(() {
//       isFetchingLocation = true;
//     });

//     try {
//       // Check if we already have the position
//       if (DataManager().position != null) {
//         Position position = DataManager().position!;
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//           position.latitude,
//           position.longitude,
//         );
//         Placemark placemark = placemarks.first;
//         String location = placemark.locality ?? 'Unknown location';
//         String country = placemark.country ?? 'India';

//         setState(() {
//           currentLocation = location;
//           currentCountry = country;
//           isFetchingLocation = false;
//         });
//         _fetchPrayerTimes(location, country, selectedDate);
//         print('Using cached position');
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       Placemark placemark = placemarks.first;
//       String location = placemark.locality ?? 'Unknown location';
//       String country = placemark.country ?? 'India';

//       setState(() {
//         currentLocation = location;
//         currentCountry = country;
//         isFetchingLocation = false;
//       });
//       _fetchPrayerTimes(location, country, selectedDate);
//       _saveLocation(location, country);

//       // Store the position in DataManager
//       DataManager().setPosition(position);
//     } catch (e) {
//       setState(() {
//         isFetchingLocation = false;
//         errorMessage =
//             'Failed to get current location. Please enable location services.';
//       });
//       print('Error: $e');
//     }
//   }

//   Future<void> _saveLocation(String location, String country) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('savedLocation', location);
//     await prefs.setString('savedCountry', country);
//   }

//   void _changeLocation() async {
//     final newLocation = await showDialog<String>(
//       context: context,
//       builder: (context) {
//         String tempLocation = currentLocation;
//         return AlertDialog(
//           title: const Text('Change Location'),
//           content: TextField(
//             onChanged: (value) {
//               tempLocation = value;
//             },
//             decoration: const InputDecoration(
//               hintText: 'Enter location',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(tempLocation);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//     if (newLocation != null && newLocation.isNotEmpty) {
//       // Fetch country for the new location
//       try {
//         List<Location> locations = await locationFromAddress(newLocation);
//         if (locations.isNotEmpty) {
//           List<Placemark> placemarks = await placemarkFromCoordinates(
//             locations.first.latitude,
//             locations.first.longitude,
//           );
//           Placemark placemark = placemarks.first;
//           String country = placemark.country ?? 'India';

//           setState(() {
//             currentLocation = newLocation;
//             currentCountry = country;
//           });
//           _fetchPrayerTimes(newLocation, country, selectedDate);
//           _saveLocation(newLocation, country);
//         }
//       } catch (e) {
//         setState(() {
//           errorMessage = 'Failed to fetch country for the new location';
//         });
//         print('Error: $e');
//       }
//     }
//   }

//   void _changeDate(int days) {
//     setState(() {
//       selectedDate = selectedDate.add(Duration(days: days));
//     });
//     _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
//   }

//   void _pickDate() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//       _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
//     }
//   }

//   void _loadNotificationSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       for (var prayer in prayerNames) {
//         reminderTypeMap[prayer] = prefs.getString('$prayer-reminderType') ??
//             'Don\'t send me a reminder';
//         customReminderEnabledMap[prayer] =
//             prefs.getBool('$prayer-customReminderEnabled') ?? false;
//         reminderTimeMap[prayer] =
//             prefs.getString('$prayer-reminderTime') ?? 'Before';
//         reminderMinutesMap[prayer] =
//             prefs.getInt('$prayer-reminderMinutes') ?? 0;
//       }
//     });
//   }

//   Future<void> _saveNotificationSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     for (var prayer in prayerNames) {
//       await prefs.setString('$prayer-reminderType', reminderTypeMap[prayer]!);
//       await prefs.setBool(
//           '$prayer-customReminderEnabled', customReminderEnabledMap[prayer]!);
//       await prefs.setString('$prayer-reminderTime', reminderTimeMap[prayer]!);
//       await prefs.setInt(
//           '$prayer-reminderMinutes', reminderMinutesMap[prayer]!);
//     }
//   }

//   void _showReminderPopup(String prayerName, String prayerTime) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       '$prayerName Reminder',
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 16),
//                     ListTile(
//                       leading: const Icon(Icons.notifications_off),
//                       title: const Text('Don\'t send me a reminder'),
//                       trailing: reminderTypeMap[prayerName] ==
//                               'Don\'t send me a reminder'
//                           ? const Icon(Icons.check, color: Colors.green)
//                           : null,
//                       onTap: () {
//                         setState(() {
//                           reminderTypeMap[prayerName] =
//                               'Don\'t send me a reminder';
//                         });
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.notifications),
//                       title: const Text('Send me a reminder'),
//                       trailing:
//                           reminderTypeMap[prayerName] == 'Send me a reminder'
//                               ? const Icon(Icons.check, color: Colors.green)
//                               : null,
//                       onTap: () {
//                         void fun() {
//                           setState(() {
//                             reminderTypeMap[prayerName] = 'Send me a reminder';
//                           });
//                         }

//                         requestNotificationPermission(fun);
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.notifications_active),
//                       title:
//                           const Text('Send me a reminder and play adhan sound'),
//                       trailing: reminderTypeMap[prayerName] ==
//                               'Send me a reminder and play adhan sound'
//                           ? const Icon(Icons.check, color: Colors.green)
//                           : null,
//                       onTap: () async {
//                         void func() {
//                           setState(() {
//                             reminderTypeMap[prayerName] =
//                                 'Send me a reminder and play adhan sound';
//                           });
//                         }

//                         requestNotificationPermission(func);
//                       },
//                     ),
//                     SwitchListTile(
//                       title: const Text('Custom Reminders'),
//                       value: customReminderEnabledMap[prayerName]!,
//                       onChanged: (bool value) {
//                         setState(() {
//                           customReminderEnabledMap[prayerName] = value;
//                         });
//                       },
//                     ),
//                     if (customReminderEnabledMap[prayerName]!)
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: DropdownButton<String>(
//                                   value: reminderTimeMap[prayerName],
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       reminderTimeMap[prayerName] = newValue!;
//                                     });
//                                   },
//                                   items: <String>['Before', 'After']
//                                       .map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: TextField(
//                                   keyboardType: TextInputType.number,
//                                   decoration: const InputDecoration(
//                                     labelText: 'Enter minutes',
//                                   ),
//                                   onChanged: (value) {
//                                     reminderMinutesMap[prayerName] =
//                                         int.tryParse(value) ?? 0;
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     ElevatedButton(
//                       onPressed: () {
//                         void fun() {
//                           _scheduleReminder(
//                               prayerName,
//                               prayerTime,
//                               reminderTypeMap[prayerName]!,
//                               reminderMinutesMap[prayerName]!);
//                           _saveNotificationSettings(); // Save settings after updating
//                         }

//                         requestNotificationPermission(fun);
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Save'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _scheduleReminder(String prayerName, String prayerTime,
//       String reminderType, reminderMinutes) async {
//     if (reminderType != 'Don\'t send me a reminder') {
//       final timeParts = prayerTime.substring(0, 5).split(':');
//       final hour = int.parse(timeParts[0]);
//       final minute = int.parse(timeParts[1]);
//       DateTime now = DateTime.now();
//       var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

//       if (customReminderEnabledMap[prayerName]! && reminderMinutes != null) {
//         if (reminderTimeMap[prayerName] == 'Before') {
//           scheduledTime =
//               scheduledTime.subtract(Duration(minutes: reminderMinutes));
//         } else if (reminderTimeMap[prayerName] == 'After') {
//           scheduledTime = scheduledTime.add(Duration(minutes: reminderMinutes));
//         }
//       }

//       print('scheduledTime $scheduledTime//////////////////');

//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         2,
//         // prayerName.hashCode, // Unique ID for each notification
//         'Prayer Time Reminder',
//         'It is time for $prayerName prayer',
//         tz.TZDateTime.from(scheduledTime, tz.local),
//         const NotificationDetails(
//           android: AndroidNotificationDetails('channel id', 'channel name',
//               channelDescription: 'channel description',
//               importance: Importance.max,
//               priority: Priority.high,
//               showWhen: false),
//           iOS: DarwinNotificationDetails(),
//         ),
//         androidScheduleMode: AndroidScheduleMode.alarmClock,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );

//       if (reminderType == 'Send me a reminder and play adhan sound') {
//         final soundFile = prayerName == 'Fajr' ? 'fajr_adhan' : 'regular_adhan';
//         const int insistentFlag = 4;

//         await flutterLocalNotificationsPlugin.zonedSchedule(
//           3,
//           // prayerName.hashCode + 1, // Unique ID for each sound notification
//           'This is Adhan sound',
//           'This is Adhan sound Body',
//           tz.TZDateTime.from(scheduledTime, tz.local),
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'adhan channel', 'adhan channel',
//                 channelDescription: 'adhan channel description',
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 audioAttributesUsage: AudioAttributesUsage.alarm,
//                 additionalFlags: Int32List.fromList(<int>[insistentFlag]),
//                 sound: RawResourceAndroidNotificationSound(soundFile)),
//             iOS: DarwinNotificationDetails(sound: '$soundFile.aiff'),
//           ),
//           androidScheduleMode: AndroidScheduleMode.alarmClock,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//         );
//       }
//     }
//   }

//   Future<bool> requestNotificationPermissions() async {
//     final PermissionStatus status = await Permission.notification.request();
//     return status.isGranted;
//   }

//   Future<void> requestNotificationPermission(Function func) async {
//     if (await Permission.notification.isGranted) {
//       func();
//     } else {
//       final status = await Permission.notification.request();
//       if (status.isGranted) {
//         func();
//       } else {
//         if (mounted) Navigator.pop(context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           if ((isFetchingLocation ||
//                   !locationServiceEnabled ||
//                   !locationPermissionGranted) &&
//               DataManager().position == null)
//             Container(
//               color: Colors.purple[100],
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       !locationServiceEnabled || !locationPermissionGranted
//                           ? 'Enable location to get accurate Adhaan timings.'
//                           : 'Fetching your location to show accurate Adhaan time.',
//                       style: const TextStyle(color: Colors.purple),
//                     ),
//                   ),
//                   if (!locationServiceEnabled || !locationPermissionGranted)
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: _enableLocationServices,
//                       child: const Text('Allow'),
//                     ),
//                 ],
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Current Location:',
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.edit_location),
//                       onPressed: _changeLocation,
//                     ),
//                   ],
//                 ),
//                 Text(
//                   currentLocation,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   currentCountry,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       onPressed: () => _changeDate(-1),
//                     ),
//                     GestureDetector(
//                       onTap: _pickDate,
//                       child: Text(
//                         selectedDate.day == DateTime.now().day &&
//                                 selectedDate.month == DateTime.now().month &&
//                                 selectedDate.year == DateTime.now().year
//                             ? 'Today'
//                             : DateFormat('EEEE, dd MMMM yyyy')
//                                 .format(selectedDate),
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.arrow_forward),
//                       onPressed: () => _changeDate(1),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (errorMessage.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 errorMessage,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: prayerNames.length +
//                   1, // Updated to accommodate the message container
//               itemBuilder: (context, index) {
//                 if (index == prayerNames.length) {
//                   // Add the new container with the message here
//                   return Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 10),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.red.shade50,
//                     ),
//                     child: Text(
//                       'Yeh auqat andazi hain, apne maqami auqat se zaroor milan kar lein.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.red.shade400,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 } else {
//                   String prayerName = prayerNames[index];
//                   String prayerTime = prayerTimes[prayerName] ?? 'Loading...';
//                   return Container(
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey.shade200,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               _getPrayerEmoji(prayerName),
//                               style: const TextStyle(fontSize: 24),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               prayerName,
//                               style: TextStyle(
//                                 fontWeight: prayerName == 'Sunrise' ||
//                                         prayerName == 'Tahajjud'
//                                     ? FontWeight.normal
//                                     : FontWeight.bold,
//                                 color: prayerName == 'Sunrise' ||
//                                         prayerName == 'Tahajjud'
//                                     ? Colors.grey
//                                     : Colors.black,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             isLoading
//                                 ? const CircularProgressIndicator()
//                                 : Text(
//                                     prayerTime,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                             IconButton(
//                               icon: const Icon(Icons.notifications),
//                               onPressed: () {
//                                 _showReminderPopup(prayerName, prayerTime);
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getPrayerEmoji(String prayerName) {
//     switch (prayerName) {
//       case 'Fajr':
//         return '🌄'; // Sunrise over mountains
//       case 'Sunrise':
//         return '🌅'; // Sunrise
//       case 'Zuhr':
//         return '☀️'; // Sun
//       case 'Asr':
//         return '🌤️'; // Sun behind cloud
//       case 'Maghrib':
//         return '🌇'; // Sunset over buildings
//       case 'Isha':
//         return '🌙'; // Crescent moon
//       case 'Tahajjud':
//         return '🌌'; // Night sky
//       default:
//         return '⏰'; // Clock
//     }
//   }
// }

import 'dart:typed_data';

import 'package:Iqra/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data_manager.dart';
import '../functions/functions.dart'; // Import DataManager

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with WidgetsBindingObserver {
  Map<String, String> prayerTimes = {
    'Fajr': 'Loading...',
    'Sunrise': 'Loading...',
    'Zuhr': 'Loading...',
    'Asr': 'Loading...',
    'Maghrib': 'Loading...',
    'Isha': 'Loading...',
    'Tahajjud': 'Loading...', // Added Tahajjud
  };
  bool isLoading = true;
  String errorMessage = '';
  String currentLocation = 'New Delhi, Delhi, India';
  String currentCountry = 'India';
  DateTime selectedDate = DateTime.now();
  bool locationServiceEnabled = false;
  bool locationPermissionGranted = false;
  bool isFetchingLocation = false;

  final List<String> prayerNames = [
    'Fajr',
    'Sunrise',
    'Zuhr',
    'Asr',
    'Maghrib',
    'Isha',
    'Tahajjud', // Added Tahajjud
  ];
  AudioPlayer audioPlayer = AudioPlayer();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Map<String, String> reminderTypeMap = {}; // To store reminder types
  Map<String, bool> customReminderEnabledMap =
      {}; // To store custom reminder states
  Map<String, String> reminderTimeMap = {}; // To store reminder time states
  Map<String, int> reminderMinutesMap = {}; // To store reminder minutes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
    _checkLocationServices();
    _loadSavedLocation();
    _loadNotificationSettings(); // Load saved notification settings
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationServices();
    }
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _checkLocationServices() async {
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    locationPermissionGranted = await _checkPermission();
    setState(() {});

    if (locationServiceEnabled && locationPermissionGranted) {
      if (DataManager().position == null) {
        _getCurrentPosition();
      }
    }
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _enableLocationServices() async {
    await Geolocator.openLocationSettings();
    _checkLocationServices();
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLocation =
          prefs.getString('savedLocation') ?? 'New Delhi, Delhi, India';
      currentCountry = prefs.getString('savedCountry') ?? 'India';
    });
    _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
  }

  Future<void> _fetchPrayerTimes(
      String location, String country, DateTime date) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final year = date.year;
      final month = date.month;
      final day = date.day;

      // Check if we already have the data for the current date
      if (DataManager().isCachedDataValid(location, country, date)) {
        setState(() {
          prayerTimes = DataManager().prayerTimes!;
          isLoading = false;
        });
        print('Using cached prayer times');
        return;
      }

      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/calendarByCity/$year/$month?city=${Uri.encodeComponent(location)}&country=${Uri.encodeComponent(country)}&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        print('Fetched prayer times data: ${json.encode(data)}');

        // Correctly parse the day from the response to ensure matching
        final dayData = data.firstWhere((dayData) {
          String responseDay = dayData['date']['gregorian']['day'];
          print(
              'Checking response day: $responseDay against day: ${day.toString().padLeft(2, '0')}');
          return responseDay == day.toString().padLeft(2, '0');
        }, orElse: () => null);

        if (dayData != null) {
          final timings = dayData['timings'] as Map<String, dynamic>;

          setState(() {
            prayerTimes = {
              'Fajr': timings['Fajr'].toString(),
              'Sunrise': timings['Sunrise'].toString(),
              'Zuhr': timings['Dhuhr'].toString(), // Map Zuhr to Dhuhr
              'Asr': timings['Asr'].toString(),
              'Maghrib': timings['Maghrib'].toString(),
              'Isha': timings['Isha'].toString(),
              'Tahajjud':
                  timings['Lastthird'].toString(), // Map Tahajjud to Lastthird
            };
            isLoading = false;
          });

          // Store the data in DataManager
          DataManager().setPrayerTimes(prayerTimes, date); // Pass date here
          DataManager().setLocation(location);
          DataManager().setCountry(country);
        } else {
          throw Exception('No data for the selected date');
        }
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load prayer times. Please try again later.';
      });
      print('Error: $e');
    }
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      isFetchingLocation = true;
    });

    try {
      // Check if we already have the position
      if (DataManager().position != null) {
        Position position = DataManager().position!;
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        Placemark placemark = placemarks.first;
        String location = placemark.locality ?? 'Unknown location';
        String country = placemark.country ?? 'India';

        setState(() {
          currentLocation = location;
          currentCountry = country;
          isFetchingLocation = false;
        });
        _fetchPrayerTimes(location, country, selectedDate);
        print('Using cached position');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark placemark = placemarks.first;
      String location = placemark.locality ?? 'Unknown location';
      String country = placemark.country ?? 'India';

      setState(() {
        currentLocation = location;
        currentCountry = country;
        isFetchingLocation = false;
      });
      _fetchPrayerTimes(location, country, selectedDate);
      _saveLocation(location, country);

      // Store the position in DataManager
      DataManager().setPosition(position);
    } catch (e) {
      setState(() {
        isFetchingLocation = false;
        errorMessage =
            'Failed to get current location. Please enable location services.';
      });
      print('Error: $e');
    }
  }

  Future<void> _saveLocation(String location, String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLocation', location);
    await prefs.setString('savedCountry', country);
  }

  void _changeLocation() async {
    final newLocation = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempLocation = currentLocation;
        return AlertDialog(
          title: const Text('Change Location'),
          content: TextField(
            onChanged: (value) {
              tempLocation = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter location',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(tempLocation);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (newLocation != null && newLocation.isNotEmpty) {
      // Fetch country for the new location
      try {
        List<Location> locations = await locationFromAddress(newLocation);
        if (locations.isNotEmpty) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            locations.first.latitude,
            locations.first.longitude,
          );
          Placemark placemark = placemarks.first;
          String country = placemark.country ?? 'India';

          setState(() {
            currentLocation = newLocation;
            currentCountry = country;
          });
          _fetchPrayerTimes(newLocation, country, selectedDate);
          _saveLocation(newLocation, country);
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to fetch country for the new location';
        });
        print('Error: $e');
      }
    }
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _fetchPrayerTimes(currentLocation, currentCountry, selectedDate);
    }
  }

  void _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var prayer in prayerNames) {
        reminderTypeMap[prayer] = prefs.getString('$prayer-reminderType') ??
            'Don\'t send me a reminder';
        customReminderEnabledMap[prayer] =
            prefs.getBool('$prayer-customReminderEnabled') ?? false;
        reminderTimeMap[prayer] =
            prefs.getString('$prayer-reminderTime') ?? 'Before';
        reminderMinutesMap[prayer] =
            prefs.getInt('$prayer-reminderMinutes') ?? 0;
      }
    });
  }

  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var prayer in prayerNames) {
      await prefs.setString('$prayer-reminderType', reminderTypeMap[prayer]!);
      await prefs.setBool(
          '$prayer-customReminderEnabled', customReminderEnabledMap[prayer]!);
      await prefs.setString('$prayer-reminderTime', reminderTimeMap[prayer]!);
      await prefs.setInt(
          '$prayer-reminderMinutes', reminderMinutesMap[prayer]!);
    }
  }

  void _showReminderPopup(String prayerName, String prayerTime) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$prayerName Reminder',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.notifications_off),
                      title: const Text('Don\'t send me a reminder'),
                      trailing: reminderTypeMap[prayerName] ==
                              'Don\'t send me a reminder'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          reminderTypeMap[prayerName] =
                              'Don\'t send me a reminder';
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Send me a reminder'),
                      trailing:
                          reminderTypeMap[prayerName] == 'Send me a reminder'
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () {
                        void fun() {
                          setState(() {
                            reminderTypeMap[prayerName] = 'Send me a reminder';
                          });
                        }

                        requestNotificationPermission(fun);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title:
                          const Text('Send me a reminder and play adhan sound'),
                      trailing: reminderTypeMap[prayerName] ==
                              'Send me a reminder and play adhan sound'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () async {
                        void func() {
                          setState(() {
                            reminderTypeMap[prayerName] =
                                'Send me a reminder and play adhan sound';
                          });
                        }

                        requestNotificationPermission(func);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Custom Reminders'),
                      value: customReminderEnabledMap[prayerName]!,
                      onChanged: (bool value) {
                        setState(() {
                          customReminderEnabledMap[prayerName] = value;
                        });
                      },
                    ),
                    if (customReminderEnabledMap[prayerName]!)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  value: reminderTimeMap[prayerName],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      reminderTimeMap[prayerName] = newValue!;
                                    });
                                  },
                                  items: <String>['Before', 'After']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter minutes',
                                  ),
                                  onChanged: (value) {
                                    reminderMinutesMap[prayerName] =
                                        int.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {
                        void fun() {
                          _scheduleReminder(
                              prayerName,
                              prayerTime,
                              reminderTypeMap[prayerName]!,
                              reminderMinutesMap[prayerName]!);
                          _saveNotificationSettings(); // Save settings after updating
                        }

                        requestNotificationPermission(fun);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _scheduleReminder(String prayerName, String prayerTime,
      String reminderType, reminderMinutes) async {
    if (reminderType != 'Don\'t send me a reminder') {
      final timeParts = prayerTime.substring(0, 5).split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      DateTime now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

      if (customReminderEnabledMap[prayerName]! && reminderMinutes != null) {
        if (reminderTimeMap[prayerName] == 'Before') {
          scheduledTime =
              scheduledTime.subtract(Duration(minutes: reminderMinutes));
        } else if (reminderTimeMap[prayerName] == 'After') {
          scheduledTime = scheduledTime.add(Duration(minutes: reminderMinutes));
        }
      }

      print('scheduledTime//////// $scheduledTime');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        // prayerName.hashCode, // Unique ID for each notification
        'Prayer Time Reminder',
        'It is time for $prayerName prayer',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails('channel id', 'channel name',
              channelDescription: 'channel description',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      if (reminderType == 'Send me a reminder and play adhan sound') {
        final soundFile = prayerName == 'Fajr' ? 'fajr_adhan' : 'regular_adhan';
        const int insistentFlag = 4;

        await flutterLocalNotificationsPlugin.zonedSchedule(
          1,
          // prayerName.hashCode + 1, // Unique ID for each sound notification
          'Adhan Sound',
          '',
          tz.TZDateTime.from(scheduledTime, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
                'adhan channel id', 'adhan channel name',
                channelDescription: 'adhan channel description',
                importance: Importance.max,
                priority: Priority.high,
                audioAttributesUsage: AudioAttributesUsage.alarm,
                additionalFlags: Int32List.fromList(<int>[insistentFlag]),
                sound: RawResourceAndroidNotificationSound(soundFile)),
            iOS: DarwinNotificationDetails(sound: '$soundFile.aiff'),
          ),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }

  Future<bool> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> requestNotificationPermission(Function func) async {
    if (await Permission.notification.isGranted) {
      func();
    } else {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        func();
      } else {
        void open() {
          openAppSettings();
        }

        showPopDialog(
            context,
            'Permission Needed',
            'You need to allow notification permissions in order to receive Adhan time notifications.',
            'Cancel',
            'Allow',
            open);

        // if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if ((isFetchingLocation ||
                  !locationServiceEnabled ||
                  !locationPermissionGranted) &&
              DataManager().position == null)
            Container(
              color: Colors.purple[100],
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      !locationServiceEnabled || !locationPermissionGranted
                          ? 'Enable location to get accurate Adhaan timings.'
                          : 'Fetching your location to show accurate Adhaan time.',
                      style: const TextStyle(color: Colors.purple),
                    ),
                  ),
                  if (!locationServiceEnabled || !locationPermissionGranted)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _enableLocationServices,
                      child: const Text('Allow'),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Location:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_location),
                      onPressed: _changeLocation,
                    ),
                  ],
                ),
                Text(
                  currentLocation,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  currentCountry,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _changeDate(-1),
                    ),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Text(
                        selectedDate.day == DateTime.now().day &&
                                selectedDate.month == DateTime.now().month &&
                                selectedDate.year == DateTime.now().year
                            ? 'Today'
                            : DateFormat('EEEE, dd MMMM yyyy')
                                .format(selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => _changeDate(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: prayerNames.length +
                  1, // Updated to accommodate the message container
              itemBuilder: (context, index) {
                if (index == prayerNames.length) {
                  // Add the new container with the message here
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red.shade50,
                    ),
                    child: Text(
                      'Yeh auqat andazi hain, apne maqami auqat se zaroor milan kar lein.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  String prayerName = prayerNames[index];
                  String prayerTime = prayerTimes[prayerName] ?? 'Loading...';
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _getPrayerEmoji(prayerName),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              prayerName,
                              style: TextStyle(
                                fontWeight: prayerName == 'Sunrise' ||
                                        prayerName == 'Tahajjud'
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: prayerName == 'Sunrise' ||
                                        prayerName == 'Tahajjud'
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    prayerTime,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                            IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                void askPermission() async {
                                  bool? granted =
                                      await requestExactAlarmsPermission();

                                  if (granted != null) {
                                    if (granted) {
                                      _showReminderPopup(
                                          prayerName, prayerTime);
                                    }
                                  }
                                }

                                showPopDialog(
                                    context,
                                    'Permission Needed',
                                    'You need to give Alaram & Clock Permssion in order to remind you Adhan time at Exact time.',
                                    'Cancel',
                                    'Ok',
                                    askPermission);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerEmoji(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return '🌄'; // Sunrise over mountains
      case 'Sunrise':
        return '🌅'; // Sunrise
      case 'Zuhr':
        return '☀️'; // Sun
      case 'Asr':
        return '🌤️'; // Sun behind cloud
      case 'Maghrib':
        return '🌇'; // Sunset over buildings
      case 'Isha':
        return '🌙'; // Crescent moon
      case 'Tahajjud':
        return '🌌'; // Night sky
      default:
        return '⏰'; // Clock
    }
  }
}
