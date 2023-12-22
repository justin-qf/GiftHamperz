import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'custom_text_field.dart';

enum FieldType { Email, Mobile, Text, DropDownl, countryCode }

Widget getReactiveFormField(
    {required node,
    required controller,
    required hintLabel,
    required void Function(String? val) onChanged,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    required TextInputType inputType,
    FieldType? formType,
    Function? onVerifyButtonClick,
    bool? isVerified,
    bool? wantSuffix,
    bool? isDataValidated,
    Function? onTap,
    Function? onAddBtn,
    bool? isStarting,
    bool? isAdd,
    bool? isPhoto,
    bool? isDropdown,
    bool? isCalender,
    bool? isPass,
    bool? isReport,
    bool? isdown,
    bool obscuretext = false,
    bool isFromAddStory = false,
    bool isFromIntro = false,
    bool isEnable = true,
    bool isAddress = false,
    bool isSearch = false,
    bool isReview = false,
    String? fromObsecureText,
    String? index,
    bool isReference = false}) {
  return Container(
    margin: isReview == true
        ? EdgeInsets.only(
            right: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 1.2.w,
            top: SizerUtil.deviceType == DeviceType.mobile ? 1.h : 1.2.w,
            bottom: SizerUtil.deviceType == DeviceType.mobile ? 1.h : 1.2.w,
          )
        : EdgeInsets.symmetric(
            horizontal: isFromIntro
                ? SizerUtil.deviceType == DeviceType.mobile
                    ? 7.5.w
                    : 5.5.w
                : isSearch == true
                    ? 0.2.w
                    : 7.5.w,
            vertical: 0.90.h),
    child: CustomFormField(
        index: index,
        fromObsecureText: fromObsecureText,
        hintText: hintLabel,
        errorText: errorText,
        node: node,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        inputType: inputType,
        formType: formType,
        controller: controller,
        isAddressField: isAddress,
        onVerifiyButtonClick: onVerifyButtonClick,
        isVerified: isVerified,
        isStarting: isStarting,
        isDropdown: isDropdown,
        isCalender: isCalender,
        isPass: isPass,
        isAdd: isAdd,
        isdown: isdown,
        wantSuffix: wantSuffix,
        isReport: isReport,
        onTap: onTap,
        onAddBtn: onAddBtn,
        obsecuretext: obscuretext,
        isReferenceField: isReference,
        isFromAddStory: isFromAddStory,
        isEnable: isEnable),
  );
}
