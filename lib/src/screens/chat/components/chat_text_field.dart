// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/screens/chat/components/white_rabbit_button.dart';

class ChatTextField extends StatelessWidget {
  final void Function() whiteRabbitButtonOperation;
  final void Function(String) textFieldOnChangeOperation;
  final FocusNode textFieldFocusNode;
  final TextEditingController messageController;

  ChatTextField({
    Key? key,
    required this.whiteRabbitButtonOperation,
    required this.textFieldOnChangeOperation,
    required this.textFieldFocusNode,
    required this.messageController,
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
                        "${messageController.text.length}/99",
                        style: TextStyle(wordSpacing: 2, letterSpacing: 2.0, fontSize: 16.sp, color: ColorConstants.designGreen),
                      ),
                    ),
                    autofocus: false,
                    focusNode: textFieldFocusNode,
                    keyboardType: TextInputType.multiline,
                    onChanged: textFieldOnChangeOperation,
                    enableInteractiveSelection: true,
                    maxLines: 3,
                    maxLength: 99,
                    showCursor: true,
                    padding: EdgeInsets.fromLTRB(2.w, 1.w, 1.w, 1.w),
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
                Expanded(flex: 1, child: WhiteRabbitButton(whiteRabbitButtonOperation: whiteRabbitButtonOperation))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
