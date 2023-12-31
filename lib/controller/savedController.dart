import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/filter_controller.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class SavedScreenController extends GetxController {
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
  late Timer timer;
  late TextEditingController searchCtr;
  bool isSearch = false;
  RxList<SavedItem> filterList = <SavedItem>[].obs;

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  final RxString searchQuery = ''.obs; // For storing the search query
  RxList<SavedItem> get filteredList {
    if (searchQuery.isEmpty) {
      update();
      return staticList;
    } else {
      update();
      return staticList
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  final RxList<SavedItem> staticList = <SavedItem>[
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
        name: 'Birthday\nGifts'),
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
        name: "Flower\nLovers"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFive,
          fit: BoxFit.cover,
        ),
        price: '\$60.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemOne,
          fit: BoxFit.cover,
        ),
        price: '\$70.99 -\$29.99',
        name: "Occations"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$90.99 -\$29.99',
        name: "Flower\nLovers")
  ].obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  getFilterUi() {
    return GestureDetector(
      onTap: () {
        Get.to(const FilterScreen());
      },
      child: Container(
          width: 30.w,
          height: 5.5.h,
          decoration: BoxDecoration(
            color: isDarkMode() ? darkBackgroundColor : white,
            boxShadow: [
              BoxShadow(
                color: isDarkMode()
                    ? grey.withOpacity(0.3)
                    : grey.withOpacity(0.5), // Shadow color
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
                  color: isDarkMode() ? white : black,
                  fontWeight: FontWeight.w400,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 13.sp,
                ),
              ),
              getDynamicSizedBox(width: 0.5.w),
              Icon(
                Icons.tune_rounded,
                size: 3.h,
                color: isDarkMode() ? white : primaryColor,
              )
            ],
          )),
    );
  }

  getItemListItem(SavedItem data) {
    return Obx(
      () {
        return FadeInUp(
          child: Wrap(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
                  padding:
                      EdgeInsets.only(left: 1.2.w, right: 1.2.w, top: 1.2.w),
                  decoration: BoxDecoration(
                    border: isDarkMode()
                        ? null
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    color: isDarkMode() ? itemDarkBackgroundColor : white,
                    borderRadius: BorderRadius.circular(
                        SizerUtil.deviceType == DeviceType.mobile
                            ? 4.w
                            : 2.2.w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                            fontWeight: FontWeight.w500,
                            color: isDarkMode() ? white : black,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
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
                                ? 9.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                      getDynamicSizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RatingBar.builder(
                              initialRating: 3.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 3.5.w,
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
                          ),
                          Expanded(
                            child: getText(
                              "35 Reviews",
                              TextStyle(
                                  fontFamily: fontSemiBold,
                                  color: lableColor,
                                  fontWeight:
                                      isDarkMode() ? FontWeight.w900 : null,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 8.sp
                                          : 7.sp,
                                  height: 1.2),
                            ),
                          ),
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
              ),
            ],
          ),
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
      ),
    );
  }

  AnimationController? animateController;
  getFilterBottomSheet(BuildContext context) {
    var controller = Get.put(FilterController());
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: isDarkMode() ? darkBackgroundColor : white,
      transitionAnimationController: animateController!,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.w),
        topRight: Radius.circular(10.w),
      )),
      constraints: BoxConstraints(
          maxWidth: SizerUtil.width // here increase or decrease in width
          ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding:
                EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h, bottom: 2.h),
            child: Container(
              color: isDarkMode() ? darkBackgroundColor : transparent,
              child: Column(
                children: [
                  getFilterToolbar(FilterScreenConstant.title, isFilter: true,
                      callback: () {
                    Navigator.pop(context);
                  }),
                  getDynamicSizedBox(height: 1.h),
                  getDivider(),
                  getDynamicSizedBox(height: 1.h),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        getDynamicSizedBox(height: 1.h),
                        getLable(FilterScreenConstant.type, isFromFilter: true),
                        getDynamicSizedBox(height: 2.h),
                        Obx(
                          () {
                            return Container(
                              margin: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  childAspectRatio: 4,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      controller.flowersList.length, (index) {
                                    return controller.getRoundShapCheckBox(
                                        controller.flowersList[index]);
                                  })),
                            );
                          },
                        ),
                        getDynamicSizedBox(height: 1.h),
                        getLable(FilterScreenConstant.occassions,
                            isFromFilter: true),
                        getDynamicSizedBox(height: 2.h),
                        Obx(
                          () {
                            return Container(
                              margin: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  childAspectRatio: 4,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      controller.occassionList.length, (index) {
                                    return controller.getRoundShapCheckBox(
                                        controller.occassionList[index]);
                                  })),
                            );
                          },
                        ),
                        getDynamicSizedBox(height: 1.h),
                        getLable(FilterScreenConstant.color,
                            isFromFilter: true),
                        getDynamicSizedBox(height: 2.h),
                        Obx(
                          () {
                            return Container(
                              margin: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  childAspectRatio: 4,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      controller.colorsList.length, (index) {
                                    return controller
                                        .getRoundShapCheckBoxWithColors(
                                            controller.colorsList[index]);
                                  })),
                            );
                          },
                        ),
                        getDynamicSizedBox(height: 2.h),
                        getPriceLable(
                            controller.startValue.toStringAsFixed(2).toString(),
                            controller.endValue.toStringAsFixed(2).toString()),
                        SfRangeSliderTheme(
                            data: SfRangeSliderThemeData(
                              activeLabelStyle: TextStyle(
                                color: isDarkMode()
                                    ? priceRangeBackgroundColor
                                    : grey,
                                fontSize: 12.sp,
                                fontFamily: fontBold,
                              ),
                              inactiveLabelStyle: TextStyle(
                                color: isDarkMode()
                                    ? priceRangeBackgroundColor.withOpacity(0.5)
                                    : grey,
                                fontFamily: fontBold,
                                fontSize: 12.sp,
                              ),
                            ),
                            child: SfRangeSlider(
                              min: 0.0,
                              max: 200,
                              values: controller.values,
                              interval: 50,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              minorTicksPerInterval: 1,
                              inactiveColor: isDarkMode()
                                  ? priceRangeBackgroundColor
                                  : grey,
                              activeColor: primaryColor,
                              onChanged: (SfRangeValues values) {
                                setState(() {
                                  controller.startValue = values.start;
                                  controller.endValue = values.end;
                                  controller.values = values;
                                });
                              },
                            )),
                        getDynamicSizedBox(height: 5.h),
                        Container(
                          margin: EdgeInsets.only(
                            left: 8.w,
                            right: 8.w,
                          ),
                          child: FadeInUp(
                              from: 50,
                              child: getSecondaryFormButton(
                                  () {}, Button.update,
                                  isvalidate: true)),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
