import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class MiniWidgets {
  static Widget circularProgress() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.transparent,
      ),
    );
  }

  static CupertinoButton closeButton(BuildContext context, Function()? func) {
    return CupertinoButton(
        onPressed: func ??
            () {
              Navigator.pop(context);
            },
        child: SvgPicture.asset('assets/svg/close_vector.svg'));
  }


 static Widget lostConnectionWidgetBuild() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Lost Internet Connection"),
          Padding(
            padding: EdgeInsets.all(5.h),
            child: CupertinoActivityIndicator(
              animating: true,
              radius: 15.sp,
            ),
          ),
          const Text("Please Wait"),
        ],
      ),
    );
  }

}
