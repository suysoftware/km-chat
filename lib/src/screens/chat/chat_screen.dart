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
import 'package:one_km/src/screens/chat/components/chat_item.dart';
import 'package:one_km/src/screens/chat/components/chat_target_section.dart';
import 'package:one_km/src/screens/chat/components/chat_text_field.dart';
import 'package:one_km/src/screens/chat/components/km_button.dart';
import 'package:one_km/src/screens/chat/components/white_rabbit_button.dart';
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
  FocusNode textFieldFocusNode = FocusNode();

  chatTextFieldOnChangeOperation(String value) {
    setState(() {
      if (privateMessageTargetUid != "") {
        if (value.length < privateMessageTargetName.length + 3) {
          messageController.clear();
          privateMessageController.clear();
          privateMessageTargetUid = "";
          privateMessageTargetName = "";
        }
      }
    });
  }

  Future<void> whiteRabbitButtonOperation() async {
    var textFieldData = messageController.text;
    messageController.clear();
    privateMessageController.clear();
    if (privateMessageTargetUid != "") {
      messageController.text = textFieldData.substring(0, privateMessageTargetName.length + 3);

      messageController.selection = TextSelection(baseOffset: messageController.text.length, extentOffset: messageController.text.length);
    } else {
      privateMessageTargetUid = "";
      privateMessageTargetName = "";
    }
    await FirestoreOperations.sendMessageToPublic(textFieldData, context.read<KmUserCubit>().state, publicNotification, context.read<KmSystemSettingsCubit>().state);
    // var response = await FirestoreOperations.sendMessageToChat(textFieldData, context.read<KmUserCubit>().state, context.read<KmSystemSettingsCubit>().state,
    //   privateMessageTargetUid, privateMessageTargetUid != "" ? textFieldData.substring(privateMessageTargetName.length + 3) : textFieldData, publicNotification);
  }

  void _replyOperation(KmChatMessage kmChatMessage, KmUser kmUser) {
    if (kmChatMessage.userTitle == 'system' || kmChatMessage.userUid == kmUser.userUid) {
      HapticFeedback.vibrate();
      messageController.clear();
      privateMessageController.clear();
      privateMessageTargetUid = "";
      privateMessageTargetName = "";
    } else {
      if (messageController.text.isNotEmpty && privateMessageTargetUid == "") {
        textFieldFocusNode.requestFocus();
        messageController.text = "${kmChatMessage.userName} : ${messageController.text}";
        privateMessageTargetUid = kmChatMessage.userUid;
        privateMessageTargetName = kmChatMessage.userName;

        messageController.selection = TextSelection(baseOffset: messageController.text.length, extentOffset: messageController.text.length);
      } else {
        textFieldFocusNode.requestFocus();
        messageController.clear();
        messageController.text = "${kmChatMessage.userName} : ";
        privateMessageTargetUid = kmChatMessage.userUid;
        privateMessageTargetName = kmChatMessage.userName;
        messageController.selection = TextSelection(baseOffset: messageController.text.length, extentOffset: messageController.text.length);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    chatRef = BasicGetters.chatStreamReferenceGetter(context.read<KmUserCubit>().state.userCoordinates, context.read<KmSystemSettingsCubit>().state);

    FirestoreOperations.joinRoomRequest(context.read<KmUserCubit>().state, context.read<KmSystemSettingsCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoPageScaffold(
          backgroundColor: ColorConstants.themeColor,
          child: _connectionBool == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    KmButton(),
                    SizedBox(
                      height: 1.h,
                    ),
                    chatStreamBuilder(context.read<KmUserCubit>().state),
                    ChatTargetSection(),
                    SizedBox(
                      height: 10,
                    ),
                    ChatTextField(
                      whiteRabbitButtonOperation: whiteRabbitButtonOperation,
                      textFieldOnChangeOperation: chatTextFieldOnChangeOperation,
                      textFieldFocusNode: textFieldFocusNode,
                      messageController: messageController,
                    )
                  ],
                )
              : MiniWidgets.lostConnectionWidgetBuild()),
    );
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

  Widget chatStreamBuilder(KmUser kmUser) {
    return Flexible(
        child: StreamBuilder<QuerySnapshot<KmChatMessage>>(
            stream: chatRef.orderBy('user_message_time', descending: false).limitToLast(context.read<KmSystemSettingsCubit>().state.messagesAmount).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!snapshot.hasData) {
                  return MiniWidgets.circularProgress();
                }

                var dataCome = snapshot.requireData;

                return BlocBuilder<KmUserCubit, KmUser>(builder: (context, snapshotBloc) {
                  return FutureBuilder(
                      future: BasicGetters.chatFilteredMessagesGetter(dataCome, snapshotBloc),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          var snapData = snap.data!;

                          if (snapData.any((element) => element.userTitle != "system")) {
                            publicNotification =
                                DateTime.now().millisecondsSinceEpoch - snapData.firstWhere((element) => element.userTitle != 'system').userMessageTime.millisecondsSinceEpoch >
                                    1800000;
                          }

                          return ListView.builder(
                              reverse: true,
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.values.last,
                              itemCount: snapData.length,
                              itemBuilder: (context, indeks) {
                                return snapData.isNotEmpty ? ChatItem(kmChatMessage: snapData[indeks], kmUser: kmUser, replyOperation: _replyOperation) : const SizedBox();
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
}
