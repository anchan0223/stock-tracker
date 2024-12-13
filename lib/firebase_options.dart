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
    apiKey: 'AIzaSyDulng2dj-RfzIltxhP_cHd2hBgivDpwQE',
    appId: '1:733200508618:web:eb408e48c01bf1acfe7633',
    messagingSenderId: '733200508618',
    projectId: 'stock-tracker-project-2',
    authDomain: 'stock-tracker-project-2.firebaseapp.com',
    storageBucket: 'stock-tracker-project-2.firebasestorage.app',
    measurementId: 'G-ZLLQ2GQ3FM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuW7tSffZoM6_JKURW8i12O0iz21COBPE',
    appId: '1:733200508618:android:748df484f5049935fe7633',
    messagingSenderId: '733200508618',
    projectId: 'stock-tracker-project-2',
    storageBucket: 'stock-tracker-project-2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARAkozxw8jQbpqk7aIKUmQPYLzHojz8m8',
    appId: '1:733200508618:ios:534e6a0319527f18fe7633',
    messagingSenderId: '733200508618',
    projectId: 'stock-tracker-project-2',
    storageBucket: 'stock-tracker-project-2.firebasestorage.app',
    iosBundleId: 'com.example.stockTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARAkozxw8jQbpqk7aIKUmQPYLzHojz8m8',
    appId: '1:733200508618:ios:534e6a0319527f18fe7633',
    messagingSenderId: '733200508618',
    projectId: 'stock-tracker-project-2',
    storageBucket: 'stock-tracker-project-2.firebasestorage.app',
    iosBundleId: 'com.example.stockTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDulng2dj-RfzIltxhP_cHd2hBgivDpwQE',
    appId: '1:733200508618:web:9dfdf4a68b51ce40fe7633',
    messagingSenderId: '733200508618',
    projectId: 'stock-tracker-project-2',
    authDomain: 'stock-tracker-project-2.firebaseapp.com',
    storageBucket: 'stock-tracker-project-2.firebasestorage.app',
    measurementId: 'G-3FNLYJ2QN2',
  );
}