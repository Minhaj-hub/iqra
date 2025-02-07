// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-4DaPOx53GmZEFSpGxp9w6vze1V9gPHo',
    appId: '1:109929743130:web:7452ffedab6f74a6fbe2a3',
    messagingSenderId: '109929743130',
    projectId: 'quraan-5c4f4',
    authDomain: 'quraan-5c4f4.firebaseapp.com',
    storageBucket: 'quraan-5c4f4.appspot.com',
    measurementId: 'G-5DBDQTRLTC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCipduIqYyj6q_rfXw03R2ZjvrWfv3TISw',
    appId: '1:109929743130:android:3c615494de067f7cfbe2a3',
    messagingSenderId: '109929743130',
    projectId: 'quraan-5c4f4',
    storageBucket: 'quraan-5c4f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf6WXytSq55YAOS26nEgj1UKJIE_QndBg',
    appId: '1:109929743130:ios:db99f0fc78657f1cfbe2a3',
    messagingSenderId: '109929743130',
    projectId: 'quraan-5c4f4',
    storageBucket: 'quraan-5c4f4.appspot.com',
    iosBundleId: 'com.example.quranNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAf6WXytSq55YAOS26nEgj1UKJIE_QndBg',
    appId: '1:109929743130:ios:db99f0fc78657f1cfbe2a3',
    messagingSenderId: '109929743130',
    projectId: 'quraan-5c4f4',
    storageBucket: 'quraan-5c4f4.appspot.com',
    iosBundleId: 'com.example.quranNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB-4DaPOx53GmZEFSpGxp9w6vze1V9gPHo',
    appId: '1:109929743130:web:5fc58e6cdc2db282fbe2a3',
    messagingSenderId: '109929743130',
    projectId: 'quraan-5c4f4',
    authDomain: 'quraan-5c4f4.firebaseapp.com',
    storageBucket: 'quraan-5c4f4.appspot.com',
    measurementId: 'G-CPLW0YGQHX',
  );

}