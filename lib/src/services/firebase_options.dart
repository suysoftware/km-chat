import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseOptionsClass {
  static  FirebaseOptions firebaseConfig = FirebaseOptions(
      apiKey: dotenv.env['API_KEY'].toString(),
      authDomain: dotenv.env['AUTH_DOMAIN'].toString(),
      projectId: dotenv.env['PROJECT_ID'].toString(),
      storageBucket: dotenv.env['STORAGE_BUCKET'].toString(),
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'].toString(),
      appId: dotenv.env['APP_ID'].toString(),
      measurementId: "");

      
}
