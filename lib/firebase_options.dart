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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAeDx1LENME6KDTcwRSXWQei_36FechARg',
    appId: '1:831961227421:web:86e87e02adbcc1496d7474',
    messagingSenderId: '831961227421',
    projectId: 'fir-example-6ce04',
    authDomain: 'fir-example-6ce04.firebaseapp.com',
    storageBucket: 'fir-example-6ce04.appspot.com',
    measurementId: 'G-CV7JGRKQ8S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjOspHNjQg11d0y0odWXzIRPr2xHzt6dw',
    appId: '1:831961227421:android:f145a1f64c0678876d7474',
    messagingSenderId: '831961227421',
    projectId: 'fir-example-6ce04',
    storageBucket: 'fir-example-6ce04.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARjKl43603qvnmQ2UK0iaW26Khimuwr1k',
    appId: '1:831961227421:ios:0bca5fc0bf901d696d7474',
    messagingSenderId: '831961227421',
    projectId: 'fir-example-6ce04',
    storageBucket: 'fir-example-6ce04.appspot.com',
    iosClientId: '831961227421-853aahjjdrsjr3s5qf72pd9oan27amue.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseExample',
  );
}
