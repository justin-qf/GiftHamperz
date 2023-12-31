import 'package:flutter/material.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';

styleTextFormFieldText() {
  return TextStyle(
    fontFamily: fontRegular,
    color: isDarkMode() ? white : black,
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
  );
}

styleTextForFieldLabel(usernameNode) {
  return TextStyle(
    fontFamily: fontRegular,
    color: usernameNode.hasFocus ? primaryColor : black,
    fontSize: 12.sp,
  );
}

styleTextHintFieldLabel() {
  return TextStyle(
      fontFamily: fontRegular,
      fontWeight: FontWeight.w500,
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 9.sp,
      color: const Color.fromARGB(255, 145, 145, 145));
}

styleTextForFieldHintDropDown() {
  return TextStyle(
      fontFamily: fontRegular,
      fontWeight: FontWeight.w500,
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 9.sp,
      color: const Color.fromARGB(255, 145, 145, 145));
}

styleTextForFieldHint() {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 8.sp,
      color: const Color.fromARGB(255, 145, 145, 145));
}

styleTitle() {
  //mavan pro
  return TextStyle(
      fontFamily: fontExtraBold,
      color: isDarkMode() ? white : headingTextColor,
      fontWeight: FontWeight.w900,
      fontSize: 26.sp);
}

styleTitleSubtaxt() {
  return TextStyle(
      fontFamily: fontExtraBold,
      color: isDarkMode() ? white.withOpacity(0.3) : headingTextColor,
      fontWeight: isDarkMode() ? FontWeight.w900 : FontWeight.w600,
      fontSize: 11.sp);
}

styleForBottomTextOne(context) {
  return TextStyle(
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 11.sp : 8.sp,
      fontWeight: FontWeight.w100,
      fontFamily: fontRegular,
      color: isDarkMode() ? white : secondaryColor);
}

styleForBottomTextTwo() {
  return TextStyle(
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 11.sp : 8.sp,
      fontWeight: FontWeight.w600,
      fontFamily: fontRegular,
      color: secondaryColor);
}

styleDidtReceiveOTP(context) {
  return TextStyle(
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 11.5.sp : 9.sp,
      fontWeight: FontWeight.w100,
      fontFamily: fontRegular,
      color: isDarkMode() ? white : labelTextColor);
}

styleResentButton() {
  return TextStyle(
      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 11.5.sp : 9.sp,
      fontFamily: fontMedium,
      color: isDarkMode() ? white : secondaryColor);
}
