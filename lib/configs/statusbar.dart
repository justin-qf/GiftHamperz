import 'package:flutter/services.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/utils/helper.dart';

class Statusbar {
  void trasparentStatusbar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          isDarkMode() ? Brightness.light : Brightness.dark,
      statusBarColor: isDarkMode() ? darkBackgroundColor : transparent,
      statusBarBrightness: isDarkMode() ? Brightness.dark : Brightness.light,
    ));
  }

  void trasparentStatusbarProfile(bool isLightStatusBar) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          isLightStatusBar ? Brightness.light : Brightness.dark,
      statusBarColor: transparent,
      statusBarBrightness: isDarkMode() ? Brightness.dark : Brightness.light,
    ));
  }

  void trasparentStatusbarIsNormalScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          isDarkMode() ? Brightness.light : Brightness.dark,
      statusBarColor: isDarkMode() ? darkBackgroundColor : transparent,
      statusBarBrightness: isDarkMode() ? Brightness.dark : Brightness.light,
    ));
  }

  void trasparentBottomsheetStatusbar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: transparent,
    ));
  }
}
