// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:sizer/sizer.dart';

import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/screens/chat/components/white_rabbit_button.dart';

import '../../../bloc/km_chat_reference.dart';
import '../../../models/km_chat_reference_model.dart';

class ChatTextField extends StatelessWidget {
  final void Function(String, String, String,List<KmChatMessage> kmChatMessage) whiteRabbitButtonOperation;
  final void Function(String) textFieldOnChangeOperation;
  final FocusNode textFieldFocusNode;
  final TextEditingController messageController;
  final String privateTargetName;
  final List<KmChatMessage> kmChatMessage;

  const ChatTextField({
    Key? key,
    required this.whiteRabbitButtonOperation,
    required this.textFieldOnChangeOperation,
    required this.textFieldFocusNode,
    required this.messageController,
    required this.privateTargetName,
    required this.kmChatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 13.h,
      width: 100.w,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: ColorConstants.designGreen, width: 3), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: CupertinoTextField(
                    suffixMode: OverlayVisibilityMode.editing,
                    suffix: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "${(messageController.text.length - (privateTargetName.length))}/99",
                        style: TextStyle(wordSpacing: 2, letterSpacing: 2.0, fontSize: 15.sp, color: ColorConstants.designGreen),
                      ),
                    ),
                    autofocus: false,
                    focusNode: textFieldFocusNode,
                    keyboardType: TextInputType.multiline,
                    onChanged: textFieldOnChangeOperation,
                    enableInteractiveSelection: true,
                    maxLines: 3,
                    maxLength: 99 + privateTargetName.length,
                    showCursor: true,
                    padding: EdgeInsets.fromLTRB(2.w, 3.w, 1.w, 1.w),
                    cursorColor: CupertinoColors.activeGreen,
                    cursorHeight: 3.h,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: ColorConstants.designGreen, width: 1),
                      ),
                    ),
                    controller: messageController,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: BlocBuilder<KmChatReferenceCubit, KmChatReferenceModel>(builder: (context, refBloc) {
                    return WhiteRabbitButton(whiteRabbitButtonOperation: () {
                      whiteRabbitButtonOperation(refBloc.chatSectionEnum.name, refBloc.chatTargetName, refBloc.chatTargetNo,kmChatMessage);
                    });
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
