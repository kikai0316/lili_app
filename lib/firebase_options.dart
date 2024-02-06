// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
    apiKey: 'AIzaSyCqu7j8E2ULBNOJzjqmNqpgdRQNhi2vQ88',
    appId: '1:568528201860:web:13904ab73ae72c2b22fad1',
    messagingSenderId: '568528201860',
    projectId: 'lili-app-61e17',
    authDomain: 'lili-app-61e17.firebaseapp.com',
    storageBucket: 'lili-app-61e17.appspot.com',
    measurementId: 'G-9836450GQR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDh73aCdJPZvPHwD2BVseNqLoahHXd0g5o',
    appId: '1:568528201860:android:8905678506f65e0b22fad1',
    messagingSenderId: '568528201860',
    projectId: 'lili-app-61e17',
    storageBucket: 'lili-app-61e17.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1IN8ST5bR9sIGSfLaAPf0EmfY4HvRj8A',
    appId: '1:568528201860:ios:22d265be5246109022fad1',
    messagingSenderId: '568528201860',
    projectId: 'lili-app-61e17',
    storageBucket: 'lili-app-61e17.appspot.com',
    iosClientId:
        '568528201860-mvf783u60cf60hittsp3er0n0pclb0lp.apps.googleusercontent.com',
    iosBundleId: 'com.liliApp.jp.jds',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1IN8ST5bR9sIGSfLaAPf0EmfY4HvRj8A',
    appId: '1:568528201860:ios:2b3543f458c998a622fad1',
    messagingSenderId: '568528201860',
    projectId: 'lili-app-61e17',
    storageBucket: 'lili-app-61e17.appspot.com',
    iosClientId:
        '568528201860-97toacg98lmjc2rlm3h0u32mkb0so5jm.apps.googleusercontent.com',
    iosBundleId: 'com.example.liliApp.RunnerTests',
  );
}
