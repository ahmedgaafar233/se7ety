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
    apiKey: 'AIzaSyCferhblZ_mIRDXnFBSBwtWABRoYKi2SLo',
    appId: '1:534924194829:web:f27b7cd2fb29d6029d1144',
    messagingSenderId: '534924194829',
    projectId: 'se7tyapp',
    authDomain: 'se7tyapp.firebaseapp.com',
    storageBucket: 'se7tyapp.firebasestorage.app',
    measurementId: 'G-TZ12WWDNXP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCferhblZ_mIRDXnFBSBwtWABRoYKi2SLo',
    appId: '1:534924194829:android:0fd6b9f32f28bafe9d1144',
    messagingSenderId: '534924194829',
    projectId: 'se7tyapp',
    storageBucket: 'se7tyapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCferhblZ_mIRDXnFBSBwtWABRoYKi2SLo',
    appId: '1:534924194829:ios:9f8d551234567890123456', // Placeholder if not found
    messagingSenderId: '534924194829',
    projectId: 'se7tyapp',
    storageBucket: 'se7tyapp.firebasestorage.app',
    iosBundleId: 'com.example.se7ty',
  );
}
