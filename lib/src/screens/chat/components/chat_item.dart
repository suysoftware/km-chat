// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/utils/basic_getters.dart';
import 'package:sizer/sizer.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_user.dart';

class ChatItem extends StatelessWidget {
  final KmChatMessage kmChatMessage;
  final KmUser kmUser;
  final void Function(KmChatMessage kmChatMessage, KmUser kmUser) replyOperation;
  const ChatItem({
    Key? key,
    required this.kmChatMessage,
    required this.kmUser,
    required this.replyOperation,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
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
        replyOperation(kmChatMessage, kmUser);

        // Here call setState to update state
      },
      backgroundBuilder: (context, direction, progress) {
        if (kmChatMessage.userTitle != 'system' && kmChatMessage.userUid != kmUser.userUid) {
          return AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return AnimatedContainer(
                onEnd: () {},
                duration: const Duration(milliseconds: 400),
                color: progress.isDismissed ? Colors.transparent : (progress.value > 0.5 ? ColorConstants.juniorColor : ColorConstants.systemColor),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
      key: UniqueKey(),
      child: Padding(padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.h), child: BasicGetters.textWidgetGetter(kmChatMessage, kmUser.userUid, context)),
    );
  }
}
