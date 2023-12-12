// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD80VRCTzLph-iUQP32tCxE0e1cALXxFMc',
    appId: '1:412796109235:web:242f3b7d6fafb9e7178bc6',
    messagingSenderId: '412796109235',
    projectId: 'workoutdiary-f43ad',
    authDomain: 'workoutdiary-f43ad.firebaseapp.com',
    storageBucket: 'workoutdiary-f43ad.appspot.com',
    measurementId: 'G-3XGM9REH36',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVtx1hQkVkvA6gZ4KoOWBQwf2Cd4R-G5s',
    appId: '1:412796109235:android:5d42136a5ffb9ab1178bc6',
    messagingSenderId: '412796109235',
    projectId: 'workoutdiary-f43ad',
    storageBucket: 'workoutdiary-f43ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyzpCUrLJVK04rnBjvWz04pwLrK2VqfdI',
    appId: '1:412796109235:ios:489e59d79fb7d0c5178bc6',
    messagingSenderId: '412796109235',
    projectId: 'workoutdiary-f43ad',
    storageBucket: 'workoutdiary-f43ad.appspot.com',
    iosBundleId: 'com.example.workoutdiary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyzpCUrLJVK04rnBjvWz04pwLrK2VqfdI',
    appId: '1:412796109235:ios:63460b74ebcf392e178bc6',
    messagingSenderId: '412796109235',
    projectId: 'workoutdiary-f43ad',
    storageBucket: 'workoutdiary-f43ad.appspot.com',
    iosBundleId: 'com.example.workoutdiary.RunnerTests',
  );
}