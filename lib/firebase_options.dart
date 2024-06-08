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
    apiKey: 'AIzaSyBEEo9c0vbDguux_ClSoiPoeRTSOCN_-j4',
    appId: '1:902293505425:web:ddf77a294d7e10de7e4630',
    messagingSenderId: '902293505425',
    projectId: 'greenhousetechnology-8014f',
    authDomain: 'greenhousetechnology-8014f.firebaseapp.com',
    storageBucket: 'greenhousetechnology-8014f.appspot.com',
    measurementId: 'G-442QNXH16R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBkBtX3mjXJg9-Q0sAj9UnsiSzWi7IKGo',
    appId: '1:902293505425:android:9c8dff3d9c898e227e4630',
    messagingSenderId: '902293505425',
    projectId: 'greenhousetechnology-8014f',
    storageBucket: 'greenhousetechnology-8014f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5WZ-Rp-UPyfHRigwHD5VhRjrSixRhvBM',
    appId: '1:902293505425:ios:08ea6ccd9a3692d47e4630',
    messagingSenderId: '902293505425',
    projectId: 'greenhousetechnology-8014f',
    storageBucket: 'greenhousetechnology-8014f.appspot.com',
    iosBundleId: 'com.ghm.ghm',
  );
}
