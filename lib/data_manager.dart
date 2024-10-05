import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  Position? _position;
  Map<String, String>? _prayerTimes;
  String? _location;
  String? _country;
  DateTime? _date;

  Position? get position => _position;
  Map<String, String>? get prayerTimes => _prayerTimes;
  String? get location => _location;
  String? get country => _country;
  DateTime? get date => _date;

  void setPosition(Position position) {
    _position = position;
    print('Position set: $position');
  }

  void setPrayerTimes(Map<String, String> prayerTimes, DateTime date) {
    _prayerTimes = prayerTimes;
    _date = date;
    print('Prayer times set: $prayerTimes for date: $date');
  }

  void setLocation(String location) {
    _location = location;
    print('Location set: $location');
  }

  void setCountry(String country) {
    _country = country;
    print('Country set: $country');
  }

  void setDate(DateTime date) {
    _date = date;
    print('Date set: $date');
  }

  void clearData() {
    _position = null;
    _prayerTimes = null;
    _location = null;
    _country = null;
    _date = null;
    print('Data cleared');
  }

  bool isCachedDataValid(String location, String country, DateTime date) {
    return _location == location &&
        _country == country &&
        _date != null &&
        _date!.year == date.year &&
        _date!.month == date.month &&
        _date!.day == date.day;
  }

  // Updated methods for saving and retrieving individual notification settings
  Future<void> saveNotificationSettings(String prayer, String reminderType, bool customReminderEnabled, String reminderTime, int reminderMinutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminderType_$prayer', reminderType);
    await prefs.setBool('customReminderEnabled_$prayer', customReminderEnabled);
    await prefs.setString('reminderTime_$prayer', reminderTime);
    await prefs.setInt('reminderMinutes_$prayer', reminderMinutes);
  }

  Future<Map<String, dynamic>> getNotificationSettings(String prayer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'reminderType': prefs.getString('reminderType_$prayer') ?? 'Don\'t send me a reminder',
      'customReminderEnabled': prefs.getBool('customReminderEnabled_$prayer') ?? false,
      'reminderTime': prefs.getString('reminderTime_$prayer') ?? 'Before',
      'reminderMinutes': prefs.getInt('reminderMinutes_$prayer') ?? 0,
    };
  }
}
