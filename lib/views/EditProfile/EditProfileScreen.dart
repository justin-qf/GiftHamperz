import 'package:animate_do/animate_do.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/edit_controller.dart';
import 'package:gifthamperz/models/UserModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(this.loginData, {super.key});
  UserDetailData? loginData;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.put(EditProfileController());

  @override
  void initState() {
    controller.initDataSet(widget.loginData);
    setState(() {});
    super.initState();
  }

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
              Get.back(result: false);
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
                        getLable(RegistrationConstant.userName),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.userNameNode,
                                  controller: controller.userNamectr,
                                  hintLabel: RegistrationConstant.hintUserName,
                                  onChanged: (val) {
                                    //controller.validateFullName(val);
                                  },
                                  obscuretext: false,
                                  inputType: TextInputType.name,
                                  errorText:
                                      controller.fullnamemodel.value.error);
                            }),
                          ),
                        ),
                        // SizedBox(
                        //   height: 1.h,
                        // ),
                        // getLable(LoginConst.phonenumber),
                        // FadeInDown(
                        //   child: AnimatedSize(
                        //     duration: const Duration(milliseconds: 300),
                        //     child: Obx(() {
                        //       return getReactiveFormField(
                        //           node: controller.phonenumbernode,
                        //           controller: controller.phonenumberctr,
                        //           hintLabel: LoginConst.number,
                        //           onChanged: (val) {
                        //             controller.validatePhone(val);
                        //           },
                        //           obscuretext: false,
                        //           inputType: TextInputType.number,
                        //           errorText: controller.phonemodel.value.error);
                        //     }),
                        //   ),
                        // ),
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
                                    //  controller.validateEmail(val);
                                  },
                                  obscuretext: false,
                                  inputType: TextInputType.emailAddress,
                                  errorText: controller.emailModel.value.error);
                            }),
                          ),
                        ),
                        getDynamicSizedBox(
                          height: 1.h,
                        ),
                        getLable(RegistrationConstant.dob),
                        FadeInDown(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                  node: controller.dobNode,
                                  controller: controller.dobCtr,
                                  hintLabel: AddPrescriptionHintText.date,
                                  wantSuffix: true,
                                  isCalender: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: controller.selectedDate,
                                        firstDate: DateTime(1950),
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Theme(
                                            data: isDarkMode()
                                                ? getDarkModeDatePicker()
                                                : getLightModeDatePicker(),
                                            child: child!,
                                          );
                                        },
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 0)));
                                    if (pickedDate != null &&
                                        pickedDate != controller.selectedDate) {
                                      setState(() {
                                        controller.selectedDate = pickedDate;
                                      });
                                    }
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat(Date.dateFormat)
                                              .format(pickedDate);
                                      controller.updateDate(formattedDate);
                                      //controller.validatedob(formattedDate);
                                    }
                                  },
                                  onChanged: (val) {
                                    //controller.validatedob(val);
                                  },
                                  inputType: TextInputType.text,
                                  errorText: controller.dobModel.value.error);
                            }),
                          ),
                        ),
                        getDynamicSizedBox(
                          height: 1.h,
                        ),
                        getLable(RegistrationConstant.gender),
                        getSizedBoxForDropDown(),
                        FadeInDown(
                            child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                              margin: EdgeInsets.only(
                                left: 6.w,
                                right: 6.w,
                              ),
                              child: Obx(
                                () {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      buttonPadding: EdgeInsets.only(
                                          left: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 0.5.w
                                              : 2.0.w,
                                          top: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 4.5
                                              : 1.2.w,
                                          bottom: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 4.5
                                              : 1.2.w),
                                      isExpanded: true,
                                      buttonDecoration: BoxDecoration(
                                        border:
                                            Border.all(color: inputBorderColor),
                                        borderRadius: BorderRadius.circular(
                                            SizerUtil.deviceType ==
                                                    DeviceType.mobile
                                                ? 30
                                                : 50),
                                      ),
                                      hint: Text(
                                        AddFamilylist.gender,
                                        style: styleTextForFieldHintDropDown(),
                                      ),
                                      items: controller.gender
                                          .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child:
                                                        SizerUtil.deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? Text(
                                                                item,
                                                                style:
                                                                    styleTextFormFieldText(),
                                                              )
                                                            : Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: SizerUtil.deviceType ==
                                                                            DeviceType
                                                                                .mobile
                                                                        ? 20
                                                                        : 0.6.h,
                                                                    bottom: SizerUtil.deviceType ==
                                                                            DeviceType
                                                                                .mobile
                                                                        ? 10
                                                                        : 1.8.w,
                                                                    left: SizerUtil.deviceType ==
                                                                            DeviceType.mobile
                                                                        ? 10
                                                                        : 0),
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      styleTextFormFieldText(),
                                                                ),
                                                              ),
                                                  ))
                                          .toList(),
                                      value: controller
                                              .selectGender.value.isNotEmpty
                                          ? controller.selectGender.value
                                          : null,
                                      onChanged: (value) {
                                        setState(() {
                                          controller.selectGender.value =
                                              value as String;
                                        });
                                        //controller.validategender(value);
                                      },
                                      itemHeight: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 40
                                          : 45,
                                      dropdownMaxHeight: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? SizerUtil.height / 1.8
                                          : SizerUtil.height / 1,
                                      dropdownDecoration: BoxDecoration(
                                        color: isDarkMode()
                                            ? darkBackgroundColor
                                            : white,
                                        borderRadius:
                                            BorderRadius.circular(2.h),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 10.0,
                                              offset: const Offset(0, 1),
                                              spreadRadius: 3.0)
                                        ],
                                      ),
                                      icon: Container(
                                        padding: EdgeInsets.only(
                                            right: SizerUtil.deviceType ==
                                                    DeviceType.mobile
                                                ? 10
                                                : 3.w),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 30
                                              : 40,
                                          color: isDarkMode()
                                              ? white
                                              : black.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                        )),
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                          
                            left: SizerUtil.deviceType == DeviceType.mobile
                                ? 8.w
                                : 0,
                            right: SizerUtil.deviceType == DeviceType.mobile
                                ? 8.w
                                : 0,
                          ),
                          child: FadeInUp(
                            from: 50,
                            child: Obx(() {
                              return getSecondaryFormButton(() {
                                if (controller.isFormInvalidate.value == true) {
                                  controller.editProfileApi(context);
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
