import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_km/src/bloc/km_chat_reference.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/models/km_chat_section.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:sizer/sizer.dart';

import '../../../models/km_chat_message.dart';
import '../../../models/km_chat_reference_model.dart';
import '../../../models/km_user.dart';
import '../../../utils/basic_getters.dart';
import '../../../widgets/mini_widget.dart';

class ChatTargetSection extends StatelessWidget {
  const ChatTargetSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<KmChatMessage>>(
        stream: FirebaseFirestore.instance
            .collection("private_chat")
            .doc(context.read<KmUserCubit>().state.userUid)
            .collection('chat_pool')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson())
            .orderBy('user_message_time', descending: false)
            .snapshots(),
        builder: (context, chatPoolSnapshot) {
          if (chatPoolSnapshot.hasData) {
            if (!chatPoolSnapshot.hasData) {
              return MiniWidgets.circularProgress();
            }
            var chatPoolData = chatPoolSnapshot.requireData;
            var convertedData = BasicGetters.chatMessageQuerySnapshotToList(chatPoolData);

            return BlocBuilder<KmUserCubit, KmUser>(builder: (context, snapshotBloc) {
              return FutureBuilder(
                  future: BasicGetters.kmChatSectionListCreator(convertedData, snapshotBloc, context.read<KmSystemSettingsCubit>().state),
                  builder: (context, kmSectionListSnapshot) {
                    if (kmSectionListSnapshot.hasData) {
                      var kmSectionList = kmSectionListSnapshot.data!;
                      return BlocBuilder<KmChatReferenceCubit, KmChatReferenceModel>(builder: (context, refBloc) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(2.w, 0.0, 0.0, 0.0),
                          child: SizedBox(
                            height: 40,
                            width: 100.w,
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisExtent: 130,
                                mainAxisSpacing: 2.w,
                              ),
                              padding: EdgeInsets.zero,
                              itemCount: kmSectionList.length,
                              itemBuilder: (context, indeks) {
                                return GestureDetector(
                                  onTap: () {
                                    switch (kmSectionList[indeks].chatSectionEnum) {
                                      case ChatSectionEnum.public:
                                        context.read<KmChatReferenceCubit>().goPublic(snapshotBloc.userCoordinates, context.read<KmSystemSettingsCubit>().state);
                                        break;
                                      case ChatSectionEnum.private:
                                        context.read<KmChatReferenceCubit>().goPrivate(kmSectionList[indeks].targetUid, kmSectionList[indeks].targetName);
                                        break;
                                      case ChatSectionEnum.club:
                                        context.read<KmChatReferenceCubit>().goClub(kmSectionList[indeks].targetUid, "Club");
                                        break;
                                      case ChatSectionEnum.bot:
                                        context.read<KmChatReferenceCubit>().goBot(snapshotBloc.userUid);
                                        break;
                                      default:
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 220,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: sectionColorGetter(
                                            refBloc.chatSectionEnum.name, kmSectionList[indeks].chatSectionEnum.name, refBloc.chatTargetNo, kmSectionList[indeks].targetUid),
                                        border: Border.all(color: ColorConstants.juniorColor, width: 2)),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          BasicGetters.sectionBarIconGetter(kmSectionList[indeks].chatSectionEnum.name),
                                          width: 18,
                                          height: 18,
                                          color: ColorConstants.designGreen,
                                        ),
                                        SizedBox(width: 10),
                                        Text(kmSectionList[indeks].targetName.length > 11 ? kmSectionList[indeks].targetName.substring(0, 10) : kmSectionList[indeks].targetName,
                                            style: TextStyle(color: ColorConstants.juniorColor, fontSize: 17)),
                                      ],
                                    )),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      });
                    } else {
                      return MiniWidgets.circularProgress();
                    }
                  });
            });
          } else {
            return MiniWidgets.circularProgress();
          }
        });
  }

  sectionColorGetter(String name, String name2, String chatTargetNo, String targetUid) {
    if (name == name2 && (name == "public" || name == "bot") || chatTargetNo == targetUid) {
      return ColorConstants.designGreen.withOpacity(0.2);
    } else {
      return ColorConstants.transparentColor;
    }
  }
}
