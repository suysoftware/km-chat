import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:sizer/sizer.dart';

class KmChatArtItem extends StatelessWidget {
  final String imageLink;
  const KmChatArtItem({Key? key, required this.imageLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.h),
            child: Text(
              "KM-ART: ",
              style: StyleConstants.privateMessageTextStyle,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(border: Border.all(color: ColorConstants.privateMessageColor)),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageLink,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(CupertinoIcons.xmark),
              )),
          Spacer(
            flex: 2,
          ),
          CupertinoButton(child: Icon(CupertinoIcons.cloud_download), onPressed: () {}),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
