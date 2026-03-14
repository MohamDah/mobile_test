// Example command:
//   dart pub global activate flutterfire_cli
//   flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAf4X6Xmr8wqWas8WWNQG2F4vefpWW8eeg',
    appId: '1:425684716113:web:5f7ba365813537c4f50670',
    messagingSenderId: '425684716113',
    projectId: 'fitlife-22bad',
    authDomain: 'fitlife-22bad.firebaseapp.com',
    storageBucket: 'fitlife-22bad.firebasestorage.app',
  );

  // Replace all values below after running `flutterfire configure`.

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoucHRGG-Fm9HMt0xZpvCcDZxUDud9iDA',
    appId: '1:425684716113:android:2300fd3440ce0770f50670',
    messagingSenderId: '425684716113',
    projectId: 'fitlife-22bad',
    storageBucket: 'fitlife-22bad.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0jZtAoK6c5KdZ1I_Am8nd25K93sBRipw',
    appId: '1:425684716113:ios:8e83787f502244f2f50670',
    messagingSenderId: '425684716113',
    projectId: 'fitlife-22bad',
    storageBucket: 'fitlife-22bad.firebasestorage.app',
    androidClientId: '425684716113-di2376b703h2qiv5ejn0s3l3haktmiuk.apps.googleusercontent.com',
    iosClientId: '425684716113-olbjro0qbsfepvhas0pmibd401lmvuc1.apps.googleusercontent.com',
    iosBundleId: 'com.example.fitlife',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0jZtAoK6c5KdZ1I_Am8nd25K93sBRipw',
    appId: '1:425684716113:ios:8e83787f502244f2f50670',
    messagingSenderId: '425684716113',
    projectId: 'fitlife-22bad',
    storageBucket: 'fitlife-22bad.firebasestorage.app',
    androidClientId: '425684716113-di2376b703h2qiv5ejn0s3l3haktmiuk.apps.googleusercontent.com',
    iosClientId: '425684716113-olbjro0qbsfepvhas0pmibd401lmvuc1.apps.googleusercontent.com',
    iosBundleId: 'com.example.fitlife',
  );

}