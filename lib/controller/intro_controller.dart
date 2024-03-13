import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/models/model_intro_list.dart';
import 'package:sizer/sizer.dart';

class IntroController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;
  RxBool isLoading = false.obs;

  RxList<IntroPage> sliderDataList = [
    IntroPage(
      title: 'Welcome to GiftHamperz',
      description:
          'By from thousand of curated gift and delivery\n within 3-5 hours. No matter how far you are.',
      imgPath: Asset.introOne,
    ),
    IntroPage(
      title: 'Features Galore',
      description:
          'Your can buy additional items in a pack, write\n down surprising plan and more..',
      imgPath: Asset.introTwo,
    ),
    IntroPage(
      title: 'Occations',
      description:
          'Create occations and get notifications when\n nearby. You will not miss anything',
      imgPath: Asset.introThree,
    ),
    IntroPage(
      title: 'Get Started',
      description:
          'Create occations and get notifications when\n nearby. You will not miss anything',
      imgPath: Asset.introFour,
    ),
  ].obs;

  void changePage() {
    pageController.animateToPage(currentPage.value + 1,
        duration: const Duration(milliseconds: 250), curve: Curves.bounceInOut);
  }

  Widget getSliderPage(String image) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
    );
  }

  void nextPage() {
    if (currentPage < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < sliderDataList.length; i++) {
      list.add(i == currentPage.value ? indicator(true) : indicator(false));
    }
    return list;
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 1.0.w),
      height: 2.0.w,
      width: isActive ? 4.0.w : 2.0.w,
      decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(50))),
    );
  }

  void startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      nextPage();
    });
  }

  getBlackOverlayGradient() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        gradient: LinearGradient(
          colors: [
            black,
            black.withOpacity(0.4),
            black.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
    );
  }

  getOverlayGradient() {
    return Positioned(
      top: 20.h,
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFffffff),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}
