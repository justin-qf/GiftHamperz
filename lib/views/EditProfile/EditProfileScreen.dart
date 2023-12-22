import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/edit_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        logcat("onWillPop", "DONE");
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
            getForgetToolbar(EditScreenConstant.title, showBackButton: true,
                callback: () {
              Get.back();
            }),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  getDynamicSizedBox(height: 1.h),
                  FadeInDown(
                    from: 50,
                    child: GestureDetector(
                      child: Obx(() {
                        return controller.getImage();
                      }),
                      onTap: () async {
                        await controller.actionClickUploadImage(context);
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: SizerUtil.deviceType == DeviceType.mobile
                                ? 0.5.h
                                : 0.h),
                        getLable(RegistrationConstant.hintFirstName),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.fullnamenode,
                                  controller: controller.fullnamectr,
                                  hintLabel: RegistrationConstant.firstName,
                                  onChanged: (val) {
                                    controller.validateFullName(val);
                                  },
                                  obscuretext: false,
                                  inputType: TextInputType.name,
                                  errorText:
                                      controller.fullnamemodel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        getLable(LoginConst.phonenumber),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.phonenumbernode,
                                  controller: controller.phonenumberctr,
                                  hintLabel: LoginConst.number,
                                  onChanged: (val) {
                                    controller.validatePhone(val);
                                  },
                                  obscuretext: false,
                                  inputType: TextInputType.number,
                                  errorText: controller.phonemodel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        getLable(LoginConst.emailLable),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.emailnode,
                                  controller: controller.emailCtr,
                                  hintLabel: LoginConst.email,
                                  onChanged: (val) {
                                    controller.validateEmail(val);
                                  },
                                  obscuretext: false,
                                  inputType: TextInputType.emailAddress,
                                  errorText: controller.emailModel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        getLable(LoginConst.passwordLable),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.passNode,
                                  controller: controller.passwordctr,
                                  hintLabel: LoginConst.password,
                                  wantSuffix: true,
                                  isPass: true,
                                  obscuretext: true,
                                  onChanged: (val) {
                                    controller.validatePassword(val);
                                  },
                                  fromObsecureText: "EDIT",
                                  inputType: TextInputType.text,
                                  errorText: controller.passModel.value.error);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
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
                                    true) {}
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
