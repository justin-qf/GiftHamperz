import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../configs/colors_constant.dart';
import '../../configs/font_constant.dart';

class ImageViewerScreen extends StatelessWidget {
  String url;
  bool isLocal = false;
  File? file;
  String? description = "";
  String? title = "";
  bool? isPending = false;
  String? userID;
  BuildContext? parentContext;
  ImageViewerScreen(
    this.url,
    this.isLocal, {
    super.key,
    this.file,
    this.description,
    this.title,
    this.isPending,
    this.userID,
    this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {},
        onVerticalDragUpdate: (details) {
          if (details.delta.direction >= 1.5) {
            Get.back();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            Get.back();
            return false;
          },
          child: Scaffold(
            body: Container(
              color: black,
              child: Column(
                children: [
                  Container(
                    color: black,
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 3.w),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back,
                                  size:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 6.w
                                          : 5.w,
                                  color: white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        title!,
                        style: TextStyle(
                            fontFamily: fontSemiBold,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 17.sp
                                : 13.sp,
                            color: white),
                      ),
                      Expanded(flex: 1, child: Container())
                    ]),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            //padding: EdgeInsets.only(left: 2.w, right: 2.w),
                            height: SizerUtil.height / 1.4,
                            width: SizerUtil.width,
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 5.w
                                      : 2.5.w),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) {
                                  return SizedBox(
                                    height: SizerUtil.height,
                                    width: SizerUtil.width,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                          color: primaryColor),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

getFullImageViewer(String url, bool isLocal, {File? file}) {
  return SafeArea(
    child: GestureDetector(
      onTap: () {},
      onVerticalDragUpdate: (details) {
        if (details.delta.direction >= 0) {
          Get.back();
        }
      },
      child: Container(
        color: black,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back(result: true);
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(left: 3.w),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back,
                              size: SizerUtil.deviceType == DeviceType.mobile
                                  ? 6.w
                                  : 5.w,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
            Expanded(
              child: Center(
                child: isLocal
                    ? Image.file(
                        file!,
                      )
                    : CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) {
                          return const CircularProgressIndicator(
                              color: primaryColor);
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

getFullImageViewerForApproval(BuildContext context, String url,
    {String? title}) {
  return SafeArea(
    child: GestureDetector(
      onTap: () {},
      onVerticalDragUpdate: (details) {
        if (details.delta.direction >= 0) {
          Get.back();
        }
      },
      child: Scaffold(
        body: Container(
          color: black,
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.back(result: true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 3.w),
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back,
                            size: SizerUtil.deviceType == DeviceType.mobile
                                ? 6.w
                                : 5.w,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title!,
                  style: TextStyle(
                      fontFamily: fontSemiBold,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 17.sp
                          : 13.sp,
                      color: white),
                ),
                Expanded(flex: 1, child: Container())
              ]),
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizerUtil.height / 1.5,
                        // width: SizerUtil.width,
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.scaleDown,
                          placeholder: (context, url) {
                            return const CircularProgressIndicator(
                                color: primaryColor);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
