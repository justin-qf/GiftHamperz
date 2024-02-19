import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class FullScreenImage extends StatefulWidget {
  final String imageUrl; // URL of the image to display
  final String title; // URL of the image to display

  FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.title,
    this.fromProfile,
  });
  bool? fromProfile;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarScreen();
    return Scaffold(
      body: Container(
        color: black,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            getImage(
              widget.title,
              showBackButton: true,
              callback: () {
                Get.back();
              },
            ),
            Expanded(
              child: Center(
                child: PhotoView(
                  imageProvider: NetworkImage(widget.imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: black,
                  ),
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                        height: SizerUtil.height,
                        width: SizerUtil.width,
                        child: Center(
                          child: Text(
                            'Image Not Found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: white,
                                fontFamily: fontBold,
                                fontSize: 11.2.sp),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
