import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';
import '../../configs/colors_constant.dart';
import '../../configs/font_constant.dart';
import '../../configs/string_constant.dart';
import '../toolbar/toolbar.dart';

void showMessage(
    {required BuildContext context,
    Function? callback,
    String? title,
    String? message,
    String? positiveButton,
    String? negativeButton}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => FadeInUp(
            duration: const Duration(milliseconds: 300),
            animate: true,
            from: 30,
            child: CupertinoAlertDialog(
              title: Text(
                title!,
                style: TextStyle(
                  fontFamily: fontBold,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 15.sp : 8.sp,
                ),
              ),
              content: Text(
                message!,
                style: const TextStyle(
                  fontFamily: fontRegular,
                ),
              ),
              actions: [
                if (negativeButton!.isNotEmpty)
                  CupertinoDialogAction(
                      child: Text(
                        negativeButton,
                        style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 12.sp
                                : 6.sp,
                            fontFamily: fontMedium,
                            color: isDarkMode() ? white : black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                if (positiveButton!.isNotEmpty)
                  CupertinoDialogAction(
                      child: Text(
                        positiveButton,
                        style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 12.sp
                                : 6.sp,
                            fontFamily: fontMedium,
                            color: isDarkMode() ? white : black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback!();
                      })
              ],
            ),
          ));
}

showDialogForScreen(context, String title, String message,
    {Function? callback}) {
  showMessage(
      context: context,
      callback: () {
        if (callback != null) {
          callback();
        }
        return true;
      },
      message: message,
      title: title,
      negativeButton: '',
      positiveButton: Common.continues);
}

void showShareMessage(
    BuildContext context, Function shareCallback, String title) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => FadeInUp(
            duration: const Duration(milliseconds: 300),
            animate: true,
            from: 30,
            child: CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontFamily: fontMedium,
                ),
              ),
              content: const Text(
                "Do you want to share?",
                style: TextStyle(
                  fontFamily: fontRegular,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: fontRegular, color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                    child: const Text(
                      "Share",
                      style: TextStyle(
                          fontFamily: fontMedium, color: primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      shareCallback();
                    })
              ],
            ),
          ));
}

void showDropdownMessage(
  BuildContext context,
  Widget content,
  String title,
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                  left:
                      SizerUtil.deviceType == DeviceType.mobile ? 0.w : 2.9.w),
              child: Text(
                title,
                style: TextStyle(fontFamily: fontMedium, fontSize: 20.sp),
              ),
            ),
            contentPadding:
                EdgeInsets.only(left: 6.7.w, top: 0.5.h, right: 6.7.w),
            content: content,
          );
        });
      });
}

Future showDropDownDialog(BuildContext context, Widget content, String title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0XFFe3ecf3),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Padding(
            padding: EdgeInsets.only(
                left: SizerUtil.deviceType == DeviceType.mobile ? 0.w : 2.9.w),
            child: Text(
              title,
              style: TextStyle(fontFamily: fontMedium, fontSize: 20.sp),
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: 6.7.w, top: 0.5.h, right: 6.7.w),
          content: content,
        );
      });
}

Widget setDropDownContent(RxList<dynamic> list, Widget content,
    {Widget? searchcontent, bool isApiIsLoading = false}) {
  return SizedBox(
      height: SizerUtil.deviceType == DeviceType.mobile
          ? SizerUtil.height / 2
          : SizerUtil.height / 1.9, // Change as per your requirement
      width: SizerUtil.width, // Change as per your requirement
      child: Column(
        children: [
          getDividerForShowDialog(),
          searchcontent ?? Container(),
          if (list.isEmpty && isApiIsLoading == false)
            Expanded(
              child: Center(
                  child: Text(
                AlertDialogList.emptylist,
                style: TextStyle(fontSize: 4.5.w, fontFamily: fontMedium),
              )),
            )
          else if (isApiIsLoading == true)
            Expanded(
              child: Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    "assets/gif/ZKZg.gif",
                    width: 50,
                    height: 50,
                  ),
                ),
              )),
            ),
          list.isNotEmpty ? Expanded(child: content) : Container(),
          SizedBox(
            height: 1.0.h,
          ),
        ],
      ));
}

Widget setDropDownTestContent(RxList<dynamic> list, Widget content,
    {Widget? searchcontent}) {
  return SizedBox(
      height: SizerUtil.deviceType == DeviceType.mobile
          ? SizerUtil.height / 2
          : SizerUtil.height / 1.9, // Change as per your requirement
      width: SizerUtil.width, // Change as per your requirement
      child: Column(
        children: [
          getDividerForShowDialog(),
          searchcontent ?? Container(),
          if (list.isEmpty)
            Expanded(
              child: Center(
                  child: Text(
                AlertDialogList.emptylist,
                style: TextStyle(fontSize: 4.5.w, fontFamily: fontMedium),
              )),
            ),
          list.isNotEmpty ? Expanded(child: content) : Container(),
          SizedBox(
            height: 1.0.h,
          ),
        ],
      ));
}

Future showValidationDialog(
    {required BuildContext context,
    Function? callback,
    String? title,
    String? message,
    String? positiveButton,
    String? negativeButton,
    int? index}) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return FadeInUp(
          duration: const Duration(milliseconds: 300),
          animate: true,
          from: 30,
          child: CupertinoAlertDialog(
            title: index == 0
                ? const Text(
                    AddPrescriptionHintText.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: black,
                      fontFamily: fontBold,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : index == 1
                    ? const Text(
                        AddPrescriptionHintText.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: black,
                          fontFamily: fontBold,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : index == 2
                        ? const Text(
                            AddPrescriptionHintText.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: black,
                              fontFamily: fontBold,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
            content: index == 0
                ? const Text(
                    Addalertdialog.hospitalfield,
                    style: TextStyle(
                      fontSize: 13,
                      color: black,
                      fontFamily: fontMedium,
                    ),
                  )
                : index == 1
                    ? const Text(
                        Addalertdialog.cityfield,
                        style: TextStyle(
                          fontSize: 13,
                          color: black,
                          fontFamily: fontMedium,
                        ),
                      )
                    : index == 2
                        ? const Text(
                            Addalertdialog.statefield,
                            style: TextStyle(
                              fontSize: 13,
                              color: black,
                              fontFamily: fontMedium,
                            ),
                          )
                        : Container(),
            actions: [
              if (negativeButton!.isNotEmpty)
                CupertinoDialogAction(
                    child: Text(
                      negativeButton,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 12.sp
                              : 6.sp,
                          fontFamily: fontMedium,
                          color: black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              if (positiveButton!.isNotEmpty)
                CupertinoDialogAction(
                    child: Text(
                      positiveButton,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 12.sp
                              : 6.sp,
                          fontFamily: fontMedium,
                          color: black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      callback!();
                    })
            ],
          ),
        );
      });
}
