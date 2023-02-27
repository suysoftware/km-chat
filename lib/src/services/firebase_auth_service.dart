// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_km/src/models/km_user.dart';
import 'firestore_operations.dart';

class FirebaseAuthService {
  // ignore: body_might_complete_normally_nullable
  static Future<User?> loginFirebase(BuildContext? context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously().then((kullanici) {
        //_isSigningIn = true;
      });
      User? user = FirebaseAuth.instance.currentUser;

      return user;
    } catch (e) {
      // ignore: avoid_print
      if (context != null) {}
    }
  }

  // ignore: body_might_complete_normally_nullable
  static Future<KmUser?> loggedCheck() async {
    User? user = FirebaseAuth.instance.currentUser;
    var kmUser;

  

      
    // Platform messages may fail, so we use a try/catch PlatformException.
  

    if (user != null) {

  
    kmUser = await FirestoreOperations.getKmUser(user.uid);
    
      if (kmUser == null || kmUser.userHasBanned == true) {
        logoutFirebase();
      } else {
           FirestoreOperations.kmUserCoordinateUpdate(user.uid);
               FirestoreOperations.tokenUpdateRequest(kmUser);
           FirestoreOperations.activityControl(kmUser, 'online');

          return kmUser;
      }
    }
     


  }
  
  static Future<void> logoutFirebase() async {
    try {
      if (!kIsWeb) {
        //await firebaseAuth.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<dynamic> secureTokenGetter() async {
    User? user = FirebaseAuth.instance.currentUser;
    var token = await user!.getIdToken();
    return token;
  }
}
