// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

class WhiteRabbitButton extends StatelessWidget {
  final void Function() whiteRabbitButtonOperation;
  final bool isBot;
  final bool isChat;

  const WhiteRabbitButton({
    Key? key,
    required this.whiteRabbitButtonOperation,
    required this.isChat,
    required this.isBot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (){
if(isBot){
  FocusScope.of(context).unfocus();
}
        whiteRabbitButtonOperation();
      },
      child: SvgPicture.asset(
        isChat ? "assets/svg/rabbit_chat.svg" : "assets/svg/rabbit_art.svg",
        color: ColorConstants.designGreen,
        width: 10.w,
        height: 10.w,
      ),
    );
  }
}
