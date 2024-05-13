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
    apiKey: 'AIzaSyAyiNJjhkdcaQd7SeqqRiB6THuEiN9fCL8',
    appId: '1:335848046561:web:f7e841f8c94781fcb69ca0',
    messagingSenderId: '335848046561',
    projectId: 'swaysafeguard',
    authDomain: 'swaysafeguard.firebaseapp.com',
    storageBucket: 'swaysafeguard.appspot.com',
    measurementId: 'G-LCQJFCFPXN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUdstnohayeWuWvoTvEHMCRwbL0G2alZI',
    appId: '1:335848046561:android:327aa135a414c5b2b69ca0',
    messagingSenderId: '335848046561',
    projectId: 'swaysafeguard',
    storageBucket: 'swaysafeguard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCScOubQZDLxFyTNcMAl7zU4UtBzaRJwLE',
    appId: '1:335848046561:ios:6620538284ff0030b69ca0',
    messagingSenderId: '335848046561',
    projectId: 'swaysafeguard',
    storageBucket: 'swaysafeguard.appspot.com',
    androidClientId: '335848046561-6ph4tndiskd6ve4isvu5a7r25lsgk4o1.apps.googleusercontent.com',
    iosClientId: '335848046561-5a675av9jpm3jjhf36p89ug69fiol78g.apps.googleusercontent.com',
    iosBundleId: 'com.example.swaysafeguardapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCScOubQZDLxFyTNcMAl7zU4UtBzaRJwLE',
    appId: '1:335848046561:ios:6620538284ff0030b69ca0',
    messagingSenderId: '335848046561',
    projectId: 'swaysafeguard',
    storageBucket: 'swaysafeguard.appspot.com',
    androidClientId: '335848046561-6ph4tndiskd6ve4isvu5a7r25lsgk4o1.apps.googleusercontent.com',
    iosClientId: '335848046561-5a675av9jpm3jjhf36p89ug69fiol78g.apps.googleusercontent.com',
    iosBundleId: 'com.example.swaysafeguardapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAyiNJjhkdcaQd7SeqqRiB6THuEiN9fCL8',
    appId: '1:335848046561:web:8578caf29d23e739b69ca0',
    messagingSenderId: '335848046561',
    projectId: 'swaysafeguard',
    authDomain: 'swaysafeguard.firebaseapp.com',
    storageBucket: 'swaysafeguard.appspot.com',
    measurementId: 'G-KQ0K9DZQN2',
  );
}
