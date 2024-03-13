import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/main.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';
import '../../../configs/assets_constant.dart';

class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key});

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isDarkMode()
                    ? [darkBackgroundColor, primaryColor]
                    : const [white, white],
                // end: FractionalOffset(0.8, 0.0),
                begin: const Alignment(1.0, 0.0),
                end: const Alignment(1.0, 1.7),
                stops: const [0.2, 0.9],
                tileMode: TileMode.clamp)),
        height: SizerUtil.height,
        width: SizerUtil.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return AnimatedOpacity(
                  opacity: controller.value,
                  duration: const Duration(seconds: 1),
                  child: SvgPicture.asset(Asset.logo,
                      fit: BoxFit.cover,
                      height: SizerUtil.deviceType == DeviceType.mobile
                          ? 25.h
                          : 500),
                );
              },
            ),
            getDynamicSizedBox(height: 3.h),
            FadeInDown(
              child: Text(
                PrepareScreenConstant.title,
                style: TextStyle(
                    fontFamily: fontBold,
                    color: isDarkMode() ? white : headingTextColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.sp),
                textAlign: TextAlign.center,
              ),
            ),
            getDynamicSizedBox(height: 2.h),
            FadeInDown(
              child: Text(
                PrepareScreenConstant.desc,
                style: TextStyle(
                    fontFamily: fontBold,
                    color: isDarkMode() ? white : headingTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5.h,
                left: 8.w,
                right: 8.w,
              ),
              child: FadeInUp(
                from: 50,
                child: getSecondaryFormButton(() {
                  //Get.to(() => const DashboardScreen());
                  Get.to(const MainScreen());
                }, PrepareScreenConstant.btnLable, isvalidate: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
