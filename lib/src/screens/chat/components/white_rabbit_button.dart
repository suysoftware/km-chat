// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

class WhiteRabbitButton extends StatelessWidget {
  final void Function() whiteRabbitButtonOperation;
  const WhiteRabbitButton({
    Key? key,
    required this.whiteRabbitButtonOperation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: SizedBox(
          width: 8.w,
          height: 8.w,
          child: Image.asset(
            "assets/images/white_rabbit.png",
            color: ColorConstants.designGreen,
          )),
      onPressed:whiteRabbitButtonOperation,
    );
  }
}
