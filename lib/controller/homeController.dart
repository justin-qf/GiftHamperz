import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/BannerModel.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CategoryScreen/SubCategoryScreen.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import '../models/categoryModel.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class HomeScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isExpanded = false.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  RxList treeList = [].obs;
  var pageController = PageController();
  var currentPage = 0;
  late Timer timer;
  late TextEditingController searchCtr;
  bool isSearch = false;

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  List<HomeItem> staticData = <HomeItem>[
    HomeItem(
        icon: Image.asset(
          Asset.itemOne,
          height: 15.h,
          width: 15.h,
          fit: BoxFit.cover,
        ),
        price: '\$19.99 -\$29.99',
        name: 'Flower Lovers'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemTwo,
          fit: BoxFit.cover,
        ),
        price: '\$30.99 -\$29.99',
        name: 'Birthday Gifts'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemThree,
          fit: BoxFit.cover,
        ),
        price: '\$85.99 -\$90.99',
        name: "Occations"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$35.99 -\$55.99',
        name: "Flower Lovers"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFive,
          fit: BoxFit.cover,
        ),
        price: '\$39.99 -\$54.99',
        name: 'Birthday Gifts'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$58.99 -\$62.99',
        name: "Occations"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemSix,
          fit: BoxFit.cover,
        ),
        price: '\$87.99 -\$67.99',
        name: "Flower Lovers")
  ];

  List<Widget> bannerItems = [
    Image.asset(
      Asset.homeSlideOne,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideTwo,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideThree,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideFour,
      fit: BoxFit.cover,
    ),
  ];

  // List<CategoryItem> categoryList = <CategoryItem>[
  //   CategoryItem(
  //       icon: Image.asset(
  //         'assets/pngs/Birthday_gift.jpg',
  //         height: 11.h,
  //         width: 11.h,
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Birthdays'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/Anniversary_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Anniversaries'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/wedding_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Weddings"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/babyshower_gift.png',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Baby Showers"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/Engagement_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Engagements'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/graduation_gift.jpeg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Graduations"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/valentine_gift.png',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Valentine's Day")
  // ];

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  getCategoryListItem(CategoryData item) {
    return FadeInUp(
        child: GestureDetector(
            onTap: () {
              Get.to(SubCategoryScreen(
                categoryId: item.id.toString(),
              ));
            },
            child: Container(
                width: 11.h,
                margin: EdgeInsets.only(right: 4.w),
                padding: EdgeInsets.all(1.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                          //color: Colors.grey[300],
                          border: isDarkMode()
                              ? null
                              : Border.all(
                                  color: grey, // Border color
                                  width: 0.5, // Border width
                                ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 9.h,
                              imageUrl: APIImageUrl.url + item.thumbnailUrl,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Asset.productPlaceholder,
                                height: 9.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      getDynamicSizedBox(height: 0.5.h),
                      item.name.length > 9
                          ? Expanded(
                              child: Marquee(
                                style: TextStyle(
                                  fontFamily: fontRegular,
                                  color: isDarkMode() ? white : black,
                                  fontSize: 12.sp,
                                ),
                                text: item.name,
                                scrollAxis: Axis
                                    .horizontal, // Use Axis.vertical for vertical scrolling
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Adjust as needed
                                blankSpace:
                                    20.0, // Adjust the space between text repetitions
                                velocity: 50.0, // Adjust the scrolling speed
                                pauseAfterRound: const Duration(
                                    seconds:
                                        1), // Time to pause after each scroll
                                startPadding:
                                    10.0, // Adjust the initial padding
                                accelerationDuration: const Duration(
                                    seconds: 1), // Duration for acceleration
                                accelerationCurve:
                                    Curves.linear, // Acceleration curve
                                decelerationDuration: const Duration(
                                    milliseconds:
                                        500), // Duration for deceleration
                                decelerationCurve:
                                    Curves.easeOut, // Deceleration curve
                              ),
                            )
                          : Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontRegular,
                                color: isDarkMode() ? white : black,
                                fontSize: 12.sp,
                              ),
                            )
                    ]))));
  }

  getListItem(CommonProductList data) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(ProductDetailScreen(
                'Trending',
                data: data,
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                  width: 45.w,
                  margin: EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
                  padding: EdgeInsets.only(
                      left: 1.2.w, right: 1.2.w, top: 1.2.w, bottom: 1.h),
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
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: black.withOpacity(0.1),
                    //       blurRadius: 10.0,
                    //       offset: const Offset(0, 5))
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
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
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 15.h,
                                imageUrl: APIImageUrl.url + data.images,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.placeholder,
                                  height: 9.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 3.w,
                            top: 1.0.h,
                            child: GestureDetector(
                              onTap: () {
                                // data.isSelected.value =
                                //     !data.isSelected.value;
                                update();
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 3.h,
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      getText(
                        data.name,
                        TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: fontSemiBold,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode() ? white : black,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
                                : 8.sp,
                            height: 1.2),
                      ),
                      getDynamicSizedBox(
                        height: 0.5.h,
                      ),
                      getText(
                        '${data.sku}\u20B9',
                        TextStyle(
                            fontFamily: fontBold,
                            color: primaryColor,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
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
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              onRatingUpdate: (rating) {
                                logcat("RATING", rating);
                              },
                            ),
                          ),
                          getText(
                            "35 Reviews",
                            TextStyle(
                                fontFamily: fontSemiBold,
                                color: lableColor,
                                fontWeight:
                                    isDarkMode() ? FontWeight.w600 : null,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 9.sp
                                        : 7.sp,
                                height: 1.2),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        maxLines: 2,
      ),
    );
  }

  getSpecialDeal(CommonProductList data) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(ProductDetailScreen(
                'Trending',
                data: data,
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                  width: 65.w,
                  margin: EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
                  padding: EdgeInsets.only(
                      left: 1.2.w, right: 1.2.w, top: 1.2.w, bottom: 1.h),
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
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black.withOpacity(0.05),
                    //       blurRadius: 10.0,
                    //       offset: const Offset(0, 5))
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
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
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 15.h,
                                imageUrl: APIImageUrl.url + data.images,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.placeholder,
                                  height: 9.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 3.w,
                            top: 1.0.h,
                            child: GestureDetector(
                              onTap: () {
                                // data.isSelected.value =
                                //     !data.isSelected.value;
                                update();
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 3.h,
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      getText(
                        data.name,
                        TextStyle(
                            fontFamily: fontSemiBold,
                            fontWeight: FontWeight.w500,
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
                        '${data.sku}\u20B9',
                        TextStyle(
                            fontFamily: fontBold,
                            color: primaryColor,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
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
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              onRatingUpdate: (rating) {
                                logcat("RATING", rating);
                              },
                            ),
                          ),
                          getText(
                            "35 Reviews",
                            TextStyle(
                                fontFamily: fontSemiBold,
                                color: lableColor,
                                fontWeight:
                                    isDarkMode() ? FontWeight.w600 : null,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 9.sp
                                        : 7.sp,
                                height: 1.2),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  RxList categoryList = [].obs;
  void getCategoryList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, ApiUrl.getCategory, list: true);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = CategoryModel.fromJson(responseData);
          categoryList.clear();
          if (categoryData.data.data.isNotEmpty) {
            categoryList.addAll(categoryData.data.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, CategoryScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  RxList bannerList = [].obs;
  void getBannerList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, ApiUrl.banner, list: true);
      logcat("BANNER_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var bannerData = BannerModel.fromJson(responseData);
          bannerList.clear();
          if (bannerData.data.isNotEmpty) {
            bannerList.addAll(bannerData.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.home, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.home, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    }
  }

  RxList trendingItemList = [].obs;
  RxList topItemList = [].obs;
  RxList popularItemList = [].obs;
  void getHome(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, ApiUrl.getHome, list: true);
      logcat("HOME_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var homeData = HomeModel.fromJson(responseData);
          trendingItemList.clear();
          topItemList.clear();
          popularItemList.clear();
          if (homeData.data.trendList.isNotEmpty) {
            trendingItemList.addAll(homeData.data.trendList);
            update();
          }
          if (homeData.data.topList.isNotEmpty) {
            topItemList.addAll(homeData.data.topList);
            update();
          }
          if (homeData.data.popularList.isNotEmpty) {
            popularItemList.addAll(homeData.data.popularList);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.home, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.home, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    }
  }
}
