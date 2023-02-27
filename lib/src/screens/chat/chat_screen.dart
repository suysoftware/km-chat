// ignore_for_file: unused_field, duplicate_ignore, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/screens/options/options_dialog.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/utils/basic_getters.dart';
import 'package:one_km/src/widgets/app_logo.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:upgrader/upgrader.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ignore: unused_field
  String _connectionStatus = 'Unknown';
  bool _connectionBool = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool publicNotification = false;
  var chatRef;
  var messageController = TextEditingController();
  var privateMessageController = TextEditingController();
  var privateMessageTargetUid = "";
  var privateMessageTargetName = "";
  FocusNode myFocusNode = FocusNode();

  void _replyOperation(KmChatMessage kmChatMessage, KmUser kmUser) {
    if (kmChatMessage.userTitle == 'system' ||
        kmChatMessage.userUid == kmUser.userUid) {
      HapticFeedback.vibrate();
      messageController.clear();
      privateMessageController.clear();
      privateMessageTargetUid = "";
      privateMessageTargetName = "";
    } else {
      if (messageController.text.isNotEmpty && privateMessageTargetUid == "") {
        myFocusNode.requestFocus();
        messageController.text =
            "${kmChatMessage.userName} : ${messageController.text}";
        privateMessageTargetUid = kmChatMessage.userUid;
        privateMessageTargetName = kmChatMessage.userName;

        messageController.selection = TextSelection(
            baseOffset: messageController.text.length,
            extentOffset: messageController.text.length);
      } else {
        myFocusNode.requestFocus();
        messageController.clear();
        messageController.text = "${kmChatMessage.userName} : ";
        privateMessageTargetUid = kmChatMessage.userUid;
        privateMessageTargetName = kmChatMessage.userName;
        messageController.selection = TextSelection(
            baseOffset: messageController.text.length,
            extentOffset: messageController.text.length);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    chatRef = BasicGetters.chatStreamReferenceGetter(
        context.read<KmUserCubit>().state.userCoordinates,
        context.read<KmSystemSettingsCubit>().state);

    FirestoreOperations.joinRoomRequest(context.read<KmUserCubit>().state,
        context.read<KmSystemSettingsCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeColor,
        child: _connectionBool == true
            ? UpgradeAlert(
                upgrader: Upgrader(
                    shouldPopScope: () => true,
                    durationUntilAlertAgain: const Duration(hours: 1),
                    dialogStyle: UpgradeDialogStyle.cupertino,
                    canDismissDialog: true),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Align(
                        alignment: Alignment.topCenter, child: kmButtonBuild()),
                    SizedBox(
                      height: 1.h,
                    ),
                    chatStreamBuilder(context.read<KmUserCubit>().state),
                    textFieldArea()
                  ],
                ),
              )
            : MiniWidgets.lostConnectionWidgetBuild());
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        //  setState(() => _connectionStatus = result.toString());
        if (_connectionBool != true) {
          setState(() {
            _connectionBool = true;
          });
        }

        break;
      case ConnectivityResult.none:
        if (_connectionBool != false) {
          setState(() {
            _connectionBool = false;
          });
        }

        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');

        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Widget kmButtonBuild() {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return OptionsDialog(
                kmUser: context.read<KmUserCubit>().state,
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: appLogo(1, context.read<KmSystemSettingsCubit>().state,
            context.read<KmUserCubit>().state.userCoordinates),
      ),
    );
  }

  Widget textFieldArea() {
    return SizedBox(
      height: 13.h,
      width: 100.w,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.designGreen, width: 3),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(50.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: CupertinoTextField(
                    autofocus: false,
                    focusNode: myFocusNode,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      if (privateMessageTargetUid != "") {
                        if (value.length <
                            privateMessageTargetName.length + 3) {
                          messageController.clear();
                          privateMessageController.clear();
                          privateMessageTargetUid = "";
                          privateMessageTargetName = "";
                        }
                      }
                    },
                    enableInteractiveSelection: true,
                    maxLines: 3,
                    maxLength: 99,
                    showCursor: true,
                    padding: EdgeInsets.fromLTRB(2.w, 1.w, 1.w, 1.w),
                    cursorColor: CupertinoColors.activeGreen,
                    cursorHeight: 3.h,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            color: ColorConstants.designGreen, width: 1),
                      ),
                    ),
                    controller: messageController,
                  ),
                ),
                Expanded(flex: 1, child: whiteRabbitButtonBuild())
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chatStreamBuilder(KmUser kmUser) {
    return Flexible(
        child: StreamBuilder<QuerySnapshot<KmChatMessage>>(
            stream: chatRef
                .orderBy('user_message_time', descending: false)
                .limitToLast(
                    context.read<KmSystemSettingsCubit>().state.messagesAmount)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!snapshot.hasData) {
                  return MiniWidgets.circularProgress();
                }

                var dataCome = snapshot.requireData;

                return BlocBuilder<KmUserCubit, KmUser>(
                    builder: (context, snapshotBloc) {
                  return FutureBuilder(
                      future: BasicGetters.chatFilteredMessagesGetter(
                          dataCome, snapshotBloc),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          var snapData = snap.data!;

                          if (snapData.any(
                              (element) => element.userTitle != "system")) {
            
                            publicNotification =
                                DateTime.now().millisecondsSinceEpoch -
                                        snapData
                                            .firstWhere((element) =>
                                                element.userTitle != 'system')
                                            .userMessageTime
                                            .millisecondsSinceEpoch >1800000;
                        
                     
                          }

                          return ListView.builder(
                              reverse: true,
                              dragStartBehavior: DragStartBehavior.values.last,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.values.last,
                              itemCount: snapData.length,
                              itemBuilder: (context, indeks) {
                                return snapData.isNotEmpty
                                    ? chatItemSlide(snapData[indeks], kmUser)
                                    : const SizedBox();
                              });
                        } else {
                          return MiniWidgets.circularProgress();
                        }
                      });
                });
              } else {
                return MiniWidgets.circularProgress();
              }
            }));
  }

  Widget whiteRabbitButtonBuild() {
    return CupertinoButton(
      child: SizedBox(
          width: 8.w,
          height: 8.w,
          child: Image.asset(
            "assets/images/white_rabbit.png",
            color: ColorConstants.designGreen,
          )),
      onPressed: () async {
        var response = await FirestoreOperations.sendMessageToChat(
            messageController.text,
            context.read<KmUserCubit>().state,
            context.read<KmSystemSettingsCubit>().state,
            privateMessageTargetUid,
            privateMessageTargetUid != ""
                ? messageController.text
                    .substring(privateMessageTargetName.length + 3)
                : messageController.text,
            publicNotification);

        if (privateMessageTargetUid != "") {
          messageController.text = messageController.text
              .substring(0, privateMessageTargetName.length + 3);

          messageController.selection = TextSelection(
              baseOffset: messageController.text.length,
              extentOffset: messageController.text.length);
        } else {
          messageController.clear();
          privateMessageController.clear();
          privateMessageTargetUid = "";
          privateMessageTargetName = "";
        }
      },
    );
  }

  Widget chatItemSlide(KmChatMessage kmChatMessage, KmUser kmUser) {
    return SwipeableTile.swipeToTriggerCard(
      color: Colors.transparent,
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.35),
        // blurRadius: 4,
        offset: const Offset(2, 2),
      ),
      horizontalPadding: 0,
      verticalPadding: 0,
      direction: SwipeDirection.startToEnd,
      swipeThreshold: 0.5,
      onSwiped: (direction) {
        _replyOperation(kmChatMessage, kmUser);

        // Here call setState to update state
      },
      backgroundBuilder: (context, direction, progress) {
        if (kmChatMessage.userTitle != 'system' &&
            kmChatMessage.userUid != kmUser.userUid) {
          return AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return AnimatedContainer(
                onEnd: () {},
                duration: const Duration(milliseconds: 400),
                color: progress.isDismissed
                    ? Colors.transparent
                    : (progress.value > 0.5
                        ? ColorConstants.juniorColor
                        : ColorConstants.systemColor),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
      key: UniqueKey(),
      child: Padding(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.h),
          child: BasicGetters.textWidgetGetter(
              kmChatMessage, kmUser.userUid, context)),
    );
  }
}
