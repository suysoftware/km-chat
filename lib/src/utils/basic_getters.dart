import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:vibration/vibration.dart';

import '../screens/options/profile/profile_dialog.dart';

class BasicGetters {
  static CollectionReference<KmChatMessage> chatStreamReferenceGetter(UserCoordinates userCoordinates, KmSystemSettings kmSystemSettings) {
    var collectionName = "public_chat";
    switch (kmSystemSettings.chatDistance) {
      case 'world':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc('WORLD')
            .collection('world_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'country':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('country_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'city':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('city_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'district':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('district_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
      case 'postal':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('postals')
            .doc(userCoordinates.postalCode)
            .collection('postal_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
      default:
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('postals')
            .doc(userCoordinates.postalCode)
            .collection('postal_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
    }
  }

  static TextStyle chatTextStyleGetter(KmChatMessage kmChatMessage, String myUid) {
    switch (kmChatMessage.userTitle) {
      case "system":
        return StyleConstants.systemTextStyle;
      case "admin":
        return StyleConstants.adminTextStyle;
      case "master":
        return StyleConstants.masterTextStyle;
      case "pleb":
        return StyleConstants.plebTextStyle;
      default:
        return StyleConstants.plebTextStyle;
    }
  }

  static TextStyle chatNameStyleGetter(
    KmChatMessage kmChatMessage,
  ) {
    switch (kmChatMessage.userTitle) {
      case "system":
        return StyleConstants.systemNameTextStyle;
      case "admin":
        return StyleConstants.adminNameTextStyle;
      case "master":
        return StyleConstants.masterNameTextStyle;
      case "pleb":
        return StyleConstants.plebNameTextStyle;
      default:
        return StyleConstants.plebNameTextStyle;
    }
  }

  static TextStyle profileTitleTextStyleGetter(
    String title,
  ) {
    switch (title) {
      case "admin":
        return StyleConstants.profileTitleAdminTextStyle;
      case "master":
        return StyleConstants.profileTitleMasterTextStyle;
      case "pleb":
        return StyleConstants.profileTitlePlebTextStyle;
      default:
        return StyleConstants.profileTitlePlebTextStyle;
    }
  }

  static Future<List<KmChatMessage>> chatFilteredMessagesGetter(dynamic kmChatList, KmUser myUserModel) async {
    var kmChatFilteredList = <KmChatMessage>[];
    var dateTime = DateTime.now().millisecondsSinceEpoch;

    for (var chatMessage in kmChatList.docs) {
      if (!chatMessage.data().userBlockedList.contains(myUserModel.userUid) && myUserModel.userBlockedMap[chatMessage.data().userUid] == null) {
      /*  if (chatMessage.data().messageIsPrivate &&
            chatMessage.data().privateMessageTarget == myUserModel.userUid &&
            dateTime - chatMessage.data().userMessageTime.millisecondsSinceEpoch < 2000) {
          Vibration.vibrate(duration: 40);
        }*/

        if (chatMessage.data().userTitle == "system" && dateTime - chatMessage.data().userMessageTime.millisecondsSinceEpoch > 30000) {
          // ignore: prefer_is_empty
          if (kmChatFilteredList.length < 1) {
            kmChatFilteredList.add(chatMessage.data());
          }
        } else {
          kmChatFilteredList.add(chatMessage.data());
        }
      }
    }

    kmChatFilteredList.sort((b, a) => a.userMessageTime.compareTo(b.userMessageTime));

    return kmChatFilteredList;
  }

  static Future<List<dynamic>> blockedMapToList(dynamic blockedMap) async {
    final blockedList = blockedMap.keys.toList();

    return blockedList;
  }

  static Widget textWidgetGetter(KmChatMessage kmChatMessage, String myUid, BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              HapticFeedback.vibrate();
              if (kmChatMessage.userTitle != "system" && kmChatMessage.userTitle != "admin" && kmChatMessage.userUid != myUid) {
                showCupertinoDialog(barrierDismissible: true, context: context, builder: (context) => ProfileDialog(kmChatMessage: kmChatMessage));
              }
            },
          text: "${kmChatMessage.userName}: ",
          style: chatNameStyleGetter(kmChatMessage)),
      TextSpan(text: kmChatMessage.userMessage, style: chatTextStyleGetter(kmChatMessage, myUid)),
    ]));
  }
}
