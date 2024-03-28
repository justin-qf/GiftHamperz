import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/verifyotp_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import '../../../../configs/colors_constant.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  OtpScreen({
    this.mobile,
    this.otp,
    this.isFromSignUp,
    this.isFromLogin,
    Key? key,
  }) : super(key: key);
  String? otp;
  String? mobile;
  bool? isFromSignUp;
  bool? isFromLogin;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var controller = Get.put(OtpController());

  @override
  void initState() {
    controller.clearFocuseNode();
    controller.fieldOne.text = '';
    controller.fieldTwo.text = '';
    controller.fieldThree.text = '';
    controller.fieldFour.text = '';
    controller.otpController.text = "";
    controller.otpController.clear();
    controller.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    controller.timer.cancel();
    controller.otpController.clear();
    controller.fieldOne.text = '';
    controller.fieldTwo.text = '';
    controller.fieldThree.text = '';
    controller.fieldFour.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarProfile(false);
    return CustomParentScaffold(
      onWillPop: () async {
        logcat("onWillPop", "DONE");
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isFormScreen: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeInDown(
              child: SizedBox(
                height: SizerUtil.height / 2 + SizerUtil.height / 4,
                child: Image.asset(
                  Asset.loginBg,
                  fit: BoxFit.cover,
                  height: SizerUtil.height,
                  width: SizerUtil.width,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15.h,
            child: FadeInLeft(
              child: Container(
                margin: EdgeInsets.only(left: 10.w, bottom: 2.h),
                child: SvgPicture.asset(
                  Asset.logo,
                  height: 18.h,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // FadeInLeft(
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 10.w, bottom: 2.h),
                  //     child: SvgPicture.asset(
                  //       Asset.logo,
                  //       height: 17.h,
                  //     ),
                  //   ),
                  // ),
                  FadeInUp(
                    child: Container(
                      width: SizerUtil.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.h,
                          vertical: SizerUtil.deviceType == DeviceType.mobile
                              ? 2.h
                              : 2.5.h),
                      decoration: BoxDecoration(
                          color: isDarkMode() ? darkBackgroundColor : white,
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.2),
                                blurRadius: 10.0,
                                offset: const Offset(0, 1),
                                spreadRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.h),
                              topRight: Radius.circular(5.h))),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 0.5.h
                                          : 0.h),
                              FadeInDown(
                                child: Text(
                                  OtpConstant.title,
                                  style: styleTitle(),
                                ),
                              ),
                              getDynamicSizedBox(
                                height: 1.5.h,
                              ),
                              FadeInDown(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.6.h),
                                  child: Text(
                                    OtpConstant.desc,
                                    style: styleTitleSubtaxt(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              getDynamicSizedBox(
                                height: 3.h,
                              ),
                              Pinput(
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
                                  height:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 68.0
                                          : 80.0,
                                  width:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 68.0
                                          : 80.0,
                                  decoration: getPinTheme()
                                      .decoration!
                                      .copyWith(
                                        border: Border.all(color: primaryColor),
                                      ),
                                ),
                                submittedPinTheme: getPinTheme().copyWith(
                                  height:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 58.0
                                          : 65.0,
                                  width:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 58.0
                                          : 65.0,
                                ),
                                followingPinTheme: getPinTheme().copyWith(
                                  height:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 58.0
                                          : 70.0,
                                  width:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 58.0
                                          : 70.0,
                                ),
                                errorPinTheme: getPinTheme().copyWith(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 234, 238, 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              getDynamicSizedBox(
                                height:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 3.h
                                        : 1.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 8.w,
                                  right: 8.w,
                                ),
                                child: FadeInUp(
                                  from: 50,
                                  child: Obx(() {
                                    return getSecondaryFormButton(() {
                                      if (controller.isFormInvalidate.value ==
                                          true) {
                                        if (widget.isFromSignUp == true) {
                                          controller.getLoginOtpApi(
                                              context,
                                              widget.otp.toString(),
                                              widget.mobile.toString());
                                        } else {
                                          controller.getOtpApi(
                                              context,
                                              widget.otp.toString(),
                                              widget.mobile.toString());
                                        }
                                      }
                                    },
                                        isFromCart: true,
                                        BottomConstant.buttonLabel,
                                        isvalidate:
                                            controller.isFormInvalidate.value);
                                  }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          FadeInUp(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: FadeInUp(
                                child: Obx(
                                  () {
                                    return InkWell(
                                      canRequestFocus: false,
                                      onTap: () {
                                        controller.clearFocuseNode();
                                      },
                                      child: controller.countdown.value == 0
                                          ? GestureDetector(
                                              onTap: () {
                                                if (widget.isFromSignUp ==
                                                    true) {
                                                  controller.getSignUpOtp(
                                                    context,
                                                    widget.mobile.toString(),
                                                  );
                                                } else {
                                                  controller.getForgotOtp(
                                                      context,
                                                      widget.mobile
                                                          .toString()
                                                          .trim());
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    VerificationScreen
                                                        .didtReceivedCode,
                                                    style: styleDidtReceiveOTP(
                                                        context),
                                                  ),
                                                  Text(
                                                    VerificationScreen.resend,
                                                    style: styleResentButton(),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Text(
                                              'Time remaining: ${controller.countdown} seconds',
                                              style: TextStyle(
                                                  fontSize:
                                                      SizerUtil.deviceType ==
                                                              DeviceType.mobile
                                                          ? 11.5.sp
                                                          : 9.sp,
                                                  fontWeight: FontWeight.w100,
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
                          SizedBox(
                            height: SizerUtil.deviceType == DeviceType.mobile
                                ? 2.h
                                : 1.5.h,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
