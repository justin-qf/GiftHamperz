import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class ProductDetailScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController etworkManager = Get.find<InternetController>();
  RxList treeList = [].obs;
  var pageController = PageController();
  var currentPage = 0;
  var quantity = 0;
  
  late Timer timer;

  RxList<SavedItem> staticData = <SavedItem>[
    SavedItem(
        icon: Image.asset(
          Asset.itemOne,
          fit: BoxFit.cover,
        ),
        price: '\$19.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemTwo,
          fit: BoxFit.cover,
        ),
        price: '\$30.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemThree,
          fit: BoxFit.cover,
        ),
        price: '\$35.99 -\$29.99',
        name: "Unicorn Roses -12 Long Stemmed tie Dyed Roses"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$50.99 -\$29.99',
        name: "Unicorn Roses -12 Long Stemmed tie Dyed Roses"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFive,
          fit: BoxFit.cover,
        ),
        price: '\$60.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemSix,
          fit: BoxFit.cover,
        ),
        price: '\$70.99 -\$29.99',
        name: "Unicorn Roses -12 Long Stemmed tie Dyed Roses"),
    SavedItem(
        icon: Image.asset(
          Asset.itemSeven,
          fit: BoxFit.cover,
        ),
        price: '\$90.99 -\$29.99',
        name: "Unicorn Roses -12 Long Stemmed tie Dyed Roses")
  ].obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  List<Widget> bannerItems = [
    Image.asset(
      'assets/pngs/slide_one.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/pngs/slide_two.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/pngs/slide_three.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/pngs/slide_four.jpg',
      fit: BoxFit.cover,
    ),
  ];

  getFilterUi() {
    return GestureDetector(
      onTap: () {
        Get.to(const FilterScreen());
      },
      child: Container(
          width: 30.w,
          height: 5.5.h,
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: const Offset(0,
                    3), // Offset in the vertical direction (adjust as needed)
              ),
            ],
            borderRadius: BorderRadius.circular(
                SizerUtil.deviceType == DeviceType.mobile ? 10.w : 2.2.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filter",
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 13.sp,
                ),
              ),
              getDynamicSizedBox(width: 0.5.w),
              Icon(
                Icons.tune_rounded,
                size: 3.h,
                color: primaryColor,
              )
            ],
          )),
    );
  }

  getItemListItem(SavedItem data) {
    return Obx(
      () {
        return FadeInUp(
          child: Container(
              width: 65.w,
              margin: EdgeInsets.only(right: 4.5.w),
              // padding: EdgeInsets.only(
              //     left: 5.w, right: 5.w, top: 5.w, bottom: 10.w),
              decoration: BoxDecoration(
                border: isDarkMode()
                    ? null
                    : Border.all(
                        color: grey, // Border color
                        width: 0.5, // Border width
                      ),
                color: isDarkMode() ? itemDarkBackgroundColor : white,
                borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                // boxShadow: [
                //   BoxShadow(
                //       color: black.withOpacity(0.05),
                //       blurRadius: 10.0,
                //       offset: const Offset(0, 5))
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.2.h, right: 1.w, left: 1.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24.h,
                        padding: EdgeInsets.only(top: 0.2.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 3.5.w
                                  : 2.5.w),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 3.5.w
                                  : 2.5.w),
                          child: data.icon,
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      getText(
                        data.name,
                        TextStyle(
                            fontFamily: fontSemiBold,
                            color: isDarkMode() ? white : black,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 12.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                      getDynamicSizedBox(
                        height: 0.5.h,
                      ),
                      getText(
                        data.price,
                        TextStyle(
                            fontFamily: fontBold,
                            color: primaryColor,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 4.w,
                            // itemPadding:
                            //     const EdgeInsets.symmetric(horizontal: 5.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {
                              logcat("RATING", rating);
                            },
                          ),
                          getText(
                            "(35)",
                            TextStyle(
                                //fontFamily: fontMedium,
                                color: lableColor,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 9.sp
                                        : 7.sp,
                                height: 1.2),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              data.isSelected.value = !data.isSelected.value;
                              update();
                            },
                            child: Icon(
                              data.isSelected.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border,
                              size: 3.h,
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                      getDynamicSizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        softWrap: true,
        maxLines: 2,
      ),
    );
  }

  Widget getLableText(text, {isMainTitle}) {
    return Text(text,
        style: TextStyle(
          color: isDarkMode() ? white : black,
          fontFamily: isMainTitle == true ? fontBold : null,
          fontWeight: isMainTitle == true ? FontWeight.w900 : FontWeight.w500,
          fontSize: isMainTitle == true ? 17.sp : 12.sp,
        ));
  }

  Widget getCommonText(title, {bool? isHint}) {
    return Text(
      title,
      style: isHint == true
          ? TextStyle(
              //fontFamily: fontRegular,
              color: lableColor,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 9.sp : 10.sp,
            )
          : TextStyle(
              //fontFamily: fontBold,
              color: black,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
            ),
    );
  }

  Widget getColorText(title, {bool? isReviews}) {
    return Text(title,
        style: TextStyle(
          //fontFamily: fontBold,
          fontWeight: FontWeight.w400,
          color: isReviews == true ? primaryColor : Colors.green,
          fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
        ));
  }

  getListItem(HomeItem data) {
    return Container(
        width: 65.w,
        margin: EdgeInsets.only(left: 3.w, right: 3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile
                          ? 3.5.w
                          : 2.5.w),
                ),
                child: data.icon,
              ),
              Positioned(
                top: 2.h,
                left: 5.w,
                child: FadeInUp(
                  child: Text(data.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: fontMedium,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
