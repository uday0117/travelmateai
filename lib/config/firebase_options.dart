import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for TravelMate AI yet.');
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      TargetPlatform.macOS =>
        throw UnsupportedError('macOS is not supported yet.'),
      TargetPlatform.windows =>
        throw UnsupportedError('Windows is not supported yet.'),
      TargetPlatform.linux =>
        throw UnsupportedError('Linux is not supported yet.'),
      _ => throw UnsupportedError('Unsupported platform.'),
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXoeRJXbJb8stwdjFPCLwHLDlmwbCawTc',
    appId: '1:872642314665:android:f15804234c0f672867c4b8',
    messagingSenderId: '872642314665',
    projectId: 'travelmateai-f9b33',
    storageBucket: 'travelmateai-f9b33.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwRs81z0rP-dFuCSn5HL8sFD-Gm0uFvxA',
    appId: '1:872642314665:ios:4a7463f413b0c4b967c4b8',
    messagingSenderId: '872642314665',
    projectId: 'travelmateai-f9b33',
    storageBucket: 'travelmateai-f9b33.firebasestorage.app',
    iosClientId:
        '872642314665-gtc54adk383eaql8aa3t12db0400tggv.apps.googleusercontent.com',
    iosBundleId: 'com.uksolutions.travelmateai.travelmateai',
  );
}
