import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  Position? _currentPosition;
  String? _currentCity;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  double _currentHeading = 0;
  bool _vibrated = false;
  late StreamSubscription<CompassEvent> _compassSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startListeningToSensor();
  }

  @override
  void dispose() {
    _compassSubscription.cancel();
    super.dispose();
  }

  void _startListeningToSensor() {
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _currentHeading = event.heading ?? 0;
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _geolocatorPlatform.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await _geolocatorPlatform.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _calculateQiblaDirection();
      _getCityName();
    });
  }

  Future<void> _getCityName() async {
    if (_currentPosition != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      setState(() {
        _currentCity = placemarks.first.locality;
      });
    }
  }

  void _calculateQiblaDirection() {
    if (_currentPosition == null) return;
    const double kaabaLatitude = 21.4225;
    const double kaabaLongitude = 39.8262;

    double latitude = _currentPosition!.latitude;
    double longitude = _currentPosition!.longitude;

    double deltaLongitude = (kaabaLongitude - longitude).toRad();
    double y = math.sin(deltaLongitude);
    double x = math.cos(latitude.toRad()) * math.tan(kaabaLatitude.toRad()) -
        math.sin(latitude.toRad()) * math.cos(deltaLongitude);

    double qiblaDirection = math.atan2(y, x).toDeg();

    setState(() {
      _qiblaDirection = qiblaDirection;
    });
  }

  void _checkQiblaAlignment() {
    if (_qiblaDirection != null &&
        (_currentHeading - _qiblaDirection!).abs() < 5 &&
        !_vibrated) {
      Vibration.vibrate();
      setState(() {
        _vibrated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkQiblaAlignment();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Qibla'),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[100]!, Colors.teal[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _currentPosition == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Location:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900]),
                    ),
                    if (_currentCity != null)
                      Text(
                        'City: $_currentCity',
                        style: TextStyle(fontSize: 18, color: Colors.teal[800]),
                      ),
                    if (_currentCity == null)
                      Text(
                          'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.teal[800])),
                    const SizedBox(height: 20),
                    Text(
                      'Qibla Direction:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900]),
                    ),
                    if (_qiblaDirection != null)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5),
                              border: Border.all(
                                color: Colors.teal,
                                width: 4,
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: ((_qiblaDirection! - _currentHeading) *
                                (math.pi / 180)),
                            child: Column(
                              children: [
                                const Text(
                                  "🕋",
                                  style: TextStyle(fontSize: 24),
                                ),
                                Image.asset('assets/images/compass.png'),
                              ],
                            ),
                          ),
                          // StreamBuilder<CompassEvent>(
                          //   stream: FlutterCompass.events,
                          //   builder: (context, snapshot) {
                          //     print(snapshot);
                          //     double? direction = snapshot.data!.heading;
                          //     print('direction $direction');
                          //     if (direction != null) {
                          //       return Transform.rotate(
                          //         angle: direction * (math.pi / 180) * -1,
                          //         child: Column(
                          //           children: [
                          //             const Text(
                          //               "🕋",
                          //               style: TextStyle(fontSize: 24),
                          //             ),
                          //             Image.asset('assets/images/compass.png'),
                          //           ],
                          //         ),
                          //       );
                          //     } else {
                          //       return Text('No Sensor');
                          //     }
                          //   },
                          // ),
                          // Transform.rotate(
                          //   angle: ((_qiblaDirection! - _currentHeading) *
                          //           (math.pi / 180))
                          //       .toRad(),
                          //   child: Container(
                          //     width: 280,
                          //     height: 280,
                          //     alignment: Alignment.topCenter,
                          //     child: const Text(
                          //       "🕋",
                          //       style: TextStyle(fontSize: 24),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    if (_qiblaDirection == null)
                      const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    if (_qiblaDirection != null &&
                        (_currentHeading - _qiblaDirection!).abs() < 5)
                      _buildMessageContainer(
                          'You are facing the Qibla', Colors.green),
                    if (_qiblaDirection != null &&
                        (_currentHeading - _qiblaDirection!).abs() >= 5)
                      _buildMessageContainer(
                          'Rotate your phone until the arrow faces the Kaabah icon.',
                          Colors.red),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMessageContainer(String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        message,
        style:
            TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

extension _Rad on double {
  double toRad() => this * math.pi / 180.0;
}

extension _Deg on double {
  double toDeg() => this * 180.0 / math.pi;
}
