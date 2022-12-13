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
    apiKey: 'AIzaSyDTf_N2NT90y-tB_27mVhKXJpZC1_QhzqA',
    appId: '1:641358260927:web:5f09855b09ac97a18f340a',
    messagingSenderId: '641358260927',
    projectId: 'mars-coffee',
    authDomain: 'mars-coffee.firebaseapp.com',
    storageBucket: 'mars-coffee.appspot.com',
    measurementId: 'G-1LJ0FC1SMP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwhEcQoLa3EWCAbBepJTszXCbP7yG_POE',
    appId: '1:641358260927:android:919c7703bfdf86728f340a',
    messagingSenderId: '641358260927',
    projectId: 'mars-coffee',
    storageBucket: 'mars-coffee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfWiq5qaU9c676nVeFoZiy5IQRLULYe0U',
    appId: '1:641358260927:ios:0f6609884561ee738f340a',
    messagingSenderId: '641358260927',
    projectId: 'mars-coffee',
    storageBucket: 'mars-coffee.appspot.com',
    androidClientId: '641358260927-99ebp5sqf359r8cav921ffoupms5eg2h.apps.googleusercontent.com',
    iosClientId: '641358260927-9bou8ju2qho252ld1inr94ne5dqmgagk.apps.googleusercontent.com',
    iosBundleId: 'com.alhadidy.mars',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfWiq5qaU9c676nVeFoZiy5IQRLULYe0U',
    appId: '1:641358260927:ios:0f6609884561ee738f340a',
    messagingSenderId: '641358260927',
    projectId: 'mars-coffee',
    storageBucket: 'mars-coffee.appspot.com',
    androidClientId: '641358260927-99ebp5sqf359r8cav921ffoupms5eg2h.apps.googleusercontent.com',
    iosClientId: '641358260927-9bou8ju2qho252ld1inr94ne5dqmgagk.apps.googleusercontent.com',
    iosBundleId: 'com.alhadidy.mars',
  );
}
