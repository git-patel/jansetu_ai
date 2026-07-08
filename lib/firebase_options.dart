import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase configuration options for JanSetu AI Enterprise Edition.
/// Generated/configured per Prompt 15 to support multi-platform deployment
/// across Android, iOS, and Web platforms.
class DefaultFirebaseOptions {
  static const String _projectId = 'jansetu-ai-prod';
  static const String _storageBucket = 'jansetu-ai-prod.appspot.com';

  static Map<String, dynamic> get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const Map<String, dynamic> web = {
    'apiKey': 'AIzaSyA_Web_JanSetu_Demo_Key_9876543210',
    'appId': '1:1029384756:web:abcdef1234567890',
    'messagingSenderId': '1029384756',
    'projectId': _projectId,
    'authDomain': '$_projectId.firebaseapp.com',
    'storageBucket': _storageBucket,
    'measurementId': 'G-JANSETUAI01',
  };

  static const Map<String, dynamic> android = {
    'apiKey': 'AIzaSyA_Android_JanSetu_Key_1234567890',
    'appId': '1:1029384756:android:1234567890abcdef',
    'messagingSenderId': '1029384756',
    'projectId': _projectId,
    'storageBucket': _storageBucket,
  };

  static const Map<String, dynamic> ios = {
    'apiKey': 'AIzaSyA_iOS_JanSetu_Key_0987654321',
    'appId': '1:1029384756:ios:0987654321fedcba',
    'messagingSenderId': '1029384756',
    'projectId': _projectId,
    'storageBucket': _storageBucket,
    'iosBundleId': 'in.gov.jansetu.ai.app',
  };
}
