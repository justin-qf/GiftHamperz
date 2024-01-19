import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/LoginScreen/LoginScreen.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:sizer/sizer.dart';

class CustomRoundedDialog extends StatelessWidget {
  const CustomRoundedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      elevation: 0.0, // No shadow
      backgroundColor: transparent, // Transparent background
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h), // Adjust the margin as needed
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20.0), // Same radius as above
              boxShadow: isDarkMode()
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 1),
                          spreadRadius: 3.0)
                    ],
            ),
            padding:
                EdgeInsets.only(top: 3.h, bottom: 2.h, left: 4.w, right: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDynamicSizedBox(height: 4.h),
                Text(
                  'Order Successfull!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                getDynamicSizedBox(height: 2.h),
                Text(
                  textAlign: TextAlign.center,
                  "Your order has been placed successfull!\nOrder infromation was sent to your email.",
                  style: TextStyle(
                    color: black,
                    fontFamily: fontBold,
                    fontSize: 11.5.sp,
                  ),
                ),
                getDynamicSizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: FadeInUp(
                    from: 50,
                    child: getSecondaryFormButton(() {
                      Navigator.of(context).pop();
                      Get.offAll(const BottomNavScreen());
                    }, Button.continueShopping,
                        isvalidate: true, isFromDialog: true),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: FadeInDown(
              from: 50,
              child: SvgPicture.asset(
                Asset.gift,
                //color: isDarkMode() ? white : black,
                height: SizerUtil.deviceType == DeviceType.mobile ? 15.h : 5.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLoginAlertRoundedDialog extends StatelessWidget {
  const CustomLoginAlertRoundedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      elevation: 0.0, // No shadow
      backgroundColor: transparent, // Transparent background
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h), // Adjust the margin as needed
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20.0), // Same radius as above
              boxShadow: isDarkMode()
                  ? null
                  : [
                      BoxShadow(
                          color: grey.withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 1),
                          spreadRadius: 3.0)
                    ],
            ),
            padding:
                EdgeInsets.only(top: 3.h, bottom: 2.h, left: 4.w, right: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDynamicSizedBox(height: 4.h),
                Text(
                  'Login!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                getDynamicSizedBox(height: 2.h),
                Text(
                  textAlign: TextAlign.center,
                  "Please login for a smooth experience.",
                  style: TextStyle(
                    color: black,
                    fontFamily: fontBold,
                    fontSize: 11.5.sp,
                  ),
                ),
                getDynamicSizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: FadeInUp(
                    from: 50,
                    child: getSecondaryFormButton(() {
                      Get.back();
                      getLoginBottomSheetDialog(context);
                      // Get.to(const LoginScreen())!.then((value) {
                      //   Statusbar().trasparentStatusbarProfile(true);
                      // });
                    }, LoginConst.buttonLabel, isvalidate: true),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 1.5.h,
            child: FadeInDown(
              from: 50,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SvgPicture.asset(
                  Asset.alertLogin,
                  //color: isDarkMode() ? white : black,
                  height:
                      SizerUtil.deviceType == DeviceType.mobile ? 15.h : 10.h,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.5.h,
            right: 2.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: FadeInDown(
                  from: 50,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.clear_outlined,
                      color: white,
                      size:
                          SizerUtil.deviceType == DeviceType.mobile ? 3.h : 5.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
