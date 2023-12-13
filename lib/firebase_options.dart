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
    apiKey: 'AIzaSyCm8BPwoYXL9naD5dj0sgKlOBREmvBGy4M',
    appId: '1:922256000367:web:b161bb7aaafe5bfdd6949a',
    messagingSenderId: '922256000367',
    projectId: 'esrkr-app',
    authDomain: 'esrkr-app.firebaseapp.com',
    databaseURL: 'https://esrkr-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'esrkr-app.appspot.com',
    measurementId: 'G-PTLKXFXF6F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDqW-2hA1dM5rOLl9kVE6Dhp5EsqUhNfE',
    appId: '1:922256000367:android:5d3aee3de0b5955bd6949a',
    messagingSenderId: '922256000367',
    projectId: 'esrkr-app',
    databaseURL: 'https://esrkr-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'esrkr-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVKhC-9Laj55wmlfZqc8fMeNrHWZj2wT4',
    appId: '1:922256000367:ios:b81d57cc715193edd6949a',
    messagingSenderId: '922256000367',
    projectId: 'esrkr-app',
    databaseURL: 'https://esrkr-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'esrkr-app.appspot.com',
    androidClientId: '922256000367-pr4gj3k622slqgjf8pfspm9gdjidjji4.apps.googleusercontent.com',
    iosBundleId: 'com.nimmalasujith.srkrStudyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVKhC-9Laj55wmlfZqc8fMeNrHWZj2wT4',
    appId: '1:922256000367:ios:f8d0b214d85802b0d6949a',
    messagingSenderId: '922256000367',
    projectId: 'esrkr-app',
    databaseURL: 'https://esrkr-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'esrkr-app.appspot.com',
    androidClientId: '922256000367-pr4gj3k622slqgjf8pfspm9gdjidjji4.apps.googleusercontent.com',
    iosBundleId: 'com.nimmalasujith.srkrStudyApp.RunnerTests',
  );
}
