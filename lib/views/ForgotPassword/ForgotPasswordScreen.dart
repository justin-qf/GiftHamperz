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
import 'package:gifthamperz/controller/password_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';
import '../../../../componant/input/form_inputs.dart';
import '../../../../componant/toolbar/toolbar.dart';
import '../../../../configs/colors_constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var controller = Get.put(PasswordController());

  @override
  void initState() {
    controller.numberCtr.text = "";
    super.initState();
  }

  @override
  void dispose() {
    controller.numberCtr.text = "";
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.h,
                          vertical: SizerUtil.deviceType == DeviceType.mobile
                              ? 2.h
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
                            key: controller.passwordkey,
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
                                    ForgotPassScreenConstant.title,
                                    style: styleTitle(),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                FadeInDown(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.6.h),
                                    child: Text(
                                      ForgotPassScreenConstant.desc,
                                      style: styleTitleSubtaxt(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                getLable(LoginConst.phonenumber),
                                FadeInDown(
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(() {
                                      return getReactiveFormField(
                                          node: controller.numberNode,
                                          controller: controller.numberCtr,
                                          hintLabel: LoginConst.number,
                                          onChanged: (val) {
                                            controller.validatePhone(val);
                                          },
                                          obscuretext: false,
                                          inputType: TextInputType.number,
                                          errorText: controller
                                              .numberModel.value.error);
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
                                          controller.getForgotOtp(
                                            context,
                                          );
                                        }
                                      }, ForgotPassScreenConstant.btnLable,
                                          isvalidate: controller
                                              .isFormInvalidate.value);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
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
