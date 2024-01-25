import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddAddressScreen.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:gifthamperz/views/IntroScreen/intro.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:gifthamperz/views/ReviewsScreen/ReviewsScreen.dart';
import 'package:sizer/sizer.dart';
import '../../../configs/assets_constant.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    UserPreferences().setGuestUserDialogVisible(false);
    Timer(const Duration(seconds: 3), () async {
      UserData? retrievedObject = await UserPreferences().getSignInInfo();
      // if (retrievedObject != null) {
      //   Get.offAll(const BottomNavScreen());
      // } else {
      //   Get.offAll(const IntroScreen());
      // }
      Get.offAll(const BottomNavScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isDarkMode()
                  ? [darkBackgroundColor, primaryColor]
                  : const [white, white],
              // end: FractionalOffset(0.8, 0.0),
              begin: const Alignment(1.0, 0.0),
              end: const Alignment(1.0, 1.7),
              stops: const [0.2, 0.8],
              tileMode: TileMode.clamp)),
      height: SizerUtil.height,
      width: SizerUtil.width,
      child: Center(
        child: SvgPicture.asset(Asset.logo,
            fit: BoxFit.cover,
            width: SizerUtil.deviceType == DeviceType.mobile ? 190 : 500),
      ),
    );
  }
}
