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
    apiKey: 'AIzaSyCIPFDLrbsjcmIpKgCKjfObkCEQYILBSEA',
    appId: '1:1018231486349:web:5d13a12350127bb119efc4',
    messagingSenderId: '1018231486349',
    projectId: 'todo-app-6ff79',
    authDomain: 'todo-app-6ff79.firebaseapp.com',
    storageBucket: 'todo-app-6ff79.appspot.com',
    measurementId: 'G-W79KLHKG0J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC10iEZntWm2WrWmfMIE8md4qvUIm4eE2c',
    appId: '1:1018231486349:android:9b37814b9e8b605419efc4',
    messagingSenderId: '1018231486349',
    projectId: 'todo-app-6ff79',
    storageBucket: 'todo-app-6ff79.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAap5OW3KDd9sfmPUzka7OhFsId1NaTOBU',
    appId: '1:1018231486349:ios:5f14812031153bf719efc4',
    messagingSenderId: '1018231486349',
    projectId: 'todo-app-6ff79',
    storageBucket: 'todo-app-6ff79.appspot.com',
    iosClientId: '1018231486349-vn94outsdo80dgne7fmuov6nvoq4bcjv.apps.googleusercontent.com',
    iosBundleId: 'com.alif.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAap5OW3KDd9sfmPUzka7OhFsId1NaTOBU',
    appId: '1:1018231486349:ios:5f14812031153bf719efc4',
    messagingSenderId: '1018231486349',
    projectId: 'todo-app-6ff79',
    storageBucket: 'todo-app-6ff79.appspot.com',
    iosClientId: '1018231486349-vn94outsdo80dgne7fmuov6nvoq4bcjv.apps.googleusercontent.com',
    iosBundleId: 'com.alif.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIPFDLrbsjcmIpKgCKjfObkCEQYILBSEA',
    appId: '1:1018231486349:web:2f18c0a0def1575d19efc4',
    messagingSenderId: '1018231486349',
    projectId: 'todo-app-6ff79',
    authDomain: 'todo-app-6ff79.firebaseapp.com',
    storageBucket: 'todo-app-6ff79.appspot.com',
    measurementId: 'G-4N8C4EWR46',
  );

}