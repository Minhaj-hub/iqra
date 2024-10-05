import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

Future<bool?> requestExactAlarmsPermission() async {
  bool? status = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();

  return status;
}
