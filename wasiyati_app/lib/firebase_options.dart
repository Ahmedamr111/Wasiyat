// ─────────────────────────────────────────────────────────────────────────────
// firebase_options.dart — Generated from google-services.json
// Project: wasiyati-36960
// ─────────────────────────────────────────────────────────────────────────────

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ─── Android ──────────────────────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeWwWkCbY4X405v6pQdergDC7Et0TmgwI',
    appId: '1:284120961434:android:0344c7d395e23a8c4bea23',
    messagingSenderId: '284120961434',
    projectId: 'wasiyati-36960',
    storageBucket: 'wasiyati-36960.firebasestorage.app',
  );

  // ─── iOS ──────────────────────────────────────────────────────────────────
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeWwWkCbY4X405v6pQdergDC7Et0TmgwI',
    appId: '1:284120961434:android:0344c7d395e23a8c4bea23',
    messagingSenderId: '284120961434',
    projectId: 'wasiyati-36960',
    storageBucket: 'wasiyati-36960.firebasestorage.app',
    iosBundleId: 'com.wasiyati.wasiyati',
  );

  // ─── Web ──────────────────────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCeWwWkCbY4X405v6pQdergDC7Et0TmgwI',
    appId: '1:284120961434:android:0344c7d395e23a8c4bea23',
    messagingSenderId: '284120961434',
    projectId: 'wasiyati-36960',
    storageBucket: 'wasiyati-36960.firebasestorage.app',
    authDomain: 'wasiyati-36960.firebaseapp.com',
  );

  // ─── macOS ────────────────────────────────────────────────────────────────
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeWwWkCbY4X405v6pQdergDC7Et0TmgwI',
    appId: '1:284120961434:android:0344c7d395e23a8c4bea23',
    messagingSenderId: '284120961434',
    projectId: 'wasiyati-36960',
    storageBucket: 'wasiyati-36960.firebasestorage.app',
    iosBundleId: 'com.wasiyati.wasiyati',
  );
}


