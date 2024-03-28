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
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/signup_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/LoginScreen/LoginScreen.dart';
import 'package:sizer/sizer.dart';
import '../../../../componant/input/form_inputs.dart';
import '../../../../configs/colors_constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var controller = Get.put(SignUpController());

  @override
  void initState() {
    controller.mobileCtr.text = "";
    super.initState();
  }

  @override
  void dispose() {
    controller.mobileCtr.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarProfile(false);
    return CustomParentScaffold(
      onWillPop: () async {
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
            top: isSmallDevice(context) ? 12.h : 20.h,
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
                          Form(
                            key: controller.signupkey,
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
                                    SignupConstant.title,
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
                                      SignupConstant.subText,
                                      style: styleTitleSubtaxt(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                getDynamicSizedBox(
                                  height: 2.h,
                                ),
                                getLable(LoginConst.mobileLable),
                                FadeInDown(
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(() {
                                      return getReactiveFormField(
                                          node: controller.mobileNode,
                                          controller: controller.mobileCtr,
                                          hintLabel: LoginConst.mobile,
                                          onChanged: (val) {
                                            controller.validateMobile(val);
                                          },
                                          obscuretext: false,
                                          inputType: TextInputType.number,
                                          errorText: controller
                                              .mobileModel.value.error);
                                    }),
                                  ),
                                ),
                                // getLable(LoginConst.passwordLable),
                                // FadeInDown(
                                //   child: AnimatedSize(
                                //     duration: const Duration(milliseconds: 300),
                                //     child: Obx(() {
                                //       return getReactiveFormField(
                                //           node: controller.passNode,
                                //           controller: controller.passwordctr,
                                //           hintLabel: LoginConst.password,
                                //           wantSuffix: true,
                                //           isPass: true,
                                //           obscuretext: true,
                                //           onChanged: (val) {
                                //             controller.validatePassword(val);
                                //           },
                                //           fromObsecureText: "SIGNUP",
                                //           inputType: TextInputType.text,
                                //           errorText:
                                //               controller.passModel.value.error);
                                //     }),
                                //   ),
                                // ),
                                // getLable(LoginConst.confirmPasswordLable),
                                // FadeInDown(
                                //   child: AnimatedSize(
                                //     duration: const Duration(milliseconds: 300),
                                //     child: Obx(() {
                                //       return getReactiveFormField(
                                //           node: controller.confirmNode,
                                //           controller: controller.confirmpassCtr,
                                //           hintLabel:
                                //               LoginConst.confirmPasswordHint,
                                //           wantSuffix: true,
                                //           isPass: true,
                                //           obscuretext: true,
                                //           onChanged: (val) {
                                //             controller.validatePassword(val);
                                //           },
                                //           fromObsecureText: "LOGIN",
                                //           inputType: TextInputType.text,
                                //           errorText:
                                //               controller.passModel.value.error);
                                //     }),
                                //   ),
                                // ),
                                getDynamicSizedBox(
                                  height:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 2.h
                                          : 0.h,
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
                                          controller.getSignUpOtp(
                                              context,
                                              controller.mobileCtr.text
                                                  .toString());
                                        }
                                      },
                                          isFromCart: true,
                                          SignupConstant.buttonLabel,
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
                          FadeInUp(
                            from: 20,
                            delay: const Duration(milliseconds: 500),
                            child: InkWell(
                              onTap: () {
                                Get.to(const LoginScreen());
                              },
                              child: getFooter(false),
                            ),
                          ),
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
