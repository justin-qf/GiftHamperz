import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/Resetpass_controller.dart';
import 'package:gifthamperz/controller/changePasswordController.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/PrepareScreen/PrepareScreen.dart';
import 'package:sizer/sizer.dart';
import '../../../../componant/input/form_inputs.dart';
import '../../../../componant/toolbar/toolbar.dart';
import '../../../../configs/colors_constant.dart';

// ignore: must_be_immutable
class RecoveryScreen extends StatefulWidget {
  RecoveryScreen({
    this.mobile,
    Key? key,
  }) : super(key: key);
  String? mobile;
  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  var controller = Get.put(ResetpassController());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              top: 3.5.h,
              left: 0,
              child: backPress(() {
                Get.back();
              })),
          Positioned(
            top: 20.h,
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
                  FadeInUp(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.h,
                          vertical: SizerUtil.deviceType == DeviceType.mobile
                              ? 3.h
                              : 2.5.h),
                      decoration: BoxDecoration(
                          color: isDarkMode() ? darkBackgroundColor : white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10.0,
                                offset: const Offset(0, 1),
                                spreadRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.h),
                              topRight: Radius.circular(5.h))),
                      child: Column(
                        children: [
                          Form(
                            key: controller.resetpasskey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 0.5.h
                                        : 0.h),
                                FadeInDown(
                                  child: Text(
                                    ResetPasstext.title,
                                    style: styleTitle(),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                getLable(ResetPasstext.passwordLable),
                                FadeInDown(
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(() {
                                      return getReactiveFormField(
                                          node: controller.newpassNode,
                                          controller: controller.newpassCtr,
                                          hintLabel: ResetPasstext.newpass,
                                          onChanged: (val) {
                                            controller.validateNewPass(val);
                                          },
                                          index: "0",
                                          fromObsecureText: "RESETPASS",
                                          obscuretext: true,
                                          wantSuffix: true,
                                          isPass: true,
                                          inputType: TextInputType.emailAddress,
                                          errorText: controller
                                              .newPassModel.value.error);
                                    }),
                                  ),
                                ),
                                getLable(ResetPasstext.confirmPasswordLable),
                                FadeInDown(
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(() {
                                      return getReactiveFormField(
                                          node: controller.confirmpassNode,
                                          controller: controller.confirmCtr,
                                          hintLabel: ResetPasstext.confirmpass,
                                          onChanged: (val) {
                                            controller.validateConfirmPass(val);
                                          },
                                          index: "1",
                                          fromObsecureText: "RESETPASS",
                                          obscuretext: true,
                                          wantSuffix: true,
                                          isPass: true,
                                          inputType: TextInputType.emailAddress,
                                          errorText: controller
                                              .confirmPassModel.value.error);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
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
                                          controller.getForgotPass(context,
                                              widget.mobile!.toString().trim());
                                        }
                                      }, ResetPasstext.buttonLabel,
                                          isvalidate: controller
                                              .isFormInvalidate.value);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizerUtil.deviceType == DeviceType.mobile
                                ? 0.h
                                : 2.h,
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
