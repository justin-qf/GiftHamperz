import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/controller/CartController.dart';
import 'package:gifthamperz/controller/guest_login_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:pinput/pinput.dart';
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
            backgroundColor:
                isDarkMode() ? darkBackgroundColor.withOpacity(0.9) : white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
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

getGuestUserLogin(BuildContext context) async {
  return await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: CustomLoginAlertRoundedDialog(),
      );
    },
    transitionBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

var controller = Get.put(GuestLoginController());

Future<Future> getLoginBottomSheetDialog(BuildContext parentContext) async {
  controller.numberCtr.text = "";
  controller.isFormInvalidate.value = false;
  controller.isOtpFormInvalidate.value = false;
  controller.otpController.text = '';
  return showModalBottomSheet(
      context: parentContext,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(13.w),
      )),
      constraints: BoxConstraints(
        maxWidth: SizerUtil.width, // here increase or decrease in width
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Obx(
                () {
                  return Container(
                    color: white,
                    child: Wrap(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.w),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.w),
                                    )),
                                padding:
                                    EdgeInsets.only(top: 2.5.h, bottom: 2.h),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.isOtpVisible!.value == true
                                        ? OtpConstant.title
                                        : LoginConst.buttonLabel,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 16.sp,
                                      fontFamily: fontBold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.close_rounded,
                                          color: Colors.black,
                                          size: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 25
                                              : 50,
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 3.h,
                        ),
                        controller.isOtpVisible!.value == true
                            ? Center(
                                child: Pinput(
                                  length: 4,
                                  controller: controller.otpController,
                                  focusNode: controller.otpNode,
                                  defaultPinTheme: getPinTheme(),
                                  onCompleted: (pin) {
                                    if (controller.isFormInvalidate.value =
                                        pin.length == 4) {}
                                    setState(() => controller.showError =
                                        // controller.isFormInvalidate.value =
                                        pin.length != 4);
                                  },
                                  onChanged: (value) {
                                    controller.enableButton(value);
                                  },
                                  focusedPinTheme: getPinTheme().copyWith(
                                    height: 68.0,
                                    width: 64.0,
                                    decoration:
                                        getPinTheme().decoration!.copyWith(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      114, 178, 238, 1)),
                                            ),
                                  ),
                                  errorPinTheme: getPinTheme().copyWith(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 234, 238, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              )
                            : FadeInDown(
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: Obx(() {
                                    return getReactiveFormField(
                                        node: controller.numberNode,
                                        controller: controller.numberCtr,
                                        hintLabel: LoginConst.mobile,
                                        onChanged: (val) {
                                          controller.validatePhone(val);
                                        },
                                        obscuretext: false,
                                        inputType: TextInputType.number,
                                        errorText:
                                            controller.numberModel.value.error);
                                  }),
                                ),
                              ),
                        Container(
                            width: SizerUtil.width,
                            margin: EdgeInsets.only(
                              top: 2.h,
                              left: 25.w,
                              right: 25.w,
                            ),
                            child: FadeInUp(
                                from: 50,
                                child: Obx(() {
                                  return commonBtn(Button.submit, () {
                                    if (controller.isOtpVisible!.value ==
                                        true) {
                                      logcat("ISOTP::::", 'DONE');
                                      if (controller
                                              .isOtpFormInvalidate.value ==
                                          true) {
                                        controller.verifyOtpAPI(
                                            context,
                                            controller.otp!.value.toString(),
                                            controller.numberCtr.text
                                                .toString());
                                      }
                                    } else {
                                      if (controller.isFormInvalidate.value ==
                                          true) {
                                        logcat("IS__SINUP", 'DONE');
                                        controller.getSignUpOtp(
                                            context,
                                            controller.numberCtr.text
                                                .toString());
                                      }
                                    }
                                  },
                                      isvalidate: controller
                                                  .isOtpVisible!.value ==
                                              true
                                          ? controller.isOtpFormInvalidate.value
                                          : controller.isFormInvalidate.value);
                                }))),
                        controller.isOtpVisible!.value == true
                            ? Center(
                                child: FadeInUp(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 1.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    child: FadeInUp(
                                      child: Obx(
                                        () {
                                          return InkWell(
                                            canRequestFocus: false,
                                            onTap: () {
                                              controller.clearFocuseNode();
                                            },
                                            child: controller.countdown.value ==
                                                    0
                                                ? GestureDetector(
                                                    onTap: () {
                                                      controller.getSignUpOtp(
                                                        context,
                                                        controller
                                                            .numberCtr.text
                                                            .toString(),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          VerificationScreen
                                                              .didtReceivedCode,
                                                          style:
                                                              styleDidtReceiveOTP(
                                                                  context),
                                                        ),
                                                        Text(
                                                          VerificationScreen
                                                              .resend,
                                                          style:
                                                              styleResentButton(),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Text(
                                                    'Time remaining: ${controller.countdown} seconds',
                                                    style: TextStyle(
                                                        fontSize: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? 11.5.sp
                                                            : 9.sp,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontFamily: fontRegular,
                                                        color: isDarkMode()
                                                            ? white
                                                            : labelTextColor),
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 2.h,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      });
}
