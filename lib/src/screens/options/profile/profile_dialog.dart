// ignore_for_file: must_be_immutable, avoid_print

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/dialogs/alert_dialogs.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/screens/options/profile/components/avatar_edit_dialog.dart';
import 'package:one_km/src/utils/basic_getters.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';

class ProfileDialog extends StatefulWidget {
  KmChatMessage? kmChatMessage;
  KmUser? kmUser;
  ProfileDialog({super.key, this.kmChatMessage, this.kmUser});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  bool secretPasswordVisibility = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.93),
      child: Padding(
        padding: EdgeInsets.all(100.h < 1000 ? 5.sp : 10.sp),
        child: BlocBuilder<KmUserCubit, KmUser>(builder: (context, snapshotBloc) {
          return Column(children: [
            SizedBox(
              height: 100.h < 1000 ? 5.h : 0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MiniWidgets.closeButton(context, null),
                SizedBox(
                  height: 5.w,
                )
              ],
            ),
            SizedBox(
              height: 100.h < 1000 ? 0.h : 3.h,
            ),
            kmAvatarBuild(context, snapshotBloc.userAvatar),
            SizedBox(
              height: 100.h < 1000 ? 0.h : 1.h,
            ),
            kmNameTextBuild(context, snapshotBloc.userName),
            SizedBox(
              height: 100.h < 1000 ? 0.h : 0.5.h,
            ),
            kmLevelTextBuild(context, snapshotBloc.userLevel.toString()),
            SizedBox(
              height: 100.h < 1000 ? 0.h : 0.5.h,
            ),
            kmTitleTextBuild(context, snapshotBloc.userTitle),
            experiencePointBuild(context),
            kmSpamButtonBuild(context),
            kmSecretPasswordBuild(context, snapshotBloc.userSecretPassword)
          ]);
        }),
      ),
    );
  }

  Widget kmAvatarBuild(BuildContext context, String avatarLink) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          if (widget.kmUser != null) {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AvatarEditDialog(widget.kmUser!);
                });
          }
        },
        child: CircleAvatar(
            backgroundColor: ColorConstants.themeColor,
            radius: 60.sp,
            child: Image.network(widget.kmChatMessage != null ? widget.kmChatMessage!.senderUser.userAvatar : avatarLink)),
      ),
    );
  }

  Widget kmNameTextBuild(BuildContext context, String userName) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '/${widget.kmChatMessage != null ? widget.kmChatMessage!.senderUser.userName : userName}',
        style: StyleConstants.profileNameTextStyle,
      ),
    );
  }

  Widget kmSpamButtonBuild(BuildContext context) {
    return widget.kmChatMessage != null
        ? Padding(
            padding: EdgeInsets.only(top: 100.h < 1000 ? 0.h : 10.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                  child: Container(
                      height: 5.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(
                            color: ColorConstants.juniorColor,
                            width: 4.0,
                          )),
                      child: Center(
                          child: Text(
                        '!!report!!',
                        style: StyleConstants.profileTitlePlebTextStyle,
                      ))),
                  onPressed: () {
                    AlertDialogs.spamDialog(context.read<KmUserCubit>().state, widget.kmChatMessage!, context);
                  }),
            ),
          )
        : const SizedBox();
  }

  Widget experiencePointBuild(BuildContext context) {
    return widget.kmUser != null
        ? Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Exp Points: ${widget.kmUser!.userExperiencePoints}",
                style: StyleConstants.plebTextStyle,
              ),
            ),
          )
        : const SizedBox();
  }

  Widget kmSecretPasswordBuild(BuildContext context, String secretPassword) {
    return widget.kmUser != null
        ? Padding(
            padding: EdgeInsets.only(top: 13.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Secret Password Save It!',
                          style: StyleConstants.plebTextStyle,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: 5.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  border: Border.all(
                                    color: ColorConstants.juniorColor,
                                    width: 1.0,
                                  )),
                              child: Center(
                                  child: Text(
                                secretPasswordVisibility ? secretPassword : "***************",
                                style: StyleConstants.profileSecretPasswordTextStyle,
                              ))),
                          CupertinoButton(
                              child: secretPasswordVisibility
                                  ? const Icon(
                                      CupertinoIcons.eye,
                                      color: ColorConstants.juniorColor,
                                    )
                                  : const Icon(
                                      CupertinoIcons.eye_slash,
                                      color: ColorConstants.juniorColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  secretPasswordVisibility = !secretPasswordVisibility;
                                });
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'click here for copy! ',
                          style: StyleConstants.plebTextStyle,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(secretPassword).then((value) => print('copied'));
                  }),
            ),
          )
        : const SizedBox();
  }

  Widget kmTitleTextBuild(BuildContext context, String newUserTitle) {
    return Text((widget.kmChatMessage != null ? widget.kmChatMessage!.senderUser.userTitle : newUserTitle),
        style: BasicGetters.profileTitleTextStyleGetter(widget.kmChatMessage != null ? widget.kmChatMessage!.senderUser.userTitle : newUserTitle));
  }

  Widget kmLevelTextBuild(BuildContext context, String userLevel) {
    return Text(
      'lv.${widget.kmChatMessage != null ? widget.kmChatMessage!.senderUser.userLevel.toString() : userLevel}',
      style: StyleConstants.profileLevelTextStyle,
    );
  }
}
