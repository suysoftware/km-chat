import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

class ChatTargetSection extends StatelessWidget {
  const ChatTargetSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 0.0, 0.0, 0.0),
      child: SizedBox(
        height: 40,
        width: 100.w,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 30.w,
            mainAxisSpacing: 2.w,
          ),
          padding: EdgeInsets.zero,
          itemCount: 10,
          itemBuilder: (context, indeks) {
            return GestureDetector(
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(color: ColorConstants.juniorColor, width: 2)),
                    child: Text("${indeks.toString()}. kisiler")),
              ),
              onTap: () {
                print(indeks);
              },
            );
          },
        ),
      ),
    );
  }
}
