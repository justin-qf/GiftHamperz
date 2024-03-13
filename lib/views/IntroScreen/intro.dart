import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/controller/intro_controller.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:sizer/sizer.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var ctr = Get.put(IntroController());

  @override
  void initState() {
    ctr.startAutoScroll();
    super.initState();
  }

  @override
  void dispose() {
    ctr.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarProfile(true);
    return GetBuilder<InternetController>(builder: (internetCtr) {
      // ignore: unrelated_type_equality_checks
      if (internetCtr.connectivity == ConnectivityResult.none) {
        return checkInternet();
      }
      return Scaffold(
        body: Stack(
          children: [
            Obx(() {
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: PageView.builder(
                      itemBuilder: (context, index) {
                        return ctr
                            .getSliderPage(ctr.sliderDataList[index].imgPath);
                      },
                      itemCount: ctr.sliderDataList.length,
                      physics: const ClampingScrollPhysics(),
                      controller: ctr.pageController,
                      onPageChanged: (int page) {
                        ctr.currentPage.value = page;
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 30,
                      right: 30,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInUp(
                              child: Text(
                                  ctr.currentPage.value == 0
                                      ? IntroPageConstant.introOneTitle
                                      : ctr.currentPage.value == 1
                                          ? IntroPageConstant.introTwoTitle
                                          : IntroPageConstant.introTHreeTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontFamily: fontBold,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18.sp,
                                  )),
                            ),
                            getDynamicSizedBox(height: 3.h),
                            FadeInUp(
                              child: Text(
                                  ctr.currentPage.value == 0
                                      ? IntroPageConstant.introOneDesc
                                      : ctr.currentPage.value == 1
                                          ? IntroPageConstant.introTwoDesc
                                          : ctr.currentPage.value == 1
                                              ? IntroPageConstant.introThreeDesc
                                              : IntroPageConstant
                                                  .introThreeDesc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                    fontFamily: fontBold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  )),
                            ),
                            getDynamicSizedBox(height: 5.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: ctr.buildPageIndicator(),
                            ),
                            getDynamicSizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                getFormButton(() {
                                  Get.offAll(const DashboardScreen());
                                }, IntroPageConstant.home, isWhite: false),
                                // getFormButton(() {
                                //   Get.to(const LoginScreen());
                                // }, IntroPageConstant.signIn, isWhite: true),
                                // getDynamicSizedBox(width: 3.w),
                                // getFormButton(() {
                                //   //Get.to(const RegistrationScreen());
                                //   Get.to(const SignUpScreen());
                                // }, IntroPageConstant.signUp, isWhite: false),
                              ],
                            ),
                            getDynamicSizedBox(height: 5.h),
                          ],
                        ),
                      ))
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}
