import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/main.dart';
import 'package:one_km/src/models/km_chat_reference_model.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:one_km/src/utils/basic_getters.dart';

import '../constants/enums.dart';
import '../models/km_chat_message.dart';



class KmChatReferenceCubit extends Cubit<KmChatReferenceModel> {
  
  KmChatReferenceCubit()
      : super(KmChatReferenceModel(
            chatSectionEnum: ChatSectionEnum.public,
            chatReference: BasicGetters.chatStreamReferenceGetter(
                    UserCoordinates(latitude: 0, longitude: 0, isoCountryCode: "", administrativeArea: "", locality: "", subLocality: "", postalCode: ""),
                    KmSystemSettings.withInfo(chatDistance: "world", avatarMap: [], messagesAmount: 100, eventIsActive: false, eventAssets: "", allUserNames: []))
                .orderBy('user_message_time', descending: false)
                .limitToLast(50)
                .snapshots(),
            chatTargetNo: "",
            chatTargetName: ""));

  void goPublic(UserCoordinates userCoordinates, KmSystemSettings kmSystemSettings) {
    var newReferenceModel = KmChatReferenceModel(
        chatSectionEnum: ChatSectionEnum.public,
        chatReference: BasicGetters.chatStreamReferenceGetter(userCoordinates, kmSystemSettings)
            .orderBy('user_message_time', descending: false)
            .limitToLast(kmSystemSettings.messagesAmount)
            .snapshots(),
        chatTargetNo: "",
        chatTargetName: BasicGetters.chatTargetNameSwitch(userCoordinates, kmSystemSettings));

    emit(newReferenceModel);
  }

  void goPrivate(String myUid,String targetUid, String targetName) {
    var newReferenceModel = KmChatReferenceModel(
        chatSectionEnum: ChatSectionEnum.private,
        chatReference: FirebaseFirestore.instance
            .collection("private_chat")
            .doc(myUid)
            .collection('chat_pool')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson())
            .orderBy('user_message_time', descending: false)
            .snapshots(),
        chatTargetNo: targetUid,
        chatTargetName: targetName);
   
    emit(newReferenceModel);
  }
    void refresh(String userUid, String targetName) {
   

    emit(state);
  }

  void goClub(String clubRef, String clubName) {
    var newReferenceModel = KmChatReferenceModel(
        chatSectionEnum: ChatSectionEnum.club,
        chatReference: FirebaseFirestore.instance
            .collection("clubs")
            .doc(clubRef)
            .collection('chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson())
            .orderBy('user_message_time', descending: false)
            .snapshots(),
        chatTargetNo: clubRef,
        chatTargetName: clubName);
    emit(newReferenceModel);
  }

  void goBot(String userUid) {
    var newReferenceModel = KmChatReferenceModel(
        chatSectionEnum: ChatSectionEnum.bot,
        chatReference: FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .collection('bot_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson())
            .orderBy('user_message_time', descending: false).limitToLast(20)
            .snapshots(),
        chatTargetNo: userUid,
        chatTargetName: "Bot");
    emit(newReferenceModel);
  }
}
