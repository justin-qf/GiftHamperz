import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/changePasswordController.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var controller = Get.put(ChangePassController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.currentCtr.text = "";
    controller.newpassCtr.text = "";
    controller.confirmCtr.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Column(
          children: [
            getForgetToolbar(ChangPasswordScreenConstant.title,
                showBackButton: true, callback: () {
              Get.back();
            }),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  getDynamicSizedBox(height: 1.h),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: SizerUtil.deviceType == DeviceType.mobile
                                ? 0.5.h
                                : 0.h),
                        getLable(ChangPasswordScreenConstant.currentPassHint),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.currentpassNode,
                                  controller: controller.currentCtr,
                                  hintLabel: ChangPasswordScreenConstant
                                      .currentPasswordHint,
                                  onChanged: (val) {
                                    controller.validateCurrentPass(val);
                                  },
                                  obscuretext: true,
                                  wantSuffix: true,
                                  isPass: true,
                                  index: "0",
                                  fromObsecureText: "RESETPASS",
                                  inputType: TextInputType.emailAddress,
                                  errorText:
                                      controller.currentPassModel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        getLable(ChangPasswordScreenConstant.newPassHint),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.newpassNode,
                                  controller: controller.newpassCtr,
                                  hintLabel: ChangPasswordScreenConstant
                                      .newPasswordHint,
                                  onChanged: (val) {
                                    controller.validateNewPass(val);
                                  },
                                  index: "1",
                                  fromObsecureText: "RESETPASS",
                                  obscuretext: true,
                                  wantSuffix: true,
                                  isPass: true,
                                  inputType: TextInputType.emailAddress,
                                  errorText:
                                      controller.newPassModel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        getLable(ChangPasswordScreenConstant
                            .validConfirmPassHint),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.confirmpassNode,
                                  controller: controller.confirmCtr,
                                  hintLabel: ChangPasswordScreenConstant
                                      .validConfirmPasswordHint,
                                  onChanged: (val) {
                                    controller.validateConfirmPass(val);
                                  },
                                  index: "2",
                                  fromObsecureText: "RESETPASS",
                                  obscuretext: true,
                                  wantSuffix: true,
                                  isPass: true,
                                  inputType: TextInputType.emailAddress,
                                  errorText:
                                      controller.confirmPassModel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
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
                                if (controller.isFormInvalidate.value == true) {
                                  controller.getChangePassword(context);
                                }
                              }, Button.update,
                                  isvalidate:
                                      controller.isFormInvalidate.value);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
