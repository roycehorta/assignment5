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
    apiKey: 'AIzaSyC1dzNxW06H4NLxkAeKqzS6XDarKFgjvYg',
    appId: '1:930180654648:web:593b26a02e07701dcea8cd',
    messagingSenderId: '930180654648',
    projectId: 'favplace-hortaleza',
    authDomain: 'favplace-hortaleza.firebaseapp.com',
    storageBucket: 'favplace-hortaleza.appspot.com',
    measurementId: 'G-HLDQCRY1C0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWxXvGtyM96PVI7Yo3ZfMDzPNfk_iv6d0',
    appId: '1:930180654648:android:d1b66f980304f2d6cea8cd',
    messagingSenderId: '930180654648',
    projectId: 'favplace-hortaleza',
    storageBucket: 'favplace-hortaleza.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRTUTlh7cirLW5vdEnaycaOiBZbq7YI_0',
    appId: '1:930180654648:ios:0210f5d699eefb3dcea8cd',
    messagingSenderId: '930180654648',
    projectId: 'favplace-hortaleza',
    storageBucket: 'favplace-hortaleza.appspot.com',
    iosBundleId: 'com.example.pinLocation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRTUTlh7cirLW5vdEnaycaOiBZbq7YI_0',
    appId: '1:930180654648:ios:0210f5d699eefb3dcea8cd',
    messagingSenderId: '930180654648',
    projectId: 'favplace-hortaleza',
    storageBucket: 'favplace-hortaleza.appspot.com',
    iosBundleId: 'com.example.pinLocation',
  );
}
