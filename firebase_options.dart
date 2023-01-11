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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtSb_pu-XK-nZQ95tohehKGil8XRqW7_k',
    appId: '1:607554822192:android:2d9299aae0773d218c4df5',
    messagingSenderId: '607554822192',
    projectId: 'work-quest-app',
    databaseURL: 'https://work-quest-app-default-rtdb.firebaseio.com',
    storageBucket: 'work-quest-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCy-wMRiCG_JKohMc7XORicNjActTf9SqM',
    appId: '1:607554822192:ios:b5ab66ba76d323ec8c4df5',
    messagingSenderId: '607554822192',
    projectId: 'work-quest-app',
    databaseURL: 'https://work-quest-app-default-rtdb.firebaseio.com',
    storageBucket: 'work-quest-app.appspot.com',
    androidClientId:
        '607554822192-2s128l3vvb2qfaf2ca1se05d2fftchhe.apps.googleusercontent.com',
    iosClientId:
        '607554822192-vmkvp6s1otk7kj3eilmsc154kjrdqu28.apps.googleusercontent.com',
    iosBundleId: 'com.company.workquestapp',
  );
}
